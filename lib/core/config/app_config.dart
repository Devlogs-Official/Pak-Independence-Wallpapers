import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';

class AppConfig {
  static const List<String> configJsonKeys = <String>[
    'pak_independence_wallpapers_and_cards',
  ];

  static const String apiBaseUrlKey = 'api_base_url';
  static const String bannerIdKey = 'banner_id';
  static const String nativeIdKey = 'native_id';
  static const String interstitialIdKey = 'interstitial_id';
  static const String appOpenIdKey = 'app_open_id';
  static const String rewardedIdKey = 'rewarded_id';
  static const String collapsibleBannerIdKey = 'collapsible_banner_id';
  static const String showAdsKey = 'show_ads';
  static const String showNativeAdsKey = 'show_native_ads';
  static const String showInterstitialAdsKey = 'show_interstitial_ads';
  static const String showAppOpenAdsKey = 'show_app_open_ads';
  static const String showBannerAdsKey = 'show_banner_ads';
  static const String showRewardedAdsKey = 'show_rewarded_ads';
  static const String gridNativeIntervalKey = 'grid_native_interval';
  static const String enableNativeAdsKey = 'enable_native_ads';
  static const String enableGridSquareNativeKey = 'enable_grid_square_native';
  static const String enableGridSquareBannerKey = 'enable_grid_square_banner';
  static const String enableAdaptiveBannerKey = 'enable_adaptive_banner';
  static const String enableCollapsibleBannerKey = 'enable_collapsible_banner';
  static const String collapsibleBannerPositionKey =
      'collapsible_banner_position';
  static const String showNativeOnHomeScreenKey = 'show_native_on_home_screen';
  static const String showNativeInWallpaperGridKey =
      'show_native_in_wallpaper_grid';
  static const String showNativeOnFavoritesScreenKey =
      'show_native_on_favorites_screen';
  static const String showBannerOnHomeScreenKey = 'show_banner_on_home_screen';
  static const String showBannerInWallpaperGridKey =
      'show_banner_in_wallpaper_grid';
  static const String showBannerOnFavoritesScreenKey =
      'show_banner_on_favorites_screen';
  static const String showInterstitialOnApplyWallpaperKey =
      'show_interstitial_on_apply_wallpaper';
  static const String showRewardedOnLiveWallpaperUnlockKey =
      'show_rewarded_on_live_wallpaper_unlock';
  static const String showAppOpenOnColdStartKey = 'show_app_open_on_cold_start';
  static const String showAppOpenOnResumeKey = 'show_app_open_on_resume';
  static const String appOpenMinIntervalSecondsKey =
      'app_open_min_interval_seconds';
  static const String disableAppOpenAfterRewardedKey =
      'disable_app_open_after_rewarded';
  static const String disableAppOpenAfterInterstitialKey =
      'disable_app_open_after_interstitial';
  static const String backgroundThresholdSecondsKey =
      'background_threshold_seconds';
  static const String persistUnlockedWallpapersKey =
      'persist_unlocked_wallpapers';
  static const String showShareTextOnStaticWallpaperKey =
      'show_share_text_on_static_wallpaper';
  static const String showShareTextOnLiveWallpaperKey =
      'show_share_text_on_live_wallpaper';

  const AppConfig({
    required this.apiBaseUrl,
    required this.bannerId,
    required this.nativeId,
    required this.interstitialId,
    required this.appOpenId,
    required this.rewardedId,
    required this.collapsibleBannerId,
    required this.showAds,
    required this.showNativeAds,
    required this.showBannerAds,
    required this.showRewardedAds,
    required this.showInterstitialAds,
    required this.showAppOpenAds,
    required this.gridNativeInterval,
    required this.enableNativeAds,
    required this.enableAdaptiveBanner,
    required this.enableGridSquareNative,
    required this.enableGridSquareBanner,
    required this.enableCollapsibleBanner,
    required this.collapsibleBannerPosition,
    required this.showNativeOnHomeScreen,
    required this.showNativeInWallpaperGrid,
    required this.showNativeOnFavoritesScreen,
    required this.showBannerOnHomeScreen,
    required this.showBannerInWallpaperGrid,
    required this.showBannerOnFavoritesScreen,
    required this.showInterstitialOnApplyWallpaper,
    required this.showRewardedOnLiveWallpaperUnlock,
    required this.showAppOpenOnColdStart,
    required this.showAppOpenOnResume,
    required this.appOpenMinIntervalSeconds,
    required this.disableAppOpenAfterRewarded,
    required this.disableAppOpenAfterInterstitial,
    required this.backgroundThresholdSeconds,
    required this.persistUnlockedWallpapers,
    required this.showShareTextOnStaticWallpaper,
    required this.showShareTextOnLiveWallpaper,
  });

  final String apiBaseUrl;
  final String bannerId;
  final String nativeId;
  final String interstitialId;
  final String appOpenId;
  final String rewardedId;
  final String collapsibleBannerId;
  final bool showAds;
  final bool showNativeAds;
  final bool showBannerAds;
  final bool showRewardedAds;
  final bool showInterstitialAds;
  final bool showAppOpenAds;
  final int gridNativeInterval;
  final bool enableNativeAds;
  final bool enableAdaptiveBanner;
  final bool enableGridSquareNative;
  final bool enableGridSquareBanner;
  final bool enableCollapsibleBanner;
  final String collapsibleBannerPosition;
  final bool showNativeOnHomeScreen;
  final bool showNativeInWallpaperGrid;
  final bool showNativeOnFavoritesScreen;
  final bool showBannerOnHomeScreen;
  final bool showBannerInWallpaperGrid;
  final bool showBannerOnFavoritesScreen;
  final bool showInterstitialOnApplyWallpaper;
  final bool showRewardedOnLiveWallpaperUnlock;
  final bool showAppOpenOnColdStart;
  final bool showAppOpenOnResume;
  final int appOpenMinIntervalSeconds;
  final bool disableAppOpenAfterRewarded;
  final bool disableAppOpenAfterInterstitial;
  final int backgroundThresholdSeconds;
  final bool persistUnlockedWallpapers;
  final bool showShareTextOnStaticWallpaper;
  final bool showShareTextOnLiveWallpaper;

  static const AppConfig defaults = AppConfig(
    apiBaseUrl: '',
    bannerId: '',
    nativeId: '',
    interstitialId: '',
    appOpenId: '',
    rewardedId: '',
    collapsibleBannerId: '',
    showAds: false,
    showNativeAds: false,
    showBannerAds: false,
    showRewardedAds: false,
    showInterstitialAds: false,
    showAppOpenAds: false,
    gridNativeInterval: 14,
    enableNativeAds: false,
    enableAdaptiveBanner: false,
    enableGridSquareNative: false,
    enableGridSquareBanner: false,
    enableCollapsibleBanner: false,
    collapsibleBannerPosition: 'bottom',
    showNativeOnHomeScreen: false,
    showNativeInWallpaperGrid: false,
    showNativeOnFavoritesScreen: false,
    showBannerOnHomeScreen: false,
    showBannerInWallpaperGrid: false,
    showBannerOnFavoritesScreen: false,
    showInterstitialOnApplyWallpaper: false,
    showRewardedOnLiveWallpaperUnlock: false,
    showAppOpenOnColdStart: false,
    showAppOpenOnResume: false,
    appOpenMinIntervalSeconds: 15,
    disableAppOpenAfterRewarded: true,
    disableAppOpenAfterInterstitial: true,
    backgroundThresholdSeconds: 5,
    persistUnlockedWallpapers: false,
    showShareTextOnStaticWallpaper: false,
    showShareTextOnLiveWallpaper: false,
  );

  static Map<String, Object> get remoteDefaults => <String, Object>{
    for (final key in configJsonKeys) key: '',
    apiBaseUrlKey: defaults.apiBaseUrl,
    bannerIdKey: defaults.bannerId,
    nativeIdKey: defaults.nativeId,
    interstitialIdKey: defaults.interstitialId,
    appOpenIdKey: defaults.appOpenId,
    rewardedIdKey: defaults.rewardedId,
    collapsibleBannerIdKey: defaults.collapsibleBannerId,
    showAdsKey: defaults.showAds,
    showNativeAdsKey: defaults.showNativeAds,
    showBannerAdsKey: defaults.showBannerAds,
    showRewardedAdsKey: defaults.showRewardedAds,
    showInterstitialAdsKey: defaults.showInterstitialAds,
    showAppOpenAdsKey: defaults.showAppOpenAds,
    gridNativeIntervalKey: defaults.gridNativeInterval,
    enableNativeAdsKey: defaults.enableNativeAds,
    enableAdaptiveBannerKey: defaults.enableAdaptiveBanner,
    enableGridSquareNativeKey: defaults.enableGridSquareNative,
    enableGridSquareBannerKey: defaults.enableGridSquareBanner,
    enableCollapsibleBannerKey: defaults.enableCollapsibleBanner,
    collapsibleBannerPositionKey: defaults.collapsibleBannerPosition,
    showNativeOnHomeScreenKey: defaults.showNativeOnHomeScreen,
    showNativeInWallpaperGridKey: defaults.showNativeInWallpaperGrid,
    showNativeOnFavoritesScreenKey: defaults.showNativeOnFavoritesScreen,
    showBannerOnHomeScreenKey: defaults.showBannerOnHomeScreen,
    showBannerInWallpaperGridKey: defaults.showBannerInWallpaperGrid,
    showBannerOnFavoritesScreenKey: defaults.showBannerOnFavoritesScreen,
    showInterstitialOnApplyWallpaperKey:
        defaults.showInterstitialOnApplyWallpaper,
    showRewardedOnLiveWallpaperUnlockKey:
        defaults.showRewardedOnLiveWallpaperUnlock,
    showAppOpenOnColdStartKey: defaults.showAppOpenOnColdStart,
    showAppOpenOnResumeKey: defaults.showAppOpenOnResume,
    appOpenMinIntervalSecondsKey: defaults.appOpenMinIntervalSeconds,
    disableAppOpenAfterRewardedKey: defaults.disableAppOpenAfterRewarded,
    disableAppOpenAfterInterstitialKey:
        defaults.disableAppOpenAfterInterstitial,
    backgroundThresholdSecondsKey: defaults.backgroundThresholdSeconds,
    persistUnlockedWallpapersKey: defaults.persistUnlockedWallpapers,
    showShareTextOnStaticWallpaperKey: defaults.showShareTextOnStaticWallpaper,
    showShareTextOnLiveWallpaperKey: defaults.showShareTextOnLiveWallpaper,
  };

  factory AppConfig.fromRemoteConfig(FirebaseRemoteConfig remoteConfig) {
    final root = _readConfigJson(remoteConfig);
    final ads = _asMap(_asMap(root['ads'])['android']);
    final features = _asMap(root['features']);
    final adSettings = _asMap(root['adSettings']);
    final wallpaper = _asMap(root['wallpaper']);
    final ui = _asMap(root['ui']);

    return AppConfig(
      apiBaseUrl: _readString(
        _remoteString(remoteConfig, apiBaseUrlKey, 'apiBaseUrl') ??
            root['apiBaseUrl'],
        defaults.apiBaseUrl,
      ),
      bannerId: _readString(
        _remoteString(remoteConfig, bannerIdKey, 'banner') ?? ads['banner'],
        defaults.bannerId,
      ),
      nativeId: _readString(
        _remoteString(remoteConfig, nativeIdKey, 'native') ?? ads['native'],
        defaults.nativeId,
      ),
      interstitialId: _readString(
        _remoteString(remoteConfig, interstitialIdKey, 'interstitial') ??
            ads['interstitial'],
        defaults.interstitialId,
      ),
      appOpenId: _readString(
        _remoteString(remoteConfig, appOpenIdKey, 'appOpen') ?? ads['appOpen'],
        defaults.appOpenId,
      ),
      rewardedId: _readString(
        _remoteString(remoteConfig, rewardedIdKey, 'rewarded') ??
            ads['rewarded'],
        defaults.rewardedId,
      ),
      collapsibleBannerId: _readString(
        _remoteString(
              remoteConfig,
              collapsibleBannerIdKey,
              'collapsibleBanner',
            ) ??
            ads['collapsibleBanner'],
        defaults.collapsibleBannerId,
      ),
      showAds: _readBool(
        _remoteBool(remoteConfig, showAdsKey) ?? features['showAds'],
        defaults.showAds,
      ),
      showNativeAds: _readBool(
        _remoteBool(remoteConfig, showNativeAdsKey) ??
            features['showNativeAds'],
        defaults.showNativeAds,
      ),
      showBannerAds: _readBool(
        _remoteBool(remoteConfig, showBannerAdsKey) ??
            features['showBannerAds'],
        defaults.showBannerAds,
      ),
      showRewardedAds: _readBool(
        _remoteBool(remoteConfig, showRewardedAdsKey) ??
            features['showRewardedAds'],
        defaults.showRewardedAds,
      ),
      showInterstitialAds: _readBool(
        _remoteBool(remoteConfig, showInterstitialAdsKey) ??
            features['showInterstitialAds'],
        defaults.showInterstitialAds,
      ),
      showAppOpenAds: _readBool(
        _remoteBool(remoteConfig, showAppOpenAdsKey) ??
            features['showAppOpenAds'],
        defaults.showAppOpenAds,
      ),
      gridNativeInterval: _readInt(
        _remoteInt(remoteConfig, gridNativeIntervalKey) ??
            adSettings['gridNativeInterval'],
        defaults.gridNativeInterval,
      ),
      enableNativeAds: _readBool(
        _remoteBool(remoteConfig, enableNativeAdsKey) ??
            adSettings['enableNativeAds'],
        defaults.enableNativeAds,
      ),
      enableAdaptiveBanner: _readBool(
        _remoteBool(remoteConfig, enableAdaptiveBannerKey) ??
            adSettings['enableAdaptiveBanner'],
        defaults.enableAdaptiveBanner,
      ),
      enableGridSquareNative: _readBool(
        _remoteBool(remoteConfig, enableGridSquareNativeKey) ??
            adSettings['enableGridSquareNative'],
        defaults.enableGridSquareNative,
      ),
      enableGridSquareBanner: _readBool(
        _remoteBool(remoteConfig, enableGridSquareBannerKey) ??
            adSettings['enableGridSquareBanner'],
        defaults.enableGridSquareBanner,
      ),
      enableCollapsibleBanner: _readBool(
        _remoteBool(remoteConfig, enableCollapsibleBannerKey) ??
            adSettings['enableCollapsibleBanner'],
        defaults.enableCollapsibleBanner,
      ),
      collapsibleBannerPosition: _readString(
        _remoteString(remoteConfig, collapsibleBannerPositionKey) ??
            adSettings['collapsibleBannerPosition'],
        defaults.collapsibleBannerPosition,
      ),
      showNativeOnHomeScreen: _readBool(
        _remoteBool(remoteConfig, showNativeOnHomeScreenKey) ??
            adSettings['showNativeOnHomeScreen'],
        defaults.showNativeOnHomeScreen,
      ),
      showNativeInWallpaperGrid: _readBool(
        _remoteBool(remoteConfig, showNativeInWallpaperGridKey) ??
            adSettings['showNativeInWallpaperGrid'],
        defaults.showNativeInWallpaperGrid,
      ),
      showNativeOnFavoritesScreen: _readBool(
        _remoteBool(remoteConfig, showNativeOnFavoritesScreenKey) ??
            adSettings['showNativeOnFavoritesScreen'],
        defaults.showNativeOnFavoritesScreen,
      ),
      showBannerOnHomeScreen: _readBool(
        _remoteBool(remoteConfig, showBannerOnHomeScreenKey) ??
            adSettings['showBannerOnHomeScreen'],
        defaults.showBannerOnHomeScreen,
      ),
      showBannerInWallpaperGrid: _readBool(
        _remoteBool(remoteConfig, showBannerInWallpaperGridKey) ??
            adSettings['showBannerInWallpaperGrid'],
        defaults.showBannerInWallpaperGrid,
      ),
      showBannerOnFavoritesScreen: _readBool(
        _remoteBool(remoteConfig, showBannerOnFavoritesScreenKey) ??
            adSettings['showBannerOnFavoritesScreen'],
        defaults.showBannerOnFavoritesScreen,
      ),
      showInterstitialOnApplyWallpaper: _readBool(
        _remoteBool(remoteConfig, showInterstitialOnApplyWallpaperKey) ??
            adSettings['showInterstitialOnApplyWallpaper'],
        defaults.showInterstitialOnApplyWallpaper,
      ),
      showRewardedOnLiveWallpaperUnlock: _readBool(
        _remoteBool(remoteConfig, showRewardedOnLiveWallpaperUnlockKey) ??
            adSettings['showRewardedOnLiveWallpaperUnlock'],
        defaults.showRewardedOnLiveWallpaperUnlock,
      ),
      showAppOpenOnColdStart: _readBool(
        _remoteBool(remoteConfig, showAppOpenOnColdStartKey) ??
            adSettings['showAppOpenOnColdStart'],
        defaults.showAppOpenOnColdStart,
      ),
      showAppOpenOnResume: _readBool(
        _remoteBool(remoteConfig, showAppOpenOnResumeKey) ??
            adSettings['showAppOpenOnResume'],
        defaults.showAppOpenOnResume,
      ),
      appOpenMinIntervalSeconds: _readInt(
        _remoteInt(remoteConfig, appOpenMinIntervalSecondsKey) ??
            adSettings['appOpenMinIntervalSeconds'],
        defaults.appOpenMinIntervalSeconds,
      ),
      disableAppOpenAfterRewarded: _readBool(
        _remoteBool(remoteConfig, disableAppOpenAfterRewardedKey) ??
            adSettings['disableAppOpenAfterRewarded'],
        defaults.disableAppOpenAfterRewarded,
      ),
      disableAppOpenAfterInterstitial: _readBool(
        _remoteBool(remoteConfig, disableAppOpenAfterInterstitialKey) ??
            adSettings['disableAppOpenAfterInterstitial'],
        defaults.disableAppOpenAfterInterstitial,
      ),
      backgroundThresholdSeconds: _readInt(
        _remoteInt(remoteConfig, backgroundThresholdSecondsKey) ??
            adSettings['backgroundThresholdSeconds'],
        defaults.backgroundThresholdSeconds,
      ),
      persistUnlockedWallpapers: _readBool(
        _remoteBool(remoteConfig, persistUnlockedWallpapersKey) ??
            wallpaper['persistUnlockedWallpapers'],
        defaults.persistUnlockedWallpapers,
      ),
      showShareTextOnStaticWallpaper: _readBool(
        _remoteBool(remoteConfig, showShareTextOnStaticWallpaperKey) ??
            ui['showShareTextOnStaticWallpaper'],
        defaults.showShareTextOnStaticWallpaper,
      ),
      showShareTextOnLiveWallpaper: _readBool(
        _remoteBool(remoteConfig, showShareTextOnLiveWallpaperKey) ??
            ui['showShareTextOnLiveWallpaper'],
        defaults.showShareTextOnLiveWallpaper,
      ),
    );
  }

  bool get canShowNativeAds =>
      showAds &&
      showNativeAds &&
      enableNativeAds &&
      enableGridSquareNative &&
      nativeId.trim().isNotEmpty;

  bool get hasAnyRemoteAdUnitId =>
      nativeId.trim().isNotEmpty ||
      bannerId.trim().isNotEmpty ||
      interstitialId.trim().isNotEmpty ||
      appOpenId.trim().isNotEmpty ||
      rewardedId.trim().isNotEmpty;

  bool get canShowNativeInWallpaperGrid =>
      canShowNativeAds && showNativeInWallpaperGrid;

  bool get canShowNativeOnFavorites =>
      canShowNativeAds && showNativeOnFavoritesScreen;

  bool get canShowInterstitialOnApplyWallpaper =>
      showAds &&
      showInterstitialAds &&
      showInterstitialOnApplyWallpaper &&
      interstitialId.trim().isNotEmpty;

  bool get canShowInterstitialOnShare => canShowInterstitialOnApplyWallpaper;

  bool get shouldGateWallpaperUnlock =>
      showAds && showRewardedAds && showRewardedOnLiveWallpaperUnlock;

  bool get canLoadRewardedAd =>
      shouldGateWallpaperUnlock && rewardedId.trim().isNotEmpty;

  bool get canLoadAppOpenAd =>
      showAds &&
      showAppOpenAds &&
      (showAppOpenOnColdStart || showAppOpenOnResume) &&
      appOpenId.trim().isNotEmpty;

  bool canShowAppOpen({required bool isColdStart}) {
    final placementEnabled = isColdStart
        ? showAppOpenOnColdStart
        : showAppOpenOnResume;
    return showAds &&
        showAppOpenAds &&
        placementEnabled &&
        appOpenId.trim().isNotEmpty;
  }

  static Map<String, dynamic> _readConfigJson(
    FirebaseRemoteConfig remoteConfig,
  ) {
    for (final key in configJsonKeys) {
      final parsed = _decodeMap(remoteConfig.getString(key));
      if (parsed.isNotEmpty) return parsed;
    }

    final apiBaseUrl = _remoteString(remoteConfig, apiBaseUrlKey, 'apiBaseUrl');
    final ads = _decodeMap(remoteConfig.getString('ads'));
    final features = _decodeMap(remoteConfig.getString('features'));
    final adSettings = _decodeMap(remoteConfig.getString('adSettings'));
    final wallpaper = _decodeMap(remoteConfig.getString('wallpaper'));
    final ui = _decodeMap(remoteConfig.getString('ui'));

    return <String, dynamic>{
      'apiBaseUrl': ?apiBaseUrl,
      if (ads.isNotEmpty) 'ads': ads,
      if (features.isNotEmpty) 'features': features,
      if (adSettings.isNotEmpty) 'adSettings': adSettings,
      if (wallpaper.isNotEmpty) 'wallpaper': wallpaper,
      if (ui.isNotEmpty) 'ui': ui,
    };
  }

  static Map<String, dynamic> _decodeMap(String value) {
    if (value.trim().isEmpty) return <String, dynamic>{};
    try {
      final decoded = jsonDecode(value);
      return _asMap(decoded);
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  static Object? _remoteString(
    FirebaseRemoteConfig remoteConfig,
    String key, [
    String? alternateKey,
  ]) {
    for (final candidate in [key, ?alternateKey]) {
      final value = remoteConfig.getValue(candidate);
      if (value.source == ValueSource.valueRemote) {
        final text = value.asString().trim();
        if (text.isNotEmpty) return text;
      }
    }
    return null;
  }

  static Object? _remoteBool(FirebaseRemoteConfig remoteConfig, String key) {
    final value = remoteConfig.getValue(key);
    return value.source == ValueSource.valueRemote ? value.asBool() : null;
  }

  static Object? _remoteInt(FirebaseRemoteConfig remoteConfig, String key) {
    final value = remoteConfig.getValue(key);
    return value.source == ValueSource.valueRemote ? value.asInt() : null;
  }

  static Map<String, dynamic> _asMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, value) => MapEntry(key.toString(), value));
    }
    return <String, dynamic>{};
  }

  static String _readString(Object? value, String fallback) {
    final parsed = value?.toString().trim();
    return parsed == null || parsed.isEmpty ? fallback : parsed;
  }

  static bool _readBool(Object? value, bool fallback) {
    if (value is bool) return value;
    if (value is String) {
      final normalized = value.toLowerCase().trim();
      if (normalized == 'true' || normalized == '1') return true;
      if (normalized == 'false' || normalized == '0') return false;
    }
    return fallback;
  }

  static int _readInt(Object? value, int fallback) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim()) ?? fallback;
    return fallback;
  }
}
