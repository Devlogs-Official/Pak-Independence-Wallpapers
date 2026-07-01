import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../core/config/config_manager.dart';
import '../core/constants/app_logger.dart';
import 'ad_service.dart';
import 'consent_service.dart';

class AppOpenManager {
  AppOpenManager._();

  static final AppOpenManager instance = AppOpenManager._();

  final AppAdService _adService = AppAdService.instance;

  AppOpenAd? _appOpenAd;
  DateTime? _backgroundedAt;
  DateTime? _lastShownAt;
  bool _isLoading = false;
  bool _isShowing = false;

  void markBackgrounded() {
    _backgroundedAt = DateTime.now();
  }

  Future<void> preload() {
    return _loadAd();
  }

  Future<void> showColdStartAd() {
    return _showAdIfAvailable(isColdStart: true);
  }

  Future<void> showResumeAdIfNeeded() async {
    final backgroundedAt = _backgroundedAt;
    if (backgroundedAt == null) return;

    final config = ConfigManager.config;
    final threshold = Duration(
      seconds: _positiveOrDefault(config.backgroundThresholdSeconds, 5),
    );
    if (DateTime.now().difference(backgroundedAt) < threshold) return;

    await _showAdIfAvailable(isColdStart: false);
  }

  Future<void> _showAdIfAvailable({required bool isColdStart}) async {
    final config = ConfigManager.config;
    if (!config.canShowAppOpen(isColdStart: isColdStart) ||
        _isShowing ||
        !_adService.canShowAppOpenAfterFullscreen ||
        !_hasPassedMinInterval() ||
        !await ConsentService.instance.canRequestAds()) {
      return;
    }

    if (_appOpenAd == null) {
      await _loadAd();
    }

    final ad = _appOpenAd;
    if (ad == null) return;

    _appOpenAd = null;
    _isShowing = true;
    _adService.markAppOpenShown();
    ad.fullScreenContentCallback = FullScreenContentCallback<AppOpenAd>(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _finishShowing();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        AppLogger.error('App open ad failed to show', error: error);
        _finishShowing();
      },
    );

    try {
      await ad.show();
    } catch (error, stackTrace) {
      ad.dispose();
      AppLogger.error(
        'App open ad show threw',
        error: error,
        stackTrace: stackTrace,
      );
      _finishShowing();
    }
  }

  Future<void> _loadAd() async {
    final config = ConfigManager.config;
    if (!config.canLoadAppOpenAd ||
        _isLoading ||
        _appOpenAd != null ||
        !await ConsentService.instance.canRequestAds()) {
      return;
    }

    _isLoading = true;
    final completer = Completer<void>();
    try {
      await AppOpenAd.load(
        adUnitId: config.appOpenId.trim(),
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            _appOpenAd = ad;
            _isLoading = false;
            if (!completer.isCompleted) completer.complete();
          },
          onAdFailedToLoad: (error) {
            _isLoading = false;
            AppLogger.error('App open ad failed to load', error: error);
            if (!completer.isCompleted) completer.complete();
          },
        ),
      );
      await completer.future.timeout(
        const Duration(seconds: 8),
        onTimeout: () {
          _isLoading = false;
          AppLogger.debug('App open ad load timed out');
        },
      );
    } catch (error, stackTrace) {
      _isLoading = false;
      AppLogger.error(
        'App open ad load threw',
        error: error,
        stackTrace: stackTrace,
      );
      if (!completer.isCompleted) completer.complete();
    }
  }

  bool _hasPassedMinInterval() {
    final lastShownAt = _lastShownAt;
    if (lastShownAt == null) return true;

    final config = ConfigManager.config;
    final minInterval = Duration(
      seconds: _positiveOrDefault(config.appOpenMinIntervalSeconds, 15),
    );
    return DateTime.now().difference(lastShownAt) >= minInterval;
  }

  void _finishShowing() {
    _isShowing = false;
    _lastShownAt = DateTime.now();
    _adService.markAppOpenClosed();
    unawaited(_loadAd());
  }

  void dispose() {
    _appOpenAd?.dispose();
    _appOpenAd = null;
  }

  int _positiveOrDefault(int value, int fallback) {
    return value > 0 ? value : fallback;
  }
}