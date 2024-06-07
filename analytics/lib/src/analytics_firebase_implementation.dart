import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:logging/logging.dart';

import '../spreeloop_analytics.dart';

/// The firebase implementation of the analytics interface.
class AnalyticsFirebaseImplementation implements Analytics {
  final _log = Logger('AnalyticsFirebaseImplementation');

  /// Converts an event type in to firebase event string.
  final Map<PropertyType, String> propertyTypeToString = {
    PropertyType.newUser: 'new_user',
  };

  /// Converts an event type in to firebase event string.
  final Map<EventType, String> eventTypeToFirebaseAnalyticsEvent = {
    EventType.login: 'login',
    EventType.signUp: 'sign_up',
    EventType.addToCart: 'add_to_cart',
    EventType.removeFromCart: 'remove_from_cart',
    EventType.selectItem: 'select_item',
    EventType.validateTheOrder: 'validate_the_order',
    EventType.removeItem: 'remove_item',
  };

  @override
  Future<void> logEvent({
    required EventType eventType,
    Map<String, Object?>? parameters,
  }) async {
    await FirebaseAnalytics.instance
        .logEvent(
      name: eventTypeToFirebaseAnalyticsEvent[eventType]!,
      parameters: parameters,
    )
        .catchError((error) {
      _log.severe('Argument error caught: $error', null, StackTrace.current);
    });
  }

  List<AnalyticsEventItem>? _createEventItems(
    List<AnalyticsCommerceEventItem>? purchaseItems,
  ) {
    return purchaseItems
        ?.map(
          (item) => AnalyticsEventItem(
            affiliation: item.affiliation,
            promotionId: item.promotionId,
            discount: item.discount,
            price: item.price,
            currency: item.currency,
            itemId: item.itemId,
            itemName: item.itemName,
            itemCategory: item.itemCategory,
            quantity: item.quantity,
          ),
        )
        .toList();
  }

  @override
  Future<void> logViewItemList({
    List<AnalyticsCommerceEventItem>? items,
    String? itemListId,
    String? itemListName,
  }) async {
    return await FirebaseAnalytics.instance.logViewItemList(
      itemListId: itemListId,
      itemListName: itemListName,
      items: _createEventItems(items),
    );
  }

  @override
  Future<void> logViewItem({
    List<AnalyticsCommerceEventItem>? items,
    String? currency,
    double? value,
  }) async {
    return await FirebaseAnalytics.instance.logViewItem(
      currency: currency,
      value: value,
      items: _createEventItems(items),
    );
  }

  @override
  Future<void> logSelectItem({
    String? itemListId,
    String? itemListName,
    List<AnalyticsCommerceEventItem>? items,
  }) async {
    return await FirebaseAnalytics.instance.logSelectItem(
      itemListId: itemListId,
      itemListName: itemListName,
      items: _createEventItems(items),
    );
  }

  @override
  Future<void> logAddToCart({
    List<AnalyticsCommerceEventItem>? items,
    double? value,
    String? currency,
  }) async {
    return await FirebaseAnalytics.instance.logAddToCart(
      currency: currency,
      value: value,
      items: _createEventItems(items),
    );
  }

  @override
  Future<void> logRemoveFromCart({
    List<AnalyticsCommerceEventItem>? items,
    double? value,
    String? currency,
  }) async {
    return await FirebaseAnalytics.instance.logRemoveFromCart(
      currency: currency,
      value: value,
      items: _createEventItems(items),
    );
  }

  @override
  Future<void> logViewCart({
    String? currency,
    double? value,
    List<AnalyticsCommerceEventItem>? items,
  }) async {
    return await FirebaseAnalytics.instance.logViewCart(
      currency: currency,
      value: value,
      items: _createEventItems(items),
    );
  }

  @override
  Future<void> logBeginCheckout({
    List<AnalyticsCommerceEventItem>? items,
    double? value,
    String? currency,
    String? coupon,
  }) async {
    return await FirebaseAnalytics.instance.logBeginCheckout(
      value: value,
      currency: currency,
      coupon: coupon,
      items: _createEventItems(items),
    );
  }

  @override
  Future<void> logUserCallsPartner({String? partnerId}) async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'user_calls_partner',
      parameters: {
        'partner_id': partnerId,
      },
    ).catchError((error) {
      _log.severe('Argument error caught: $error', null, StackTrace.current);
    });
  }

  @override
  Future<void> logPurchase(PurchaseEventParameter param) async {
    final Map<String, dynamic> evenParameters = {};
    if (param.currency != null) {
      evenParameters['currency'] = param.currency;
    }
    if (param.coupon != null) {
      evenParameters['coupon'] = param.coupon;
    }
    if (param.value != null) {
      evenParameters['value'] = param.value;
    }
    if (param.shipping != null) {
      evenParameters['shipping'] = param.shipping;
    }
    if (param.shippingDistanceInKm != null) {
      evenParameters['shipping_distance_km'] = param.shippingDistanceInKm;
    }
    if (param.transactionId != null) {
      evenParameters['transactionId'] = param.transactionId;
    }
    if (param.affiliation != null) {
      evenParameters['affiliation'] = param.affiliation;
    }
    if (param.serviceFees != null) {
      evenParameters['service_fees'] = param.serviceFees;
    }
    if (param.orderOption != null) {
      evenParameters['order_option'] = param.orderOption;
    }
    final itemsEvent = _createEventItems(param.items);
    if (itemsEvent != null) {
      evenParameters['items'] = itemsEvent.join(',');
    }
    await FirebaseAnalytics.instance
        .logEvent(name: 'purchase', parameters: evenParameters)
        .catchError((error) {
      _log.severe('Argument error caught: $error', null, StackTrace.current);
    });
  }

  @override
  Future<void> setCurrentScreen({
    required String screenName,
    String screenClassOverride = 'Flutter',
  }) async {
    await FirebaseAnalytics.instance.logScreenView(
      screenName: screenName,
      screenClass: screenClassOverride,
    );
  }

  @override
  Future<void> setUserProperty({
    required PropertyType propertyType,
    required String value,
  }) async {
    await FirebaseAnalytics.instance
        .setUserProperty(
      name: propertyTypeToString[propertyType]!,
      value: value,
    )
        .catchError((error) {
      _log.severe(
        'Argument error caught ${error.toString()}',
        null,
        StackTrace.current,
      );

      return Future.error(ArgumentError(error));
    });
  }
}
