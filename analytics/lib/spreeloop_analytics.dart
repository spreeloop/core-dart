import 'src/analytics_fake_implementation.dart';
import 'src/analytics_firebase_implementation.dart';

export 'src/custom_route_observer.dart';

/// Supported analytics backends.
enum AnalyticsType {
  /// Analytics based on Firebase Analytics.
  firebase,

  /// Fake analytics implementation for testing.
  fake,
}

/// All types of events to consider.
enum EventType {
  /// User logged in.
  login,

  /// User created an account.
  signUp,

  /// Order add to cart by user.
  addToCart,

  /// Order removed by user.
  removeFromCart,

  /// Item remove.
  removeItem,

  /// Order validated by the user.
  validateTheOrder,

  /// Item selected.
  selectItem,
}

/// All types of user properties or audiences.
enum PropertyType {
  /// Category of users that used the app for less than X amount of time.
  newUser,
}

/// Log event parameter.
class PurchaseEventParameter {
  /// The currency used on purchase.
  final String? currency;

  /// The coupon of the purchase.
  final String? coupon;

  /// The value of the purchase.
  final double? value;

  /// The serviceFees of the purchase.
  final double? serviceFees;

  /// The shipping of the purchase.
  final double? shipping;

  /// The shippingDistanceInKm of the purchase.
  final double? shippingDistanceInKm;

  /// The transactionId of the purchase.
  final String? transactionId;

  /// The affiliation of the purchase.
  final String? affiliation;

  /// The orderOption of the purchase.
  final String? orderOption;

  /// The items of the purchase.
  final List<AnalyticsCommerceEventItem> items;

  /// Creates parameter [PurchaseEventParameter].
  PurchaseEventParameter({
    this.currency,
    this.coupon,
    this.value,
    this.serviceFees,
    this.shipping,
    this.shippingDistanceInKm,
    this.transactionId,
    this.affiliation,
    this.orderOption,
    required this.items,
  });
}

/// Service that provides Analytics to apps.
abstract class Analytics {
  /// Builds an [Analytics] implementation for the specified [AnalyticsType].
  factory Analytics(AnalyticsType type) {
    switch (type) {
      case AnalyticsType.firebase:
        return AnalyticsFirebaseImplementation();
      default:
        return AnalyticsFakeImplementation();
    }
  }

  /// Registers an event.
  Future<void> logEvent({
    required EventType eventType,
    Map<String, Object?>? parameters,
  });

  /// Registers an item list view event.
  Future<void> logViewItemList({
    List<AnalyticsCommerceEventItem>? items,
    String? itemListId,
    String? itemListName,
  });

  /// Registers an item view event.
  Future<void> logViewItem({
    List<AnalyticsCommerceEventItem>? items,
    String? currency,
    double? value,
  });

  /// Registers a select item view event.
  Future<void> logSelectItem({
    String? itemListId,
    String? itemListName,
    List<AnalyticsCommerceEventItem>? items,
  });

  /// Registers an add-to-cart event.
  Future<void> logAddToCart({
    List<AnalyticsCommerceEventItem>? items,
    double? value,
    String? currency,
  });

  /// Registers a user to partner call event.
  Future<void> logUserCallsPartner({
    String? partnerId,
  });

  /// Registers a remove-from-cart event.
  Future<void> logRemoveFromCart({
    List<AnalyticsCommerceEventItem>? items,
    double? value,
    String? currency,
  });

  /// Registers a view cart event.
  Future<void> logViewCart({
    String? currency,
    double? value,
    List<AnalyticsCommerceEventItem>? items,
  });

  /// Registers a begin checkout event.
  Future<void> logBeginCheckout({
    List<AnalyticsCommerceEventItem>? items,
    double? value,
    String? currency,
    String? coupon,
  });

  /// Registers a purchase event.
  Future<void> logPurchase(PurchaseEventParameter param);

  /// Sets a user property, or audience.
  Future<void> setUserProperty({
    required PropertyType propertyType,
    required String value,
  });

  /// Registers the current screen in analytics.
  /// The class name can optionally be overridden by the [screenClassOverride]
  /// parameter.
  Future<void> setCurrentScreen({
    required String screenName,
    String screenClassOverride,
  });
}

/// User Parameter of event.
class UserParam {
  /// User id.
  static const String userId = 'user_id';

  /// User last name.
  static const String userLastName = 'user_last_name';

  /// User first name.
  static const String userFirstName = 'user_first_name';

  /// User e-mail.
  static const String userEmail = 'user_email';

  /// User phone.
  static const String userPhone = 'user_phone';
}

/// Represents the data of a commerce event item.
class AnalyticsCommerceEventItem {
  /// The product affiliation (supplying company).
  final String? affiliation;

  /// The ID of the promotion associated with the item.
  final String? promotionId;

  /// The monetary discount value associated with the item.
  final num? discount;

  /// The cost of the item.
  final num? price;

  /// The currency of the price and discount.
  final String? currency;

  /// The ID of the item. One of itemId or itemName is required.
  final String? itemId;

  /// The name of the item. One of itemId or itemName is required.
  final String? itemName;

  /// The category of the item.
  final String? itemCategory;

  /// The item quantity.
  final int? quantity;

  /// Represents the add-on group data of a commerce event.
  List<AnalyticsCommerceEventAddOnGroupItem>? addOnGroups;

  /// Constructs an [AnalyticsCommerceEventItem].
  AnalyticsCommerceEventItem({
    this.affiliation,
    this.price,
    this.currency,
    this.itemId,
    this.itemName,
    this.itemCategory,
    this.quantity,
    this.promotionId,
    this.discount,
    this.addOnGroups,
  });
}

/// Represents the add-on data of a commerce event.
class AnalyticsCommerceEventAddOnItem {
  /// The ID of the add-on referencing it in the list of menu item add-on.
  final String? addOnId;

  /// The name of the add-on item.
  final String? addOnName;

  /// The cost of the add-on item.
  final num? additionalPriceInXAF;

  /// Constructs an [AnalyticsCommerceEventAddOnItem].
  AnalyticsCommerceEventAddOnItem({
    this.addOnId,
    this.addOnName,
    this.additionalPriceInXAF,
  });
}

/// Represents the add-on group data of a commerce event.
class AnalyticsCommerceEventAddOnGroupItem {
  /// The ID of the group for which the add-on belongs.
  final String? groupId;

  /// The description of group for which the add-on belongs.
  final String? groupDescription;

  /// Represents the add-on data of a commerce event.
  List<AnalyticsCommerceEventAddOnItem> addOnItems;

  /// Constructs an [AnalyticsCommerceEventAddOnGroupItem].
  AnalyticsCommerceEventAddOnGroupItem({
    this.groupId,
    this.groupDescription,
    required this.addOnItems,
  });
}

/// Places Parameter of event.
class PlaceParams {
  /// Place path.
  static const String placePath = 'placePath';
}

/// Item Parameter of event.
class ItemParams {
  /// Selected item place type.
  static const String itemPlaceType = 'order_item_type';

  /// Selected item price.
  static const String itemPrice = 'order_item_price';

  /// Food name of item to be remove.
  static const String itemFoodName = 'order_item_food_name';

  /// Menu of item to be remove.
  static const String menuItemPath = 'order_item_menu';

  /// Item to be remove is it vegetarian.
  static const String itemIsVegetarian = 'order_item_is_vegetarian';
}
