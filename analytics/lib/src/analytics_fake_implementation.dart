import '../spreeloop_analytics.dart';

/// The firebase implementation of the analytics interface.
class AnalyticsFakeImplementation implements Analytics {
  /// Contains all the reported events.
  final Map<EventType, Map<String, Object?>?> _reportedEvents = {};

  /// Contains all the properties of the current user.
  final Map<PropertyType, String> _registeredProperties = {};

  // ignore: unused_field
  String _currentScreen = '';

  @override
  Future<void> logEvent({
    required EventType eventType,
    Map<String, Object?>? parameters,
  }) async {
    _reportedEvents[eventType] = parameters;
  }

  @override
  Future<void> logViewItemList({
    List<AnalyticsCommerceEventItem>? items,
    String? itemListId,
    String? itemListName,
  }) {
    return Future.value();
  }

  @override
  Future<void> logAddToCart({
    List<AnalyticsCommerceEventItem>? items,
    double? value,
    String? currency,
  }) {
    return Future.value();
  }

  @override
  Future<void> logUserCallsPartner({String? partnerId}) {
    return Future.value();
  }

  @override
  Future<void> logRemoveFromCart({
    List<AnalyticsCommerceEventItem>? items,
    double? value,
    String? currency,
  }) {
    return Future.value();
  }

  @override
  Future<void> logViewCart({
    String? currency,
    double? value,
    List<AnalyticsCommerceEventItem>? items,
  }) {
    return Future.value();
  }

  @override
  Future<void> logBeginCheckout({
    List<AnalyticsCommerceEventItem>? items,
    double? value,
    String? currency,
    String? coupon,
  }) {
    return Future.value();
  }

  @override
  Future<void> logPurchase(PurchaseEventParameter param) {
    return Future.value();
  }

  @override
  Future<void> setCurrentScreen({
    required String screenName,
    String screenClassOverride = 'Flutter',
  }) async {
    _currentScreen = screenName;
  }

  @override
  Future<void> setUserProperty({
    required PropertyType propertyType,
    required String value,
  }) async {
    _registeredProperties[propertyType] = value;
  }

  @override
  Future<void> logViewItem({
    List<AnalyticsCommerceEventItem>? items,
    String? currency,
    double? value,
  }) {
    return Future.value();
  }

  @override
  Future<void> logSelectItem({
    String? itemListId,
    String? itemListName,
    List<AnalyticsCommerceEventItem>? items,
  }) {
    return Future.value();
  }
}
