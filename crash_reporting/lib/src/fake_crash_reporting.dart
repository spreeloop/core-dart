
import 'package:flutter/foundation.dart';

import '../spreeloop_crash_reporting.dart';

/// Service that provides web implementation for crashlytics inside an app.
class FakeCrashReporting implements CrashReporting {
  @override
  Future<bool> checkForUnsentReports() => Future.value(false);

  @override
  Future<void> deleteUnsentReports() => Future.value();

  @override
  Future<void> log(String message) => Future.value();

  @override
  Future<void> recordError(ErrorRecordParam param) => Future.value();

  @override
  Future<void> recordFlutterError(FlutterErrorDetails flutterErrorDetails) =>
      Future.value();

  @override
  Future<void> sendUnsentReports() => Future.value();

  @override
  Future<void> setUserIdentifier(String identifier) => Future.value();

  @override
  void crash() => Future.value();

  @override
  Future<void> setCustomKey(String key, Object value) => Future.value();
}
