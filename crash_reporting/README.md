# spreeloop_crash_reporting
[![pub package](https://img.shields.io/pub/v/spreeloop_crash_reporting.svg)](https://pub.dev/packages/spreeloop_crash_reporting)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![stars](https://img.shields.io/github/stars/spreeloop/core-dart)

Flutter Package that provides methods for reporting crash in application based on firebase crashlytics.

## Features
* Checks a device for any fatal or non-fatal crash reports that haven't yet been sent to Crashlytics.
* Causes crash in application (natively). This should only be used for testing purposes in cases where you wish to simulate a native crash to view the results on the Firebase Console.
* Queues up all unsent reports on a device for deletion.
* Logs a message that's included in the next fatal or non-fatal report.
* Submits a Crashlytics report of a caught error.
* Submits a Crashlytics report of a non-fatal error caught by the Flutter framework.
* Queues up all the reports on a device to send to Crashlytics.
* Records a user ID (identifier) that's associated with subsequent fatal and non-fatal reports.
* Sets a custom key and value that are associated with subsequent fatal and non-fatal reports.

## Installation

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  spreeloop_crash_reporting: ^0.0.1
```
## Usage

Import the package in your Dart code:

```dart
import 'package:spreeloop_crash_reporting/spreeloop_crash_reporting.dart';
```

The CrashReporting class is implemented as a interface, with a factory constructor that returns different instance by optional CrashReporterType given.

For firebase implementation in your code your can do::
```dart
CrashReporting.init(service: CrashReporterType.firebase);
```

For web implementation in your code your can do::
```dart
CrashReporting.init(service: CrashReporterType.web);
```

For some tests in your code your can do:
```dart
CrashReporting.init(service: CrashReporterType.fake);
```

### checkForUnsentReports
```dart
   CrashReporting().checkForUnsentReports()
```
## Responses

Output: /// bool: true

### crash
```dart
   CrashReporting().crash()
```

### deleteUnsentReports
```dart
   CrashReporting().deleteUnsentReports()
```

### log
```dart
   CrashReporting().log()
```
## Responses

Output: /// String: Logs a message that's included in the next fatal or non-fatal report.

### recordError
```dart
   CrashReporting().recordError()
```
## Responses

ErrorRecordParam, the type of argument to provide in a [ErrorRecordParam] method. It has the following attributes:

| Attribute     | Type   | Description |
|---------------|--------|-------------|
| exception     | dynamic | represents the exception provided with the error. |
| stack      | StackTrace | represents the stack trace of error. |
| reason      | dynamic    | represents the error message. |
| printDetails      | bool?    | is true when we need to print error details. |
| fatal      | bool    | is true when the error is fatal. |
| information  | Iterable<DiagnosticsNode>    | represents the additional information for diagnostic. |

### sendUnsentReports
```dart
   CrashReporting().sendUnsentReports()
```

### setCustomKey
```dart
   CrashReporting().setCustomKey('key', {})
```

### setUserIdentifier
```dart
   CrashReporting().setUserIdentifier('identifier')
```

## Dependencies
```yaml
firebase_crashlytics: ^3.4.19
```

## Additional information
the library uses the following APIs:
* [FIREBASE](https://firebase.flutter.dev/docs/crashlytics/overview/)
