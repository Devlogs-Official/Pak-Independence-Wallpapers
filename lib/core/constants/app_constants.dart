class AppConstants {
  AppConstants._();

  static const String appName = 'Pakistan Independence Wallpapers';
  static const String appVersion = '1.0.0';
  static const String androidPackageId =
      'com.devlogs.pro.pakistani_independence_wallpapers';

  static String get playStoreUrl =>
      'https://play.google.com/store/apps/details?id=$androidPackageId';

  static String get playStoreDeepLink =>
      'market://details?id=$androidPackageId';

  static const String privacyPolicyUrl =
      'https://www.devlogs.pro/privacy-policy/pakistan-independence-wallpapers';

  static const String termsAndConditionsUrl =
      'https://www.devlogs.pro/terms-and-conditions/pakistan-independence-wallpapers';

  static String get shareMessage => 'Check out $appName\n$playStoreUrl';
}
