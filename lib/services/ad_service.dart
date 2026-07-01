import 'dart:async';
import 'dart:ui';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../core/config/config_manager.dart';
import '../core/constants/app_logger.dart';
import 'consent_service.dart';

class AppAdService {
  AppAdService._();

  static final AppAdService instance = AppAdService._();

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _isLoadingInterstitial = false;
  bool _isLoadingRewarded = false;
  bool _isShowingFullscreenAd = false;
  bool _isInitialized = false;
  DateTime? _lastFullscreenAdClosedAt;
  int _shareInterstitialAttempts = 0;

  bool get isShowingFullscreenAd => _isShowingFullscreenAd;

  bool get shouldGateWallpaperUnlock =>
      ConfigManager.config.shouldGateWallpaperUnlock;

  bool get canShowAppOpenAfterFullscreen {
    final config = ConfigManager.config;
    final lastClosed = _lastFullscreenAdClosedAt;
    if (_isShowingFullscreenAd || lastClosed == null) {
      return !_isShowingFullscreenAd;
    }

    final minInterval = Duration(
      seconds: _positiveOrDefault(config.appOpenMinIntervalSeconds, 15),
    );
    return DateTime.now().difference(lastClosed) >= minInterval;
  }

  Future<void> initialize() async {
    try {
      if (!await ConsentService.instance.canRequestAds()) {
        AppLogger.debug(
          'Skipping Google Mobile Ads initialization until consent allows ads',
        );
        return;
      }

      await MobileAds.instance.initialize();
      _isInitialized = true;
      unawaited(loadInterstitialAd());
      unawaited(loadRewardedAd());
    } catch (error, stackTrace) {
      AppLogger.error(
        'Google Mobile Ads initialization failed',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<NativeAd?> loadNativeAd() async {
    final config = ConfigManager.config;
    if (!config.canShowNativeAds || !await _canLoadAds()) return null;

    final completer = Completer<NativeAd?>();
    late final NativeAd nativeAd;

    nativeAd = NativeAd(
      adUnitId: config.nativeId.trim(),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: const Color(0xFFFFFFFF),
        cornerRadius: 18,
      ),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (!completer.isCompleted) {
            completer.complete(ad as NativeAd);
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          AppLogger.error('Native ad failed to load', error: error);
          if (!completer.isCompleted) completer.complete(null);
        },
      ),
    );

    try {
      await nativeAd.load();
    } catch (error, stackTrace) {
      nativeAd.dispose();
      AppLogger.error(
        'Native ad load threw',
        error: error,
        stackTrace: stackTrace,
      );
      if (!completer.isCompleted) completer.complete(null);
    }

    return completer.future.timeout(
      const Duration(seconds: 12),
      onTimeout: () {
        nativeAd.dispose();
        return null;
      },
    );
  }

  Future<void> loadInterstitialAd() async {
    final config = ConfigManager.config;
    if (!config.canShowInterstitialOnApplyWallpaper ||
        _isLoadingInterstitial ||
        _interstitialAd != null ||
        !await _canLoadAds()) {
      return;
    }

    _isLoadingInterstitial = true;
    final completer = Completer<void>();
    try {
      await InterstitialAd.load(
        adUnitId: config.interstitialId.trim(),
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            _isLoadingInterstitial = false;
            if (!completer.isCompleted) completer.complete();
          },
          onAdFailedToLoad: (error) {
            _isLoadingInterstitial = false;
            AppLogger.error('Interstitial ad failed to load', error: error);
            if (!completer.isCompleted) completer.complete();
          },
        ),
      );
      await completer.future.timeout(
        const Duration(seconds: 8),
        onTimeout: () {
          _isLoadingInterstitial = false;
          AppLogger.debug('Interstitial ad load timed out');
        },
      );
    } catch (error, stackTrace) {
      _isLoadingInterstitial = false;
      AppLogger.error(
        'Interstitial ad load threw',
        error: error,
        stackTrace: stackTrace,
      );
      if (!completer.isCompleted) completer.complete();
    }
  }

  Future<void> showInterstitialThen({
    required FutureOr<void> Function() onCompleted,
  }) async {
    await _showInterstitialIfAllowed(
      canShow: ConfigManager.config.canShowInterstitialOnApplyWallpaper,
      onCompleted: onCompleted,
    );
  }

  Future<void> showInterstitialForWallpaperApplyThen({
    required FutureOr<void> Function() onCompleted,
  }) {
    return _showInterstitialIfAllowed(
      canShow: ConfigManager.config.canShowInterstitialOnApplyWallpaper,
      onCompleted: onCompleted,
    );
  }

  Future<void> showInterstitialForShareThen({
    required FutureOr<void> Function() onCompleted,
  }) async {
    _shareInterstitialAttempts++;
    final shouldShowThisAttempt = _shareInterstitialAttempts % 3 == 0;
    await _showInterstitialIfAllowed(
      canShow:
          ConfigManager.config.canShowInterstitialOnShare &&
          shouldShowThisAttempt,
      onCompleted: onCompleted,
    );
  }

  Future<void> showInterstitialForGreetingShareThen({
    required FutureOr<void> Function() onCompleted,
  }) {
    return _showInterstitialIfAllowed(
      canShow: ConfigManager.config.canShowInterstitialOnShare,
      onCompleted: onCompleted,
    );
  }

  Future<void> _showInterstitialIfAllowed({
    required bool canShow,
    required FutureOr<void> Function() onCompleted,
  }) async {
    if (!canShow || !await _canLoadAds()) {
      await onCompleted();
      return;
    }

    if (_interstitialAd == null) {
      await loadInterstitialAd();
    }

    final ad = _interstitialAd;
    if (ad == null) {
      await onCompleted();
      return;
    }

    final completer = Completer<void>();
    _interstitialAd = null;
    ad.fullScreenContentCallback = FullScreenContentCallback<InterstitialAd>(
      onAdShowedFullScreenContent: (_) => _isShowingFullscreenAd = true,
      onAdDismissedFullScreenContent: (ad) async {
        ad.dispose();
        await _finishFullscreenAd(onCompleted);
        if (!completer.isCompleted) completer.complete();
        unawaited(loadInterstitialAd());
      },
      onAdFailedToShowFullScreenContent: (ad, error) async {
        ad.dispose();
        AppLogger.error('Interstitial ad failed to show', error: error);
        await _finishFullscreenAd(onCompleted);
        if (!completer.isCompleted) completer.complete();
        unawaited(loadInterstitialAd());
      },
    );

    try {
      await ad.show();
    } catch (error, stackTrace) {
      ad.dispose();
      AppLogger.error(
        'Interstitial ad show threw',
        error: error,
        stackTrace: stackTrace,
      );
      await _finishFullscreenAd(onCompleted);
      if (!completer.isCompleted) completer.complete();
      unawaited(loadInterstitialAd());
    }

    await completer.future;
  }

  Future<void> loadRewardedAd() async {
    final config = ConfigManager.config;
    if (!config.canLoadRewardedAd ||
        _isLoadingRewarded ||
        _rewardedAd != null ||
        !await _canLoadAds()) {
      return;
    }

    _isLoadingRewarded = true;
    final completer = Completer<void>();
    try {
      await RewardedAd.load(
        adUnitId: config.rewardedId.trim(),
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedAd = ad;
            _isLoadingRewarded = false;
            if (!completer.isCompleted) completer.complete();
          },
          onAdFailedToLoad: (error) {
            _isLoadingRewarded = false;
            AppLogger.error('Rewarded ad failed to load', error: error);
            if (!completer.isCompleted) completer.complete();
          },
        ),
      );
      await completer.future.timeout(
        const Duration(seconds: 8),
        onTimeout: () {
          _isLoadingRewarded = false;
          AppLogger.debug('Rewarded ad load timed out');
        },
      );
    } catch (error, stackTrace) {
      _isLoadingRewarded = false;
      AppLogger.error(
        'Rewarded ad load threw',
        error: error,
        stackTrace: stackTrace,
      );
      if (!completer.isCompleted) completer.complete();
    }
  }

  Future<void> showRewardedThen({
    required FutureOr<void> Function() onRewardEarned,
    FutureOr<void> Function()? onAdUnavailable,
  }) async {
    if (!ConfigManager.config.shouldGateWallpaperUnlock) {
      await onRewardEarned();
      return;
    }

    if (!await _canLoadAds()) {
      await onAdUnavailable?.call();
      return;
    }

    if (_rewardedAd == null) {
      await loadRewardedAd();
    }

    final ad = _rewardedAd;
    if (ad == null) {
      await onAdUnavailable?.call();
      return;
    }

    final completer = Completer<void>();
    var rewardEarned = false;
    _rewardedAd = null;
    ad.fullScreenContentCallback = FullScreenContentCallback<RewardedAd>(
      onAdShowedFullScreenContent: (_) => _isShowingFullscreenAd = true,
      onAdDismissedFullScreenContent: (ad) async {
        ad.dispose();
        _markFullscreenAdClosed();
        if (rewardEarned) await onRewardEarned();
        if (!completer.isCompleted) completer.complete();
        unawaited(loadRewardedAd());
      },
      onAdFailedToShowFullScreenContent: (ad, error) async {
        ad.dispose();
        AppLogger.error('Rewarded ad failed to show', error: error);
        _markFullscreenAdClosed();
        await onAdUnavailable?.call();
        if (!completer.isCompleted) completer.complete();
        unawaited(loadRewardedAd());
      },
    );

    try {
      await ad.show(
        onUserEarnedReward: (ad, reward) {
          rewardEarned = true;
        },
      );
    } catch (error, stackTrace) {
      ad.dispose();
      AppLogger.error(
        'Rewarded ad show threw',
        error: error,
        stackTrace: stackTrace,
      );
      _markFullscreenAdClosed();
      await onAdUnavailable?.call();
      if (!completer.isCompleted) completer.complete();
      unawaited(loadRewardedAd());
    }

    await completer.future;
  }

  void markAppOpenShown() {
    _isShowingFullscreenAd = true;
  }

  void markAppOpenClosed() {
    _markFullscreenAdClosed();
  }

  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _interstitialAd = null;
    _rewardedAd = null;
  }

  Future<void> _finishFullscreenAd(
    FutureOr<void> Function() onCompleted,
  ) async {
    _markFullscreenAdClosed();
    await onCompleted();
  }

  void _markFullscreenAdClosed() {
    _isShowingFullscreenAd = false;
    _lastFullscreenAdClosedAt = DateTime.now();
  }

  Future<bool> _canLoadAds() async {
    if (!_isInitialized) {
      AppLogger.debug('Ad request blocked because Mobile Ads is not ready');
      return false;
    }

    final canRequestAds = await ConsentService.instance.canRequestAds();
    if (!canRequestAds) {
      AppLogger.debug('Ad request blocked because consent is unresolved');
    }
    return canRequestAds;
  }

  int _positiveOrDefault(int value, int fallback) {
    return value > 0 ? value : fallback;
  }
}
