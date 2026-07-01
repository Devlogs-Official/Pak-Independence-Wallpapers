import 'package:flutter/foundation.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../constants/app_logger.dart';
import 'app_config.dart';

class ConfigManager extends ChangeNotifier {
  ConfigManager._();

  static final ConfigManager instance = ConfigManager._();

  AppConfig _config = AppConfig.defaults;

  static AppConfig get config => instance._config;

  AppConfig get current => _config;

  Future<void> initialize() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero,
        ),
      );
      await remoteConfig.setDefaults(AppConfig.remoteDefaults);
      await remoteConfig.ensureInitialized();
      try {
        await remoteConfig.fetchAndActivate();
      } catch (error, stackTrace) {
        AppLogger.error(
          'Remote Config fetch failed',
          error: error,
          stackTrace: stackTrace,
        );
        try {
          await remoteConfig.activate();
        } catch (_) {}
      }
      update(AppConfig.fromRemoteConfig(remoteConfig));
      final configJsonSources = {
        for (final key in AppConfig.configJsonKeys)
          key: remoteConfig.getValue(key).source.name,
      };
      AppLogger.debug(
        'Remote Config loaded',
        data: {
          'apiConfigured': _config.apiBaseUrl.isNotEmpty,
          'showAds': _config.showAds,
          'nativeEnabled': _config.canShowNativeAds,
          'interstitialEnabled': _config.canShowInterstitialOnApplyWallpaper,
          'rewardedEnabled': _config.canLoadRewardedAd,
          'appOpenEnabled': _config.canLoadAppOpenAd,
          'hasAnyAdUnitId': _config.hasAnyRemoteAdUnitId,
          'native': _config.nativeId,
          'interstitial': _config.interstitialId,
          'appOpen': _config.appOpenId,
          'rewarded': _config.rewardedId,
          'configJsonSources': configJsonSources,
        },
      );
      if (!_config.showAds || !_config.hasAnyRemoteAdUnitId) {
        AppLogger.debug(
          'Ads are disabled because Firebase Remote Config did not return the ad config',
          data: {
            'expectedJsonParameter': AppConfig.configJsonKeys.first,
            'source': remoteConfig
                .getValue(AppConfig.configJsonKeys.first)
                .source
                .name,
          },
        );
      }
    } catch (error, stackTrace) {
      AppLogger.error(
        'Remote Config initialization failed',
        error: error,
        stackTrace: stackTrace,
      );
      update(AppConfig.defaults);
    }
  }

  void update(AppConfig config) {
    _config = config;
    notifyListeners();
  }
}
