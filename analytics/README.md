# spreeloop_analytics
[![pub package](https://img.shields.io/pub/v/spreeloop_analytics.svg)](https://pub.dev/packages/spreeloop_analytics)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![stars](https://img.shields.io/github/stars/spreeloop/core-dart)

Spreeloop analytics is an app measurement solution, that provides insight on app usage and user engagement.

## Features
* Registers an event.
* Registers an item list view event.
* Registers an item view event.
* Registers a select item view event.
* Registers an add-to-cart event.
* Registers a user to partner call event.
* Registers a remove-from-cart event.
* Registers a view cart event.
* Registers a begin checkout event.
* Registers a purchase event.
* Sets a user property, or audience.
* Registers the current screen in analytics.

## Installation

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  spreeloop_analytics: ^0.0.1
```
## Usage

Import the package in your Dart code:

```dart
   import 'package:spreeloop_analytics/spreeloop_analytics.dart';
```

The Analytics class is implemented as a interface, with a factory constructor that returns different instance by optional AnalyticsType given.

For firebase implementation in your code your can do::
```dart
   Analytics(AnalyticsType.firebase);
```
For some tests in your code your can do:
```dart
   Analytics(AnalyticsType.fake);
```

### logEvent
```dart
   Future<void> logEvent({
    required EventType eventType,
    Map<String, Object?>? parameters,
  })
```

### logViewItemList
```dart
   Future<void> logViewItemList({
    List<AnalyticsCommerceEventItem>? items,
    String? itemListId,
    String? itemListName,
  })
```

### logViewItem
```dart
   Future<void> logViewItem({
    List<AnalyticsCommerceEventItem>? items,
    String? currency,
    double? value,
  });
```

### logSelectItem
```dart
   Future<void> logSelectItem({
    String? itemListId,
    String? itemListName,
    List<AnalyticsCommerceEventItem>? items,
  });
```

### logAddToCart
```dart
   Future<void> logAddToCart({
    List<AnalyticsCommerceEventItem>? items,
    double? value,
    String? currency,
  });
```

### logUserCallsPartner
```dart
   Future<void> logUserCallsPartner({
    String? partnerId,
  });
```

### logRemoveFromCart
```dart
   Future<void> logRemoveFromCart({
    List<AnalyticsCommerceEventItem>? items,
    double? value,
    String? currency,
  });
```

### logViewCart
```dart
   Future<void> logViewCart({
    String? currency,
    double? value,
    List<AnalyticsCommerceEventItem>? items,
  });
```

### logBeginCheckout
```dart
   Future<void> logBeginCheckout({
    List<AnalyticsCommerceEventItem>? items,
    double? value,
    String? currency,
    String? coupon,
  });
```

### logPurchase
```dart
   Future<void> logPurchase(PurchaseEventParameter param);
```

### setUserProperty
```dart
   Future<void> setUserProperty({
    required PropertyType propertyType,
    required String value,
  });
```

### setCurrentScreen
```dart
   Future<void> setCurrentScreen({
    required String screenName,
    String screenClassOverride,
  });
```

## Dependencies
```yaml
firebase_analytics: ^10.8.10
logging: ^1.0.1
```

## Additional information
the library uses the following APIs:
* [FIREBASE](https://firebase.flutter.dev/docs/analytics/overview/)
