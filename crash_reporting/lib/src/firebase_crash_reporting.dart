import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../spreeloop_crash_reporting.dart';

/// Service that provides firebase crashlytics inside an app.
class FireBaseCrashReporting implements CrashReporting {
  static FireBaseCrashReporting? _instance;

  /// Returns a [FirebaseCrashlytics] instance.
  FirebaseCrashlytics get _fbInstance => FirebaseCrashlytics.instance;

  FireBaseCrashReporting._() {
    _init();
  }

  /// Constructs a new Firebase Crashlytics instance.
  factory FireBaseCrashReporting() => _instance ??= FireBaseCrashReporting._();

  Future<void> _init() async {
    await _fbInstance.setCrashlyticsCollectionEnabled(true);
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (errorDetails) async {
      await recordFlutterError(errorDetails);
      if (originalOnError != null) {
        // Forward to original handler.
        originalOnError(errorDetails);
      }
    };
  }

  @override
  Future<bool> checkForUnsentReports() => _fbInstance.checkForUnsentReports();

  @override
  Future<void> deleteUnsentReports() => _fbInstance.deleteUnsentReports();

  @override
  Future<void> log(String message) => _fbInstance.log(message);

  @override
  Future<void> recordError(ErrorRecordParam param) => _fbInstance.recordError(
        param.exception,
        param.stack,
        reason: param.reason,
        information: param.information,
        printDetails: param.printDetails,
        fatal: param.fatal,
      );

  @override
  Future<void> recordFlutterError(FlutterErrorDetails flutterErrorDetails) =>
      _fbInstance.recordFlutterError(flutterErrorDetails);

  @override
  Future<void> sendUnsentReports() => _fbInstance.sendUnsentReports();

  @override
  Future<void> setUserIdentifier(String identifier) =>
      _fbInstance.setUserIdentifier(identifier);

  @override
  void crash() => _fbInstance.crash();

  @override
  Future<void> setCustomKey(String key, Object value) =>
      _fbInstance.setCustomKey(key, value);
}
