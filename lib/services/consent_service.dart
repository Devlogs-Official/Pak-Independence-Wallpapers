import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../core/constants/app_logger.dart';


class ConsentService {
  ConsentService._();

  static final ConsentService instance = ConsentService._();

  final ConsentInformation _consentInformation = ConsentInformation.instance;

  Completer<void>? _initializeCompleter;
  bool _isConsentFlowComplete = false;

  /// True after the startup UMP flow has either finished successfully or
  /// reached a handled error state. Ad loading still depends on [canRequestAds].
  bool get isConsentFlowComplete => _isConsentFlowComplete;

  /// Starts the Google User Messaging Platform flow.
  ///
  /// Startup order matters:
  /// 1. Ask UMP for the latest consent information for this device.
  /// 2. Let UMP load and display the GDPR/US States form when required.
  /// 3. Only after this future completes should the app initialize Mobile Ads.
  ///
  /// If consent is not required, UMP returns immediately and the app continues
  /// with normal ad initialization. If the network/request fails, the app logs
  /// the error and later calls [canRequestAds] so cached consent can still allow
  /// ads where Google permits it.
  Future<void> initializeConsent() {
    final existing = _initializeCompleter;
    if (existing != null) return existing.future;

    final completer = Completer<void>();
    _initializeCompleter = completer;

    unawaited(_initializeConsentInternal(completer));
    return completer.future;
  }

  Future<bool> canRequestAds() async {
    try {
      final canRequestAds = await _consentInformation.canRequestAds();
      AppLogger.debug('UMP can request ads', data: canRequestAds);
      return canRequestAds;
    } catch (error, stackTrace) {
      AppLogger.error(
        'Unable to read UMP canRequestAds',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Opens the UMP privacy options form from an in-app privacy entry point.
  ///
  /// AdMob controls whether this form is required/available for the current
  /// user. When it is not required, the method quietly logs and returns.
  Future<void> showPrivacyOptionsForm() async {
    try {
      final status = await getPrivacyOptionsRequirementStatus();
      AppLogger.debug('UMP privacy options status', data: status.name);

      if (status != PrivacyOptionsRequirementStatus.required) {
        AppLogger.debug('UMP privacy options form is not required');
        return;
      }

      final completer = Completer<void>();
      await ConsentForm.showPrivacyOptionsForm((formError) {
        if (formError != null) {
          AppLogger.error(
            'UMP privacy options form dismissed with error',
            error: _formatFormError(formError),
          );
        } else {
          AppLogger.debug('UMP privacy options form dismissed');
        }

        if (!completer.isCompleted) completer.complete();
      });

      await completer.future;
    } catch (error, stackTrace) {
      AppLogger.error(
        'Unable to show UMP privacy options form',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<ConsentStatus> getConsentStatus() async {
    try {
      return _consentInformation.getConsentStatus();
    } catch (error, stackTrace) {
      AppLogger.error(
        'Unable to read UMP consent status',
        error: error,
        stackTrace: stackTrace,
      );
      return ConsentStatus.unknown;
    }
  }

  Future<PrivacyOptionsRequirementStatus>
  getPrivacyOptionsRequirementStatus() async {
    try {
      return _consentInformation.getPrivacyOptionsRequirementStatus();
    } catch (error, stackTrace) {
      AppLogger.error(
        'Unable to read UMP privacy options status',
        error: error,
        stackTrace: stackTrace,
      );
      return PrivacyOptionsRequirementStatus.unknown;
    }
  }

  Future<bool> isConsentFormAvailable() async {
    try {
      return _consentInformation.isConsentFormAvailable();
    } catch (error, stackTrace) {
      AppLogger.error(
        'Unable to read UMP consent form availability',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<bool> isConsentRequired() async {
    return await getConsentStatus() == ConsentStatus.required;
  }

  Future<bool> isConsentObtained() async {
    return await getConsentStatus() == ConsentStatus.obtained;
  }

  Future<bool> isPrivacyOptionsRequired() async {
    return await getPrivacyOptionsRequirementStatus() ==
        PrivacyOptionsRequirementStatus.required;
  }

  Future<void> _initializeConsentInternal(Completer<void> completer) async {
    try {
      AppLogger.debug('Starting UMP consent flow');

      await _requestConsentInfoUpdate();
      await _logCurrentConsentState('after consent info update');
      await _loadAndShowConsentFormIfRequired();
      await _logCurrentConsentState('after consent form processing');
    } catch (error, stackTrace) {
      AppLogger.error(
        'UMP consent flow failed',
        error: error,
        stackTrace: stackTrace,
      );
    } finally {
      _isConsentFlowComplete = true;
      if (!completer.isCompleted) completer.complete();
    }
  }

  Future<void> _requestConsentInfoUpdate() {
    final completer = Completer<void>();

    final params = ConsentRequestParameters(
      tagForUnderAgeOfConsent: false,

      // DEBUG ONLY: uncomment this block to force geography while testing UMP.
      //
      // Steps:
      // 1. Run the app once and check logs for the UMP/AdMob test device ID.
      // 2. Add that ID to testIdentifiers below.
      // 3. Choose debugGeographyEea for GDPR testing or
      //    debugGeographyRegulatedUsState for US States testing.
      // 4. Comment this block again before production builds.
      //
      // consentDebugSettings: ConsentDebugSettings(
      //   debugGeography: DebugGeography.debugGeographyEea,
      //   testIdentifiers: <String>[
      //     'YOUR_UMP_TEST_DEVICE_ID',
      //   ],
      // ),
    );

    _consentInformation.requestConsentInfoUpdate(
      params,
          () {
        AppLogger.debug('UMP consent information updated');
        if (!completer.isCompleted) completer.complete();
      },
          (formError) {
        AppLogger.error(
          'UMP consent information update failed',
          error: _formatFormError(formError),
        );
        if (!completer.isCompleted) {
          completer.completeError(Exception(_formatFormError(formError)));
        }
      },
    );

    return completer.future;
  }

  Future<void> _loadAndShowConsentFormIfRequired() async {
    final completer = Completer<void>();

    await ConsentForm.loadAndShowConsentFormIfRequired((formError) {
      if (formError != null) {
        AppLogger.error(
          'UMP consent form dismissed with error',
          error: _formatFormError(formError),
        );
      } else {
        AppLogger.debug('UMP consent form processing completed');
      }

      if (!completer.isCompleted) completer.complete();
    });

    await completer.future;
  }

  Future<void> _logCurrentConsentState(String reason) async {
    final consentStatus = await getConsentStatus();
    final privacyOptionsStatus = await getPrivacyOptionsRequirementStatus();
    final formAvailable = await isConsentFormAvailable();
    final adsAllowed = await canRequestAds();

    AppLogger.debug(
      'UMP state $reason',
      data: {
        'consentStatus': consentStatus.name,
        'privacyOptionsStatus': privacyOptionsStatus.name,
        'formAvailable': formAvailable,
        'canRequestAds': adsAllowed,
      },
    );
  }

  String _formatFormError(FormError error) {
    return 'code=${error.errorCode}, message=${error.message}';
  }
}