library spreeloop_crash_reporting;

import 'package:flutter/foundation.dart';

import 'src/fake_crash_reporting.dart';
import 'src/firebase_crash_reporting.dart';
import 'src/web_crash_reporting.dart';

/// Service that provide firebase crashlytics inside an app.
/// Requires to call [CrashReporting.init] method to set the service needed.
abstract class CrashReporting {
  static CrashReporterType _reporterType = CrashReporterType.firebase;

  /// Returns an CrashReporting instance.
  factory CrashReporting() {
    switch (_reporterType) {
      case CrashReporterType.firebase:
        return FireBaseCrashReporting();
      case CrashReporterType.fake:
        return FakeCrashReporting();
      case CrashReporterType.web:
        return WebCrashReporting();
    }
  }

  /// Initializes the crash reporter to use.
  static void init({required CrashReporterType service}) {
    _reporterType = service;
  }

  /// Checks a device for any fatal or non-fatal crash reports that haven't yet
  /// been sent to Crashlytics.
  Future<bool> checkForUnsentReports();

  /// Causes the app to crash (natively).
  ///
  /// This should only be used for testing purposes in cases where you wish to
  /// simulate a native crash to view the results on the Firebase Console.
  void crash();

  /// Queues up all unsent reports on a device for deletion.
  Future<void> deleteUnsentReports();

  /// Logs a message that's included in the next fatal or non-fatal report.
  Future<void> log(String message);

  /// Submits a Crashlytics report of a caught error.
  Future<void> recordError(ErrorRecordParam param);

  /// Submits a Crashlytics report of a non-fatal error
  /// caught by the Flutter framework.
  Future<void> recordFlutterError(FlutterErrorDetails flutterErrorDetails);

  /// Queues up all the
  /// reports on a device to send to Crashlytics.
  Future<void> sendUnsentReports();

  /// Sets a custom key and value that are associated with subsequent fatal and
  /// non-fatal reports.
  ///
  /// Multiple calls to this method with the same key update the value
  /// for that key.
  /// The value of any key at the time of a fatal or non-fatal event is
  /// associated with that event. Keys and associated values are visible
  /// in the session view on the Firebase Crashlytics console.
  ///
  /// Accepts a maximum of 64 key/value pairs. New keys beyond that limit are
  /// ignored. Keys or values that exceed 1024 characters are truncated.
  ///
  /// The value can only be a type [int], [num], [String] or [bool].
  Future<void> setCustomKey(String key, Object value);

  /// Records a user ID (identifier) that's associated with subsequent fatal and
  /// non-fatal reports.
  Future<void> setUserIdentifier(String identifier);
}

/// Enum third party crash reporter used by the system.
enum CrashReporterType {
  /// The firebase crash reporting.
  firebase,

  /// An Empty crash reporting.
  fake,

  /// A web implementation.
  web,
}

/// The type of argument to provide in a [ErrorRecordParam] method.
class ErrorRecordParam {
  /// The exception provided with the error.
  final dynamic exception;

  /// The stack trace of error.
  final StackTrace? stack;

  /// The error message.
  final dynamic reason;

  /// Additional information for diagnostic.
  final Iterable<DiagnosticsNode> information;

  /// Is true when we need to print error details.
  final bool? printDetails;

  /// Is true when the error is fatal.
  final bool fatal;

  /// Constructs a new [ErrorRecordParam].
  ErrorRecordParam({
    this.exception,
    this.stack,
    this.reason,
    this.information = const [],
    this.printDetails,
    this.fatal = false,
  });
}
