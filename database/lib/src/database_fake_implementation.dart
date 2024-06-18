import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../database.dart';

/// The purpose of this implementation is to fake the database, and should only
/// be used for testing purposes.
class DatabaseFakeImplementation implements Database {
  final _log = Logger('DatabaseFakeImplementation');
  static final Map<dynamic, Map<dynamic, dynamic>> _legacyTestDb = {
    'apiKeys': {
      'mtn_momo_test': <String, dynamic>{
        'apim_subscription_key': '0b3e476bdb1c4373910a603f1bcf0e9d',
        'basic_auth': 'Basic ZTAzZWJiNzctMTdlYi00MGQ3LWI2MTctNjMzZWU3ZG'
            'I3MTkyOjEyZDBkNTU5OGU5MDRlNGZiZjQ4ZjU0NTc3OGJiM2Ix',
      },
      'payunit_test': <String, dynamic>{
        'authorization': 'Basic cGF5dW5pdF9zYW5kXzNGc3gya2g5bjozYzA3ZGM3Y'
            'i1hOTUyLTRlZjYtODFjOC0wMzllNWU4ZmQ0ZGM=',
        'x-api-key': 'dc7cbf217f4b9ac11597ac3a2f9da1600f94cbf3',
      },
      'cinetpay': <String, dynamic>{
        'site-id': '993563',
        'api-key': '200222265860cb03df974236.62187255',
      },
    },
    'users': <String, dynamic>{
      'users_1': <String, dynamic>{
        'firstName': 'Bob',
        'lastName': 'Madison',
        'photoUrl': '',
        'userPhoneNumber': '+237696292947',
        'userEmail': 'test@gmail.com',
        'userId': 'users_1',
        'referralCode': 'MABO237',
      },
      'users_2': <String, dynamic>{
        'firstName': 'Alice',
        'lastName': 'Camile',
        'photoUrl': '',
        'userPhoneNumber': '+237699999999',
        'userEmail': 'test@gmail.com',
        'userId': 'users_2',
      },
      'users_3': <String, dynamic>{
        'firstName': 'Laeticia',
        'lastName': 'Gaelle',
        'photoUrl': '',
        'userPhoneNumber': '+237694265478',
        'userEmail': 'laetitiaGaelle@gmail.com',
        'userId': 'users_3',
      },
    },
    'placeCustomers': <String, dynamic>{
      'users_1': <String, dynamic>{
        'deliveryAddress': <String, dynamic>{
          'additionalInformation': 'UBA Town Center',
          'city': 'Douala',
          'country': 'Cameroun',
          'latitude': 3.8673154122226925,
          'longitude': 11.516863033175468,
          'postalCode': 'BP:125663',
          'street': '5248',
        },
      },
      'users_2': <String, dynamic>{
        'deliveryAddress': <String, dynamic>{
          'additionalInformation': 'Kennedy Town Center',
          'city': 'Yaounde',
          'country': 'Cameroun',
          'latitude': 3.8673154122226925,
          'longitude': 11.516863033175468,
          'postalCode': 'BP:41255',
          'street': '6523',
        },
      },
      'users_3': <String, dynamic>{
        'deliveryAddress': <String, dynamic>{
          'additionalInformation': 'Buea Town Center',
          'city': 'Buea',
          'country': 'Cameroun',
          'latitude': 3.8673154122226925,
          'longitude': 11.516863033175468,
          'postalCode': 'BP:524',
          'street': '784',
        },
      },
    },
    'promotions': <String, dynamic>{
      'promotion_1': <String, dynamic>{
        'appliesOn': 'itemPrice',
        'createdAt': '2021-10-01T12:30:29.897Z',
        'creatorPath': '03HbM5T37VQrnGcWXdOF/tKb5tlVbNkWm4chTNaTMR5LLhkt2',
        'discount': 25,
        'discountType': 'PERCENTAGE',
        'isActive': true,
        'maxUsageCount': 10,
        'minAmountToSpend': 5000,
        'menuItemsPaths': null,
        'placesPaths': <String>[
          'restaurants/restaurants_1',
          'restaurants/restaurants_2',
          'restaurants/restaurants_3',
          'restaurants/restaurants_4',
          'restaurants/restaurants_5',
          'restaurants/restaurants_6',
        ],
        'promoCode': 'CMR237',
        'subscriberCount': <String, dynamic>{
          'users_1': <String, dynamic>{
            'numberOfUse': 2,
          },
          'users_2': <String, dynamic>{
            'numberOfUse': 5,
          },
        },
        'subscribers': <String, dynamic>{
          'users_1': {},
          'users_2': {},
        },
      },
      'promotion_2': <String, dynamic>{
        'appliesOn': 'itemPrice',
        'createdAt': '2021-10-01T12:30:29.897Z',
        'creatorPath': '03HbM5T37VQrnGcWXdOF/tKb5tlVbNkWm4chTNaTMR5LLhkt2',
        'discount': 2500,
        'discountType': 'VALUE_IN_XAF',
        'isActive': false,
        'maxUsageCount': 10,
        'minAmountToSpend': 5000,
        'menuItemsPaths': null,
        'placesPaths': <String>[
          'restaurants/restaurants_1',
          'restaurants/restaurants_2',
          'restaurants/restaurants_3',
          'restaurants/restaurants_4',
          'restaurants/restaurants_5',
          'restaurants/restaurants_6',
        ],
        'promoCode': 'INACTIVE_PROMO',
        'subscriberCount': <String, dynamic>{
          'users_1': <String, dynamic>{
            'numberOfUse': 2,
          },
          'users_2': <String, dynamic>{
            'numberOfUse': 5,
          },
        },
        'subscribers': <String, dynamic>{
          'users_1': {},
          'users_2': {},
        },
      },
      'promotion_3': <String, dynamic>{
        'appliesOn': 'itemPrice',
        'createdAt': '2021-10-01T12:30:29.897Z',
        'creatorPath': '03HbM5T37VQrnGcWXdOF/tKb5tlVbNkWm4chTNaTMR5LLhkt2',
        'discount': 35,
        'discountType': 'PERCENTAGE',
        'isActive': true,
        'maxUsageCount': 10,
        'minAmountToSpend': 5000,
        'menuItemsPaths': null,
        'placesPaths': <String>[
          'restaurants/restaurants_6',
        ],
        'promoCode': 'INVALID_RESTAURANT',
        'subscriberCount': <String, dynamic>{
          'users_1': <String, dynamic>{
            'numberOfUse': 2,
          },
          'users_2': <String, dynamic>{
            'numberOfUse': 5,
          },
        },
        'subscribers': <String, dynamic>{
          'users_1': {},
          'users_2': {},
        },
      },
      'promotion_4': <String, dynamic>{
        'appliesOn': 'orderPrice',
        'createdAt': '2021-10-01T12:30:29.897Z',
        'creatorPath': '03HbM5T37VQrnGcWXdOF/tKb5tlVbNkWm4chTNaTMR5LLhkt2',
        'discount': 50,
        'discountType': 'PERCENTAGE',
        'isActive': true,
        'maxUsageCount': 1,
        'minAmountToSpend': 5000,
        'menuItemsPaths': null,
        'placesPaths': <String>[
          'restaurants/restaurants_1',
          'restaurants/restaurants_2',
        ],
        'promoCode': 'INVALID_MAX_USAGE',
        'subscriberCount': <String, dynamic>{
          'users_1': <String, dynamic>{
            'numberOfUse': 1,
          },
          'users_2': <String, dynamic>{
            'numberOfUse': 5,
          },
        },
        'subscribers': <String, dynamic>{
          'users_1': {},
          'users_2': {},
        },
      },
      'promotion_5': <String, dynamic>{
        'appliesOn': 'itemPrice',
        'createdAt': '2021-10-01T12:30:29.897Z',
        'creatorPath': '03HbM5T37VQrnGcWXdOF/tKb5tlVbNkWm4chTNaTMR5LLhkt2',
        'discount': 500,
        'discountType': 'VALUE_IN_XAF',
        'isActive': true,
        'maxUsageCount': 1,
        'minAmountToSpend': 100000,
        'menuItemsPaths': null,
        'placesPaths': <String>[
          'restaurants/restaurants_6',
        ],
        'promoCode': 'INVALID_MIN_NOT_REACHED',
        'subscriberCount': <String, dynamic>{
          'users_1': <String, dynamic>{
            'numberOfUse': 0,
          },
          'users_2': <String, dynamic>{
            'numberOfUse': 5,
          },
        },
        'subscribers': <String, dynamic>{
          'users_1': {},
          'users_2': {},
        },
      },
      'promotion_6': <String, dynamic>{
        'appliesOn': 'itemPrice',
        'createdAt': '2021-10-01T12:30:29.897Z',
        'creatorPath': '03HbM5T37VQrnGcWXdOF/tKb5tlVbNkWm4chTNaTMR5LLhkt2',
        'discount': 50,
        'discountType': 'PERCENTAGE',
        'isActive': true,
        'maxUsageCount': 3,
        'minAmountToSpend': 5000,
        'menuItemsPaths': <String>[
          'restaurants/restaurants_1/menuItems/menuItems_2',
        ],
        'placesPaths': <String>[
          'restaurants/restaurants_1',
          'restaurants/restaurants_2',
        ],
        'promoCode': 'ITEM_PRICE_DISCOUNT',
        'subscriberCount': {
          'users_1': {
            'numberOfUse': 1,
          },
          'users_2': {
            'numberOfUse': 1,
          },
        },
        'subscribers': {
          'users_1': {},
          'users_2': {},
        },
      },
      'promotion_7': <String, dynamic>{
        'appliesOn': 'itemPrice',
        'createdAt': '2021-10-01T12:30:29.897Z',
        'creatorPath': '03HbM5T37VQrnGcWXdOF/tKb5tlVbNkWm4chTNaTMR5LLhkt2',
        'discount': 50,
        'discountType': 'PERCENTAGE',
        'isActive': true,
        'maxUsageCount': 3,
        'minAmountToSpend': 5000,
        'menuItemsPaths': <String>[
          'restaurants/restaurants_1/menuItems/menuItems_2',
        ],
        'placesPaths': <String>[
          'restaurants/restaurants_1',
          'restaurants/restaurants_2',
        ],
        'promoCode': 'USER2_ONLY',
        'subscriberCount': {
          'users_2': {
            'numberOfUse': 1,
          },
        },
        'subscribers': {
          'users_2': {},
        },
      },
      'promotion_8': <String, dynamic>{
        'appliesOn': 'deliveryFee',
        'createdAt': '2021-10-01T12:30:29.897Z',
        'creatorPath': '03HbM5T37VQrnGcWXdOF/tKb5tlVbNkWm4chTNaTMR5LLhkt2',
        'discount': 25,
        'discountType': 'PERCENTAGE',
        'isActive': true,
        'maxUsageCount': 10,
        'minAmountToSpend': 5000,
        'menuItemsPaths': null,
        'placesPaths': <String>[
          'restaurants/restaurants_1',
          'restaurants/restaurants_2',
          'restaurants/restaurants_3',
          'restaurants/restaurants_4',
          'restaurants/restaurants_5',
          'restaurants/restaurants_6',
        ],
        'promoCode': 'ON_DELIVERY_ONLY',
        'subscriberCount': <String, dynamic>{
          'users_1': <String, dynamic>{
            'numberOfUse': 2,
          },
          'users_2': <String, dynamic>{
            'numberOfUse': 5,
          },
        },
        'subscribers': <String, dynamic>{
          'users_1': {},
          'users_2': {},
        },
      },
    },
    'restaurants': <String, dynamic>{
      'restaurants_1': <String, dynamic>{
        'address': {
          'additionalInformation': 'Restaurant at Royal Palace Ancienne Route.',
          'city': 'Akwa',
          'country': 'Cameroon',
          'latitude': 4.053137,
          'longitude': 9.698011,
          'postalCode': '',
          'street': 'Rue Franqueville',
        },
        'averageCookingTimeInMinutes': <String, dynamic>{
          'max': 45,
          'min': 20,
        },
        'brandName': 'The Pot Luck Club',
        'contacts': <String, dynamic>{
          'phoneNumbers': <String>['+23765941866', '+15145735543'],
          'socials': <String, dynamic>{
            'linkedIn': <String>[
              'https://www.linkedin.com/company/spreeloop-sarl/?viewAsMember=true',
            ],
          },
          'website': 'spreeloop.com',
        },
        'cuisineType': <String>['Continental', 'Cameroonian', 'Italian'],
        'description': 'Restaurant with lot of pots at Royal Palace.',
        'images': <String, dynamic>{
          'bannerPath': 'le_grilladin_res.png',
          'previewsPath': <String>['le_grilladin_res.png'],
          'thumbPath': 'le_grilladin_res.png',
        },
        'managersIds': <String>['/users/users_1'],
        'earningsDepositsAccounts': <String, dynamic>{
          'earningsDepositsNumbers': <Map<String, dynamic>>[
            {
              'networkOperator': 'MTN',
              'phoneNumber': '+237695326548',
            },
          ],
        },
        'numberOfReviews': 5,
        'orderOptions': <String>['takeAway', 'dineIn', 'delivery'],
        'rating': 4.5,
        'menuItems': <String, dynamic>{
          'menuItems_1': <String, dynamic>{
            'cookingTimeInMinutes': <String, dynamic>{'max': 25, 'min': 15},
            'foodName': 'Beignet Haricot Bouillie',
            'shortDescription': 'Banana flour, served with beans and a very'
                ' nutritious white soup.',
            'foodType': 'Cameroon',
            'numberOfPerson': 1,
            'priceInXAF': 250,
            'packageFee': 250,
            'isVegetarian': true,
            'isAvailable': false,
          },
          'menuItems_2': <String, dynamic>{
            'cookingTimeInMinutes': <String, dynamic>{'max': 35, 'min': 20},
            'foodName': 'Legumes Saute',
            'shortDescription': 'Cooked with no salt. Options of tofu, porc,'
                ' beef, and chicken available.',
            'foodType': 'Cameroon',
            'imagePath': 'legume_saute.jpg',
            'numberOfPerson': 2,
            'priceInXAF': 1000,
            'packageFee': 350,
            'isVegetarian': false,
            'isAvailable': true,
          },
          'menuItems_3': <String, dynamic>{
            'cookingTimeInMinutes': <String, dynamic>{'max': 15, 'min': 30},
            'foodName': 'Salades',
            'shortDescription': 'Gluten free.',
            'foodType': 'Cameroonian',
            'imagePath': 'salads.jpg',
            'numberOfPerson': 1,
            'priceInXAF': 700,
            'packageFee': 500,
            'isVegetarian': false,
            'isAvailable': true,
          },
        },
        'reviews': <String, dynamic>{
          'reviews_1': <String, dynamic>{
            'note': 5,
            'review': 'Good restaurant',
            'userPath': '/users/users_2',
          },
          'reviews_2': <String, dynamic>{
            'note': 4,
            'review': 'Good restaurant',
            'userPath': '/users/users_1',
          },
        },
        'openingTimes': <String, dynamic>{
          'openingDay': [
            {
              'day': 2,
              'openingPeriods': [
                {
                  'openTimeInUTC': {'hour': 9, 'minute': 0},
                  'closeTimeInUTC': {'hour': 19, 'minute': 30},
                },
              ],
            },
            {
              'day': 3,
              'openingPeriods': [
                {
                  'openTimeInUTC': {'hour': 9, 'minute': 0},
                  'closeTimeInUTC': {'hour': 19, 'minute': 30},
                },
              ],
            },
            {
              'day': 4,
              'openingPeriods': [
                {
                  'openTimeInUTC': {'hour': 9, 'minute': 0},
                  'closeTimeInUTC': {'hour': 19, 'minute': 30},
                },
              ],
            },
            {
              'day': 5,
              'openingPeriods': [
                {
                  'openTimeInUTC': {'hour': 9, 'minute': 0},
                  'closeTimeInUTC': {'hour': 19, 'minute': 30},
                },
              ],
            },
            {
              'day': 6,
              'openingPeriods': [
                {
                  'openTimeInUTC': {'hour': 9, 'minute': 0},
                  'closeTimeInUTC': {'hour': 19, 'minute': 30},
                },
              ],
            },
            {
              'day': 7,
              'openingPeriods': [
                {
                  'openTimeInUTC': {'hour': 9, 'minute': 0},
                  'closeTimeInUTC': {'hour': 19, 'minute': 30},
                },
              ],
            },
          ],
        },
        'isActive': true,
      },
      'restaurants_2': <String, dynamic>{
        'openingTimes': <String, dynamic>{
          'openingDay': [
            {
              'day': 2,
              'openingPeriods': [
                {
                  'openTimeInUTC': {'hour': 9, 'minute': 0},
                  'closeTimeInUTC': {'hour': 19, 'minute': 30},
                },
              ],
            },
            {
              'day': 3,
              'openingPeriods': [
                {
                  'openTimeInUTC': {'hour': 9, 'minute': 0},
                  'closeTimeInUTC': {'hour': 19, 'minute': 30},
                },
              ],
            },
            {
              'day': 4,
              'openingPeriods': [
                {
                  'openTimeInUTC': {'hour': 9, 'minute': 0},
                  'closeTimeInUTC': {'hour': 19, 'minute': 30},
                },
              ],
            },
            {
              'day': 5,
              'openingPeriods': [
                {
                  'openTimeInUTC': {'hour': 9, 'minute': 0},
                  'closeTimeInUTC': {'hour': 19, 'minute': 30},
                },
              ],
            },
            {
              'day': 6,
              'openingPeriods': [
                {
                  'openTimeInUTC': {'hour': 9, 'minute': 0},
                  'closeTimeInUTC': {'hour': 19, 'minute': 30},
                },
              ],
            },
            {
              'day': 7,
              'openingPeriods': [
                {
                  'openTimeInUTC': {'hour': 9, 'minute': 0},
                  'closeTimeInUTC': {'hour': 19, 'minute': 30},
                },
              ],
            },
          ],
        },
        'address': <String, dynamic>{
          'additionalInformation': '',
          'city': 'Bastos',
          'country': 'Cameroon',
          'latitude': 3.88701,
          'longitude': 11.50396,
          'postalCode': '',
          'street': 'Nv Rte Bastos',
        },
        'averageCookingTimeInMinutes': <String, dynamic>{
          'max': 30,
          'min': 20,
        },
        'brandName': 'Italian Dream',
        'contacts': <String, dynamic>{
          'phoneNumbers': <String>['+23765941866', '+15145735543'],
          'socials': <String, dynamic>{
            'facebook': <String>['https://www.facebook.com/spreeloop-sarl'],
          },
          'website': 'spreeloop.com',
        },
        'cuisineType': <String>['Italian'],
        'description': 'Restaurant with good pizza',
        'images': <String, dynamic>{
          'bannerPath': 'link.jpg',
          'previewsPath': <String>['link.jpg'],
          'thumbPath': 'link.jpg',
        },
        'managersIds': <String>['users/users_1'],
        'earningsDepositsAccounts': <String, dynamic>{
          'earningsDepositsNumbers': <Map<String, dynamic>>[
            {
              'networkOperator': 'MTN',
              'phoneNumber': '+237695326548',
            },
          ],
        },
        'numberOfReviews': 2,
        'orderOptions': <String>['dineIn'],
        'rating': 3.8,
        'menuItems': <String, dynamic>{
          'menuItems_1': <String, dynamic>{
            'cookingTimeInMinutes': <String, dynamic>{'max': 25, 'min': 15},
            'foodName': 'Beignet Haricot Bouillie',
            'shortDescription': 'Baked without oil. Served with plantains,'
                ' fries or bread.',
            'foodType': 'Cameroon',
            'imagePath': 'bhb.jpg',
            'numberOfPerson': 1,
            'priceInXAF': 250,
            'packageFee': 0,
            'isVegetarian': true,
            'isAvailable': false,
          },
          'menuItems_2': <String, dynamic>{
            'cookingTimeInMinutes': <String, dynamic>{'max': 35, 'min': 20},
            'foodName': 'Mouton grille',
            'shortDescription': 'Cooked with no salt. Served with plantains,'
                ' fries or bread.',
            'foodType': 'Cameroon',
            'imagePath': 'mouton_grille.jpg',
            'numberOfPerson': 2,
            'priceInXAF': 4500,
            'packageFee': 0,
            'isVegetarian': false,
            'isAvailable': true,
          },
        },
        'reviews': <String, dynamic>{
          'reviews_1': <String, dynamic>{
            'note': 4,
            'review': 'Good restaurant',
            'userPath': '/users/users_2',
          },
          'reviews_2': <String, dynamic>{
            'note': 2,
            'review': 'Too bad',
            'userPath': '/users/users_1',
          },
        },
        'isActive': true,
      },
      'restaurants_3': <String, dynamic>{
        'openingTimes': <String, dynamic>{
          'openingDay': [
            {
              'day': 4,
              'openingPeriods': [
                {
                  'openTimeInUTC': {'hour': 9, 'minute': 0},
                  'closeTimeInUTC': {'hour': 19, 'minute': 30},
                },
              ],
            },
            {
              'day': 5,
              'openingPeriods': [
                {
                  'openTimeInUTC': {'hour': 9, 'minute': 0},
                  'closeTimeInUTC': {'hour': 19, 'minute': 30},
                },
              ],
            },
            {
              'day': 6,
              'openingPeriods': [
                {
                  'openTimeInUTC': {'hour': 9, 'minute': 0},
                  'closeTimeInUTC': {'hour': 19, 'minute': 30},
                },
              ],
            },
            {
              'day': 7,
              'openingPeriods': [
                {
                  'openTimeInUTC': {'hour': 9, 'minute': 0},
                  'closeTimeInUTC': {'hour': 19, 'minute': 30},
                },
              ],
            },
          ],
        },
        'address': <String, dynamic>{
          'additionalInformation': 'En face de l\'olympia',
          'city': 'Yaoundé',
          'country': 'Cameroon',
          'latitude': 4.28701,
          'longitude': 11.50396,
          'postalCode': '',
          'street': 'Mendong - Montee jouvance',
        },
        'averageCookingTimeInMinutes': <String, dynamic>{
          'max': 30,
          'min': 20,
        },
        'brandName': 'Black Sheep Restaurant',
        'contacts': <String, dynamic>{
          'phoneNumbers': <String>['+23765941866', '+15145735543'],
          'socials': <String, dynamic>{
            'facebook': <String>['https://www.facebook.com/spreeloop-sarl'],
          },
          'website': 'spreeloop.com',
        },
        'cuisineType': <String>['British'],
        'description': 'Restaurant with good pizza',
        'images': <String, dynamic>{
          'bannerPath': 'link.jpg',
          'previewsPath': <String>['link.jpg'],
          'thumbPath': 'link.jpg',
        },
        'managersIds': <String>['users/users_1'],
        'earningsDepositsAccounts': <String, dynamic>{
          'earningsDepositsNumbers': <Map<String, dynamic>>[
            {
              'networkOperator': 'MTN',
              'phoneNumber': '+237695326548',
            },
          ],
        },
        'numberOfReviews': 2,
        'orderOptions': <String>['takeAway', 'delivery'],
        'rating': 2.8,
        'menuItemAddOns': <String, dynamic>{
          'menuItemAddOn_1': <String, dynamic>{
            'itemName': 'Medium Pan (26 cm - 6 parts)',
            'additionalPriceInXAF': 1500,
            'isAvailable': true,
          },
          'menuItemAddOn_2': <String, dynamic>{
            'itemName': 'Medium Classic (30 cm - 6 parts)',
            'additionalPriceInXAF': 2500,
            'isAvailable': true,
          },
          'menuItemAddOn_3': <String, dynamic>{
            'itemName': 'XL Pan (33 cm - 8 parts)',
            'additionalPriceInXAF': 3500,
            'isAvailable': true,
          },
          'menuItemAddOn_4': <String, dynamic>{
            'itemName': 'pomme frite',
            'additionalPriceInXAF': 0,
            'isAvailable': true,
          },
          'menuItemAddOn_5': <String, dynamic>{
            'itemName': 'plantain frite',
            'additionalPriceInXAF': 0,
            'isAvailable': true,
          },
          'menuItemAddOn_6': <String, dynamic>{
            'itemName': 'Pigment',
            'additionalPriceInXAF': 0,
            'isAvailable': false,
          },
          'menuItemAddOn_7': <String, dynamic>{
            'itemName': 'Sauce Tomate',
            'additionalPriceInXAF': 0,
            'isAvailable': true,
          },
          'menuItemAddOn_8': <String, dynamic>{
            'itemName': 'Mayonnaise',
            'additionalPriceInXAF': 200,
            'isAvailable': true,
          },
          'menuItemAddOn_9': <String, dynamic>{
            'itemName': 'Pizza marguerite',
            'additionalPriceInXAF': 0,
            'isAvailable': true,
          },
          'menuItemAddOn_10': <String, dynamic>{
            'itemName': 'Pizza végétarienne',
            'additionalPriceInXAF': 0,
            'isAvailable': false,
          },
          'menuItemAddOn_11': <String, dynamic>{
            'itemName': 'Pizza soufflée',
            'additionalPriceInXAF': 0,
            'isAvailable': true,
          },
          'menuItemAddOn_12': <String, dynamic>{
            'itemName': 'Macabo',
            'additionalPriceInXAF': 200,
            'isAvailable': true,
          },
          'menuItemAddOn_13': <String, dynamic>{
            'itemName': 'Manioc',
            'additionalPriceInXAF': 100,
            'isAvailable': false,
          },
          'menuItemAddOn_14': <String, dynamic>{
            'itemName': 'Sucre',
            'additionalPriceInXAF': 0,
            'isAvailable': true,
          },
          'menuItemAddOn_15': <String, dynamic>{
            'itemName': "O'kok s'en sel",
            'additionalPriceInXAF': 1500,
            'isAvailable': true,
          },
          'menuItemAddOn_16': <String, dynamic>{
            'itemName': "O'kok avec sel",
            'additionalPriceInXAF': 2000,
            'isAvailable': true,
          },
        },
        'menuItems': <String, dynamic>{
          'menuItems_1': <String, dynamic>{
            'availabilitySchedule': <String, dynamic>{
              'availabilityDays': [
                {
                  'day': 4,
                  'periods': [
                    {
                      'startTimeInUTC': {
                        'hour': 9,
                        'minute': 0,
                      },
                      'endTimeInUTC': {
                        'hour': 19,
                        'minute': 30,
                      },
                    },
                  ],
                },
              ],
            },
            'cookingTimeInMinutes': <String, dynamic>{
              'max': 25,
              'min': 15,
            },
            'foodName': 'Pizza',
            'foodType': 'Cameroon',
            'imagePath': 'brochettes.jpg',
            'numberOfPerson': 1,
            'priceInXAF': 1000,
            'packageFee': 500,
            'isVegetarian': true,
            'isAvailable': true,
            'addOnGroups': <String, dynamic>{
              'addOnGroup_1': <String, dynamic>{
                'description': 'Taille de la pate',
                'required': true,
                'multiSelect': false,
                'addOnItems': <String, dynamic>{
                  'addOnItem_1': <String, dynamic>{
                    'additionalPriceInXAF': null,
                    'isAvailable': true,
                    'menuItemAddOnId': 'menuItemAddOn_1',
                  },
                },
              },
              'addOnGroup_2': <String, dynamic>{
                'description': 'Complement',
                'required': false,
                'multiSelect': false,
                'addOnItems': <String, dynamic>{
                  'addOnItem_4': <String, dynamic>{
                    'additionalPriceInXAF': null,
                    'isAvailable': true,
                    'menuItemAddOnId': 'menuItemAddOn_4',
                  },
                  'addOnItem_5': <String, dynamic>{
                    'additionalPriceInXAF': 0,
                    'isAvailable': true,
                    'menuItemAddOnId': 'menuItemAddOn_5',
                  },
                },
              },
              'addOnGroup_3': <String, dynamic>{
                'description': 'Supplement',
                'required': false,
                'multiSelect': true,
                'addOnItems': <String, dynamic>{
                  'addOnItem_6': <String, dynamic>{
                    'additionalPriceInXAF': 0,
                    'isAvailable': false,
                    'menuItemAddOnId': 'menuItemAddOn_6',
                  },
                  'addOnItem_7': <String, dynamic>{
                    'additionalPriceInXAF': 0,
                    'menuItemAddOnId': 'menuItemAddOn_7',
                    'isAvailable': true,
                  },
                  'addOnItem_8': <String, dynamic>{
                    'menuItemAddOnId': 'menuItemAddOn_8',
                    'additionalPriceInXAF': 200,
                    'isAvailable': true,
                  },
                },
              },
              'addOnGroup_4': <String, dynamic>{
                'description': 'Variete de pizza',
                'required': true,
                'multiSelect': false,
                'addOnItems': <String, dynamic>{
                  'addOnItem_9': <String, dynamic>{
                    'additionalPriceInXAF': 0,
                    'menuItemAddOnId': 'menuItemAddOn_9',
                    'isAvailable': true,
                  },
                  'addOnItem_10': <String, dynamic>{
                    'additionalPriceInXAF': 0,
                    'menuItemAddOnId': 'menuItemAddOn_10',
                    'isAvailable': true,
                  },
                  'addOnItem_11': <String, dynamic>{
                    'additionalPriceInXAF': 0,
                    'menuItemAddOnId': 'menuItemAddOn_11',
                    'isAvailable': false,
                  },
                },
              },
            },
          },
          'menuItems_2': <String, dynamic>{
            'availabilitySchedule': <String, dynamic>{
              'availabilityDays': [
                {
                  'day': 2,
                  'periods': [
                    {
                      'startTimeInUTC': {
                        'hour': 9,
                        'minute': 0,
                      },
                      'endTimeInUTC': {
                        'hour': 12,
                        'minute': 30,
                      },
                    },
                  ],
                },
                {
                  'day': 4,
                  'periods': [
                    {
                      'startTimeInUTC': {
                        'hour': 9,
                        'minute': 0,
                      },
                      'endTimeInUTC': {
                        'hour': 12,
                        'minute': 30,
                      },
                    },
                  ],
                },
              ],
            },
            'cookingTimeInMinutes': <String, dynamic>{'max': 35, 'min': 20},
            'foodName': 'O\'kok',
            'foodType': 'Cameroon',
            'imagePath': 'okok.jpg',
            'numberOfPerson': 2,
            'priceInXAF': 1050,
            'packageFee': 500,
            'isVegetarian': false,
            'isAvailable': true,
            'addOnGroups': <String, dynamic>{
              'addOnGroup_1': <String, dynamic>{
                'description': 'Complement',
                'required': false,
                'multiSelect': false,
                'addOnItems': <String, dynamic>{
                  'addOnItem_13': <String, dynamic>{
                    'additionalPriceInXAF': 400,
                    'menuItemAddOnId': 'menuItemAddOn_13',
                    'isAvailable': false,
                  },
                  'addOnItem_12': <String, dynamic>{
                    'additionalPriceInXAF': 100,
                    'menuItemAddOnId': 'menuItemAddOn_12',
                    'isAvailable': true,
                  },
                },
              },
              'addOnGroup_2': <String, dynamic>{
                'description': 'Supplement',
                'required': false,
                'multiSelect': true,
                'addOnItems': <String, dynamic>{
                  'addOnItem_6': <String, dynamic>{
                    'menuItemAddOnId': 'menuItemAddOn_6',
                    'additionalPriceInXAF': null,
                    'isAvailable': false,
                  },
                  'addOnItem_14': <String, dynamic>{
                    'menuItemAddOnId': 'menuItemAddOn_14',
                    'additionalPriceInXAF': 0,
                    'isAvailable': true,
                  },
                },
              },
              'addOnGroup_3': <String, dynamic>{
                'description': "Variete d' O'kok",
                'required': true,
                'multiSelect': false,
                'addOnItems': <String, dynamic>{
                  'addOnItem_15': <String, dynamic>{
                    'menuItemAddOnId': 'menuItemAddOn_15',
                    'additionalPriceInXAF': null,
                    'isAvailable': true,
                  },
                  'addOnItem_16': <String, dynamic>{
                    'menuItemAddOnId': 'menuItemAddOn_16',
                    'additionalPriceInXAF': null,
                    'isAvailable': true,
                  },
                },
              },
            },
          },
          'menuItems_3': <String, dynamic>{
            'availabilitySchedule': <String, dynamic>{
              'availabilityDays': [
                {
                  'day': 2,
                  'periods': [
                    {
                      'startTimeInUTC': {
                        'hour': 9,
                        'minute': 0,
                      },
                      'endTimeInUTC': {
                        'hour': 12,
                        'minute': 30,
                      },
                    },
                  ],
                },
                {
                  'day': 5,
                  'periods': [
                    {
                      'startTimeInUTC': {
                        'hour': 9,
                        'minute': 0,
                      },
                      'endTimeInUTC': {
                        'hour': 12,
                        'minute': 30,
                      },
                    },
                  ],
                },
              ],
            },
            'cookingTimeInMinutes': <String, dynamic>{'max': 25, 'min': 15},
            'foodName': 'Beignet Haricot Bouillie',
            'shortDescription': 'Banana flour, served with beans and a very'
                ' nutritious white soup.',
            'foodType': 'Cameroon',
            'numberOfPerson': 1,
            'priceInXAF': 250,
            'packageFee': 400,
            'isVegetarian': true,
            'isAvailable': false,
          },
          'menuItems_4': <String, dynamic>{
            'availabilitySchedule': <String, dynamic>{
              'availabilityDays': [
                {
                  'day': 3,
                  'periods': [
                    {
                      'startTimeInUTC': {
                        'hour': 9,
                        'minute': 0,
                      },
                      'endTimeInUTC': {
                        'hour': 18,
                        'minute': 30,
                      },
                    },
                  ],
                },
                {
                  'day': 5,
                  'periods': [
                    {
                      'startTimeInUTC': {
                        'hour': 9,
                        'minute': 0,
                      },
                      'endTimeInUTC': {
                        'hour': 12,
                        'minute': 30,
                      },
                    },
                  ],
                },
              ],
            },
            'cookingTimeInMinutes': <String, dynamic>{'max': 35, 'min': 20},
            'foodName': 'Legumes Saute',
            'shortDescription': 'Cooked with no salt. Options of tofu, porc,'
                ' beef, and chicken available.',
            'foodType': 'Cameroon',
            'imagePath': 'legume_saute.jpg',
            'numberOfPerson': 2,
            'priceInXAF': 1000,
            'packageFee': 250,
            'isVegetarian': false,
            'isAvailable': true,
          },
        },
        'reviews': <String, dynamic>{
          'reviews_1': <String, dynamic>{
            'note': 4,
            'review': 'Good restaurant',
            'userPath': '/users/users_2',
          },
          'reviews_2': <String, dynamic>{
            'note': 2,
            'review': 'Too bad',
            'userPath': '/users/users_1',
          },
        },
        'isActive': true,
      },
      'restaurants_4': <String, dynamic>{
        'openingTimes': <String, dynamic>{
          'openingDay': [
            {
              'day': 5,
              'openingPeriods': [
                {
                  'openTimeInUTC': {'hour': 9, 'minute': 0},
                  'closeTimeInUTC': {'hour': 19, 'minute': 30},
                },
              ],
            },
            {
              'day': 6,
              'openingPeriods': [
                {
                  'openTimeInUTC': {'hour': 9, 'minute': 0},
                  'closeTimeInUTC': {'hour': 19, 'minute': 30},
                },
              ],
            },
            {
              'day': 7,
              'openingPeriods': [
                {
                  'openTimeInUTC': {'hour': 9, 'minute': 0},
                  'closeTimeInUTC': {'hour': 19, 'minute': 30},
                },
              ],
            },
          ],
        },
        'address': <String, dynamic>{
          'additionalInformation': 'Tchopetyamo, Yaoundé.',
          'city': 'Yaounde',
          'country': 'Cameroon',
          'latitude': 3.887451,
          'longitude': 11.502785,
          'postalCode': 'Yaoundé BP 10073, Cameroon',
          'street': 'Quartier Bastos',
        },
        'averageCookingTimeInMinutes': <String, dynamic>{
          'max': 45,
          'min': 20,
        },
        'brandName': 'Tchopetyamob',
        'contacts': <String, dynamic>{
          'phoneNumbers': <String>['+237656415639'],
          'socials': {
            'facebook': <String>['https://www.facebook.com/tchopetyamo'],
          },
          'website': 'https://www.tchopetyamo.com/firstTime/',
        },
        'cuisineType': <String>['Continental', 'Cameroonian', 'Italian'],
        'description': 'Beignets et Haricots.',
        'images': <String, dynamic>{
          'bannerPath': 'le_grilladin_res.png',
          'previewsPath': <String>['le_grilladin_res.png'],
          'thumbPath': 'le_grilladin_res.png',
        },
        'managersIds': <String>['/users/users_1'],
        'earningsDepositsAccounts': <String, dynamic>{
          'earningsDepositsNumbers': <Map<String, dynamic>>[
            {
              'networkOperator': 'MTN',
              'phoneNumber': '+237695326548',
            },
          ],
        },
        'numberOfReviews': 2,
        'orderOptions': <String>['takeAway', 'dineIn', 'delivery'],
        'rating': 3.0,
        'menuItems': <String, dynamic>{
          'menuItems_1': <String, dynamic>{
            'cookingTimeInMinutes': <String, dynamic>{'max': 25, 'min': 15},
            'foodName': 'Beignet Haricot Bouillie',
            'shortDescription': 'Cooked with no salt. Served with plantains,'
                ' fries or bread.',
            'foodType': 'Cameroon',
            'imagePath': 'bhb.jpg',
            'numberOfPerson': 1,
            'priceInXAF': 250,
            'packageFee': 350,
            'isVegetarian': true,
            'isAvailable': true,
          },
          'menuItems_2': <String, dynamic>{
            'cookingTimeInMinutes': <String, dynamic>{'max': 35, 'min': 20},
            'foodName': 'Legumes Saute',
            'shortDescription': 'Cooked with no salt. Served with plantains,'
                ' fries or bread.',
            'foodType': 'Cameroon',
            'imagePath': 'legume_saute.jpg',
            'numberOfPerson': 2,
            'priceInXAF': 1000,
            'packageFee': 500,
            'isVegetarian': false,
            'isAvailable': true,
          },
          'menuItems_3': <String, dynamic>{
            'cookingTimeInMinutes': <String, dynamic>{'max': 15, 'min': 30},
            'foodName': 'Salades',
            'shortDescription': 'Cooked with no salt. Served with plantains,'
                ' fries or bread.',
            'foodType': 'Cameroonian',
            'imagePath': 'salads.jpg',
            'numberOfPerson': 1,
            'priceInXAF': 700,
            'packageFee': 150,
            'isVegetarian': false,
            'isAvailable': true,
          },
        },
        'reviews': <String, dynamic>{
          'reviews_1': <String, dynamic>{
            'note': 5,
            'review': 'Good restaurant',
            'userPath': '/users/users_2',
          },
          'reviews_2': <String, dynamic>{
            'note': 4,
            'review': 'Good restaurant',
            'userPath': '/users/users_1',
          },
        },
        'isActive': true,
      },
      'restaurants_5': <String, dynamic>{
        'openingTimes': <String, dynamic>{
          'openingDay': [
            {
              'day': 1,
              'openingPeriods': [
                {
                  'openTimeInUTC': {'hour': 9, 'minute': 0},
                  'closeTimeInUTC': {'hour': 19, 'minute': 30},
                },
              ],
            },
            {
              'day': 7,
              'openingPeriods': [
                {
                  'openTimeInUTC': {'hour': 9, 'minute': 0},
                  'closeTimeInUTC': {'hour': 19, 'minute': 30},
                },
              ],
            },
          ],
        },
        'address': <String, dynamic>{
          'additionalInformation': 'Nv Rte Bastos, Yaoundé, Cameroon.',
          'city': 'Yaounde',
          'country': 'Cameroon',
          'latitude': 3.8379,
          'longitude': 11.516675,
          'postalCode': '',
          'street': 'Nv Rte Bastos',
        },
        'averageCookingTimeInMinutes': <String, dynamic>{
          'max': 45,
          'min': 20,
        },
        'brandName': 'Socrat Restaurant',
        'contacts': <String, dynamic>{
          'phoneNumbers': <String>['+2390040404'],
          'socials': {
            'facebook': <String>[
              'https://www.facebook.com/Socrat-Restaurant-175143009346484',
            ],
          },
          'website': 'https://www.socratrestaurant.com/contacts.php',
        },
        'cuisineType': <String>['Continental', 'Cameroonian', 'Italian'],
        'description': 'Beignets et Haricots.',
        'images': <String, dynamic>{
          'bannerPath': 'le_grilladin_res.png',
          'previewsPath': <String>['le_grilladin_res.png'],
          'thumbPath': 'le_grilladin_res.png',
        },
        'managersIds': <String>['/users/users_1'],
        'earningsDepositsAccounts': <String, dynamic>{
          'earningsDepositsNumbers': <Map<String, dynamic>>[
            {
              'networkOperator': 'MTN',
              'phoneNumber': '+237695326548',
            },
          ],
        },
        'numberOfReviews': 2,
        'orderOptions': <String>['takeAway', 'dineIn', 'delivery'],
        'rating': 3.0,
        'menuItems': <String, dynamic>{
          'menuItems_1': <String, dynamic>{
            'cookingTimeInMinutes': <String, dynamic>{'max': 25, 'min': 15},
            'foodName': 'Beignet Haricot Bouillie',
            'shortDescription': 'Cooked with no salt. Served with plantains,'
                ' fries or bread.',
            'foodType': 'Cameroon',
            'imagePath': 'bhb.jpg',
            'numberOfPerson': 1,
            'priceInXAF': 250,
            'packageFee': 200,
            'isVegetarian': true,
            'isAvailable': true,
          },
          'menuItems_2': <String, dynamic>{
            'cookingTimeInMinutes': <String, dynamic>{'max': 35, 'min': 20},
            'foodName': 'Legumes Saute',
            'shortDescription': 'Cooked with no salt. Served with plantains,'
                ' fries or bread.',
            'foodType': 'Cameroon',
            'imagePath': 'legume_saute.jpg',
            'numberOfPerson': 2,
            'priceInXAF': 1000,
            'packageFee': 150,
            'isVegetarian': false,
            'isAvailable': false,
          },
          'menuItems_3': <String, dynamic>{
            'cookingTimeInMinutes': <String, dynamic>{'max': 15, 'min': 30},
            'foodName': 'Salades',
            'shortDescription': 'Cooked with no salt. Served with plantains,'
                ' fries or bread.',
            'foodType': 'Cameroonian',
            'imagePath': 'salads.jpg',
            'numberOfPerson': 1,
            'priceInXAF': 700,
            'packageFee': 450,
            'isVegetarian': false,
            'isAvailable': true,
          },
        },
        'reviews': <String, dynamic>{
          'reviews_1': <String, dynamic>{
            'note': 5,
            'review': 'Good restaurant',
            'userPath': '/users/users_2',
          },
          'reviews_2': <String, dynamic>{
            'note': 4,
            'review': 'Good restaurant',
            'userPath': '/users/users_1',
          },
        },
        'isActive': true,
      },
      'restaurants_6': <String, dynamic>{
        'address': <String, dynamic>{
          'additionalInformation': 'Monte cradat',
          'city': 'Yaoundé',
          'country': 'Cameroon',
          'latitude': 3.824331,
          'longitude': 11.516417,
          'postalCode': '',
          'street': 'Joseph Tchooungui Akoa',
        },
        'averageCookingTimeInMinutes': <String, dynamic>{
          'max': 30,
          'min': 20,
        },
        'brandName': 'Snap Burger',
        'contacts': <String, dynamic>{
          'phoneNumbers': <String>['+237697701957'],
          'socials': <String, dynamic>{
            'facebook': <String>['https://www.facebook.com/snapburger17'],
          },
          'website': 'spreeloop.com',
        },
        'cuisineType': <String>['British'],
        'description': 'Restaurant with good Burgers',
        'images': <String, dynamic>{
          'bannerPath': 'link.jpg',
          'previewsPath': <String>['link.jpg'],
          'thumbPath': 'link.jpg',
        },
        'managersIds': <String>['users/users_1'],
        'earningsDepositsAccounts': <String, dynamic>{
          'earningsDepositsNumbers': <Map<String, dynamic>>[
            {
              'networkOperator': 'MTN',
              'phoneNumber': '+237695326548',
            },
          ],
        },
        'numberOfReviews': 2,
        'orderOptions': <String>['takeAway', 'delivery'],
        'rating': 2.8,
        'menuItemAddOns': <String, dynamic>{
          'menuItemAddOn_1': <String, dynamic>{
            'itemName': 'Medium Pan (26 cm - 6 parts)',
            'additionalPriceInXAF': 1500,
            'isAvailable': true,
          },
        },
        'menuItems': <String, dynamic>{
          'menuItems_1': <String, dynamic>{
            'cookingTimeInMinutes': <String, dynamic>{'max': 25, 'min': 15},
            'foodName': 'Brochettes de boeufs',
            'shortDescription': 'Cooked with no salt. Served with plantains,'
                ' fries or bread.',
            'foodType': 'Cameroon',
            'imagePath': 'brochettes.jpg',
            'numberOfPerson': 1,
            'priceInXAF': 1000,
            'packageFee': 250,
            'isVegetarian': true,
            'isAvailable': true,
            'addOnGroups': <String, dynamic>{
              'addOnGroup_1': <String, dynamic>{
                'description': 'Taille de la pate',
                'required': true,
                'multiSelect': false,
                'addOnItems': <String, dynamic>{
                  'addOnItem_1': <String, dynamic>{
                    'additionalPriceInXAF': null,
                    'isAvailable': true,
                    'menuItemAddOnId': 'menuItemAddOn_1',
                  },
                },
              },
            },
          },
          'menuItems_2': <String, dynamic>{
            'cookingTimeInMinutes': <String, dynamic>{'max': 35, 'min': 20},
            'foodName': 'O\'kok',
            'shortDescription': 'Cooked with no salt. Served with plantains,'
                ' fries or bread.',
            'foodType': 'Cameroon',
            'imagePath': 'okok.jpg',
            'numberOfPerson': 2,
            'priceInXAF': 1050,
            'packageFee': 450,
            'isVegetarian': false,
            'isAvailable': true,
            'addOnGroups': <String, dynamic>{
              'addOnGroup_1': <String, dynamic>{
                'description': 'Taille de la pate',
                'required': false,
                'multiSelect': false,
                'addOnItems': <String, dynamic>{
                  'addOnItem_1': <String, dynamic>{
                    'additionalPriceInXAF': null,
                    'isAvailable': true,
                    'menuItemAddOnId': 'menuItemAddOn_1',
                  },
                },
              },
            },
          },
          'menuItems_3': <String, dynamic>{
            'cookingTimeInMinutes': <String, dynamic>{'max': 35, 'min': 20},
            'foodName': 'O\'kok',
            'shortDescription': 'Cooked with no salt. Served with plantains,'
                ' fries or bread.',
            'foodType': 'Cameroon',
            'imagePath': 'okok.jpg',
            'numberOfPerson': 2,
            'priceInXAF': 1050,
            'packageFee': 450,
            'isVegetarian': false,
            'isAvailable': false,
            'addOnGroups': <String, dynamic>{
              'addOnGroup_1': <String, dynamic>{
                'description': 'Taille de la pate',
                'required': true,
                'multiSelect': false,
                'addOnItems': <String, dynamic>{
                  'addOnItem_1': <String, dynamic>{
                    'additionalPriceInXAF': null,
                    'isAvailable': false,
                    'menuItemAddOnId': 'menuItemAddOn_1',
                  },
                },
              },
            },
          },
        },
        'reviews': <String, dynamic>{
          'reviews_1': <String, dynamic>{
            'note': 4,
            'review': 'Good restaurant',
            'userPath': '/users/users_2',
          },
          'reviews_2': <String, dynamic>{
            'note': 2,
            'review': 'Too bad',
            'userPath': '/users/users_1',
          },
        },
        'isActive': true,
      },
    },
    'favorites': <String, dynamic>{
      'favorites_1': <String, dynamic>{
        'userPath': 'users/users_1',
        'itemPath': 'restaurants/restaurants_1/menuItems/menuItems_1',
      },
      'favorites_2': <String, dynamic>{
        'userPath': 'users/users_1',
        'itemPath': 'restaurants/restaurants_1/menuItems/menuItems_2',
      },
      'favorites_3': <String, dynamic>{
        'userPath': 'users/users_1',
        'itemPath': 'restaurants/restaurants_2/menuItems/menuItems_1',
      },
    },
    'payments': <String, dynamic>{
      'payments_1': <String, dynamic>{
        'amount': 10350,
        'currency': 'XAF',
        'gateway': 'Orange Money',
        'payerAccount': '237696292947',
        'userPath': 'users/users_1',
        'transactionId': '55040',
        'createdAt': '2021-07-02T08:44:29.897Z',
        'updatedAt': '2021-07-02T08:44:29.897Z',
        'status': 'SUCCEEDED',
      },
      'payments_2': <String, dynamic>{
        'amount': 10350,
        'currency': 'XAF',
        'gateway': 'PayPal',
        'payerAccount': 'madison237',
        'userPath': 'users/users_1',
        'transactionId': '23545',
        'createdAt': '2021-05-02T08:34:29.897Z',
        'updatedAt': '2021-05-02T08:34:29.897Z',
        'status': 'CANCELED',
      },
      'payments_3': <String, dynamic>{
        'amount': 10350,
        'currency': 'XAF',
        'gateway': 'PayPal',
        'payerAccount': 'madison237',
        'userPath': 'users/users_1',
        'transactionId': '23545',
        'createdAt': '2021-05-02T08:34:29.897Z',
        'updatedAt': '2021-05-02T08:34:29.897Z',
        'status': 'INITIATED',
      },
    },
    'ordersGroups': <String, dynamic>{
      'ordersGroups_1': <String, dynamic>{
        'userPath': 'users/users_1',
        'createdAt': '2021-07-02T08:44:29.897Z',
        'paymentInfoPath': 'payments/payments_1',
        'orders': <String, dynamic>{
          'restaurants_1': <String, dynamic>{
            'selectedItems': <Map<String, dynamic>>[
              <String, dynamic>{
                'foodName': 'Pizza',
                'menuItemPath':
                    'restaurants/restaurants_3/menuItems/menuItems_1',
                'count': 2,
                'isVegetarian': true,
                'priceInXAF': 250,
              },
              <String, dynamic>{
                'foodName': 'Pizza',
                'menuItemPath':
                    'restaurants/restaurants_3/menuItems/menuItems_1',
                'count': 5,
                'isVegetarian': true,
                'priceInXAF': 250,
              },
              <String, dynamic>{
                'foodName': 'Beignet Haricot Bouillie',
                'menuItemPath':
                    'restaurants/restaurants_1/menuItems/menuItems_1',
                'count': 1,
                'isVegetarian': true,
                'priceInXAF': 250,
                'specialRequest': 'Pas de sucre sur la boullie',
              },
              <String, dynamic>{
                'foodName': 'Legumes Saute',
                'menuItemPath':
                    'restaurants/restaurants_1/menuItems/menuItems_2',
                'count': 2,
                'priceInXAF': 1000,
                'isVegetarian': false,
              },
              <String, dynamic>{
                'foodName': 'Salades',
                'menuItemPath':
                    'restaurants/restaurants_1/menuItems/menuItems_3',
                'count': 1,
                'priceInXAF': 700,
                'isVegetarian': false,
              },
            ],
            'delivery': <String, dynamic>{
              'deliveryCode': '1234',
              'fee': 200,
              'deliveryContact': '+237655248756',
              'courierId': 'users_1',
              'location': <String, dynamic>{
                'latitude': 3.85917,
                'longitude': 11.51905,
                'country': 'South Africa',
                'city': 'Cape Town 8000',
                'street': '36 Buitenkant St, Cape Town City Centre',
              },
              'createdAt': '2021-07-02T08:44:29.897Z',
            },
            'specialRequest': 'No pepe soup',
            'brandName': 'The Pot Luck Club',
            'placePath': 'restaurants/restaurants_1',
            'userPath': 'users/users_1',
            'paymentInfoPath': 'payments/payments_1',
            'serviceFees': 300,
            'total': 3450,
            'createdAt': '2021-07-02T08:40:29.897Z',
            'updatedAt': '2021-07-02T08:44:29.897Z',
            'status': 'ACCEPTED_BY_COURIER',
          },
          'restaurants_2': <String, dynamic>{
            'selectedItems': <Map<String, dynamic>>[
              <String, dynamic>{
                'foodName': 'Mouton grille',
                'menuItemPath':
                    'restaurants/restaurants_2/menuItems/menuItems_2',
                'count': 1,
                'priceInXAF': 4500,
                'isVegetarian': false,
              },
            ],
            'delivery': <String, dynamic>{
              'fee': 100,
              'location': <String, dynamic>{
                'latitude': 3.85917,
                'longitude': 11.51905,
                'country': 'South Africa',
                'city': 'Cape Town 8000',
                'street': '36 Buitenkant St, Cape Town City Centre',
              },
            },
            'placePath': 'restaurants/restaurants_2',
            'userPath': 'users/users_1',
            'paymentInfoPath': 'payments/payments_1',
            'serviceFees': 300,
            'brandName': 'Italian Dream',
            'createdAt': '2021-07-02T08:41:29.897Z',
            'updatedAt': '2021-07-02T08:44:29.897Z',
            'total': 4900,
            'status': 'DONE',
          },
          'restaurants_3': <String, dynamic>{
            'selectedItems': <Map<String, dynamic>>[
              <String, dynamic>{
                'foodName': 'O\'kok',
                'specialRequest': 'more cassava',
                'menuItemPath':
                    'restaurants/restaurants_3/menuItems/menuItems_2',
                'count': 1,
                'priceInXAF': 1050,
                'isVegetarian': false,
              },
              <String, dynamic>{
                'foodName': 'Brochettes de boeufs',
                'menuItemPath':
                    'restaurants/restaurants_3/menuItems/menuItems_1',
                'count': 2,
                'priceInXAF': 1000,
                'isVegetarian': true,
              },
            ],
            'takeAway': <String, dynamic>{
              'arrivalDateTime': '2021-07-12T08:44:29.897Z',
            },
            'placePath': 'restaurants/restaurants_3',
            'userPath': 'users/users_1',
            'paymentInfoPath': 'payments/payments_1',
            'createdAt': '2021-07-02T08:42:29.897Z',
            'updatedAt': '2021-07-02T08:44:29.897Z',
            'brandName': 'Black Sheep Restaurant',
            'serviceFees': 300,
            'total': 3350,
            'status': 'PENDING',
            'statusUpdates': <Map<String, dynamic>>[
              <String, dynamic>{
                'timeInUTC': '2022-03-25T15:33:05.020Z',
                'status': 'PENDING',
              },
              <String, dynamic>{
                'timeInUTC': '2022-03-25T15:53:05.020Z',
                'status': 'ACCEPTED_BY_PLACE',
              },
              <String, dynamic>{
                'timeInUTC': '2022-03-25T16:00:05.020Z',
                'status': 'IN_PREPARATION',
              },
              <String, dynamic>{
                'timeInUTC': '2022-03-25T16:20:05.020Z',
                'status': 'READY_TO_COLLECT',
              },
              <String, dynamic>{
                'timeInUTC': '2022-03-25T17:00:05.020Z',
                'status': 'DONE',
              },
            ],
          },
        },
      },
      'ordersGroups_2': <String, dynamic>{
        'userPath': 'users/users_1',
        'createdAt': '2021-05-02T08:44:29.897Z',
        'paymentInfoPath': 'payments/payments_2',
        'orders': <String, dynamic>{
          'restaurants_3': <String, dynamic>{
            'selectedItems': <Map<String, dynamic>>[
              <String, dynamic>{
                'foodName': 'Pizza',
                'menuItemPath':
                    'restaurants/restaurants_3/menuItems/menuItems_1',
                'count': 2,
                'isVegetarian': true,
                'priceInXAF': 250,
                'addOnGroupSelected': <Map<String, dynamic>>[
                  <String, dynamic>{
                    'addOnGroup': <String, dynamic>{
                      'description': 'Supplement',
                      'required': false,
                      'multiSelect': false,
                    },
                    'addOnItemSelected': <Map<String, dynamic>>[
                      <String, dynamic>{
                        'addOnId': 'menuItemAddOn_1',
                        'addOnName': 'Mayonnaise',
                        'additionalPriceInXAF': 100,
                      },
                      <String, dynamic>{
                        'addOnId': 'menuItemAddOn_1',
                        'addOnName': 'Pigment',
                        'additionalPriceInXAF': 0,
                      },
                      <String, dynamic>{
                        'addOnId': 'menuItemAddOn_1',
                        'addOnName': 'Ketchup',
                        'additionalPriceInXAF': 200,
                      }
                    ],
                  },
                ],
              },
              <String, dynamic>{
                'foodName': 'Beignet Haricot Bouillie',
                'menuItemPath':
                    'restaurants/restaurants_1/menuItems/menuItems_1',
                'count': 1,
                'isVegetarian': true,
                'priceInXAF': 250,
                'specialRequest': 'Pas de sucre sur la boullie',
              },
            ],
            'delivery': <String, dynamic>{
              'deliveryCode': '1234',
              'fee': 200,
              'deliveryContact': '+237655248756',
              'location': <String, dynamic>{
                'latitude': 3.85917,
                'longitude': 11.51905,
                'country': 'South Africa',
                'city': 'Cape Town 8000',
                'street': '36 Buitenkant St, Cape Town City Centre',
              },
            },
            'brandName': 'The Pot Luck Club',
            'placePath': 'restaurants/restaurants_1',
            'promotionCode': 'FAKEPROMO',
            'userPath': 'users/users_1',
            'serviceFees': 300,
            'packageFee': 200,
            'paymentInfoPath': 'payments/payments_2',
            'createdAt': '2021-05-02T08:43:29.897Z',
            'updatedAt': '2021-05-02T08:44:29.897Z',
            'total': 4500,
            'totalDiscountInXAF': 2500,
            'status': 'PENDING',
            'statusUpdates': <Map<String, dynamic>>[
              <String, dynamic>{
                'timeInUTC': '2022-03-25T15:33:05.020Z',
                'status': 'PENDING',
              },
              <String, dynamic>{
                'timeInUTC': '2022-03-25T15:53:05.020Z',
                'status': 'REJECTED_BY_PLACE',
              },
            ],
          },
          'restaurants_2': <String, dynamic>{
            'selectedItems': <Map<String, dynamic>>[
              <String, dynamic>{
                'foodName': 'Mouton grille',
                'menuItemPath':
                    'restaurants/restaurants_2/menuItems/menuItems_2',
                'count': 1,
                'priceInXAF': 4500,
                'isVegetarian': false,
              },
            ],
            'delivery': <String, dynamic>{
              'fee': 100,
              'location': <String, dynamic>{
                'latitude': 3.85917,
                'longitude': 11.51905,
                'country': 'South Africa',
                'city': 'Cape Town 8000',
                'street': '36 Buitenkant St, Cape Town City Centre',
              },
            },
            'brandName': 'Italian Dream',
            'placePath': 'restaurants/restaurants_2',
            'paymentInfoPath': 'payments/payments_2',
            'promotionCode': 'FAKEPROMO',
            'serviceFees': 300,
            'createdAt': '2021-05-02T08:44:29.897Z',
            'updatedAt': '2021-05-02T08:45:29.897Z',
            'total': 4900,
            'totalDiscountInXAF': 2500,
            'status': 'EXPIRED',
            'statusUpdates': <Map<String, dynamic>>[
              <String, dynamic>{
                'timeInUTC': '2022-03-25T15:33:05.020Z',
                'status': 'PENDING',
              },
              <String, dynamic>{
                'timeInUTC': '2022-03-25T15:53:05.020Z',
                'status': 'EXPIRED',
              },
            ],
          },
        },
      },
      'ordersGroups_3': <String, dynamic>{
        'userPath': 'users/users_1',
        'createdAt': '2021-05-02T10:44:29.897Z',
        'paymentInfoPath': 'payments/payments_2',
        'orders': <String, dynamic>{
          'restaurants_1': <String, dynamic>{
            'selectedItems': <Map<String, dynamic>>[
              <String, dynamic>{
                'foodName': 'Legumes Saute',
                'menuItemPath':
                    'restaurants/restaurants_1/menuItems/menuItems_2',
                'count': 2,
                'priceInXAF': 2000,
                'isVegetarian': false,
              },
            ],
            'delivery': <String, dynamic>{
              'deliveryCode': '1234',
              'fee': 200,
              'deliveryContact': '+237655248756',
              'location': <String, dynamic>{
                'latitude': 3.85917,
                'longitude': 11.51905,
                'country': 'South Africa',
                'city': 'Cape Town 8000',
                'street': '36 Buitenkant St, Cape Town City Centre',
              },
            },
            'brandName': 'The Pot Luck Club',
            'placePath': 'restaurants/restaurants_1',
            'userPath': 'users/users_1',
            'paymentInfoPath': 'payments/payments_2',
            'serviceFees': 300,
            'createdAt': '2021-05-02T10:45:29.897Z',
            'updatedAt': '2021-05-02T10:46:29.897Z',
            'total': 4500,
            'status': 'READY_TO_DELIVER',
            'courierStatus': 'PENDING_COURIER',
            'statusUpdates': <Map<String, dynamic>>[
              <String, dynamic>{
                'timeInUTC': '2022-03-25T15:33:05.020Z',
                'status': 'PENDING',
              },
              <String, dynamic>{
                'timeInUTC': '2022-03-25T15:53:05.020Z',
                'status': 'ACCEPTED_BY_PLACE',
              },
              <String, dynamic>{
                'timeInUTC': '2022-03-25T16:00:05.020Z',
                'status': 'IN_PREPARATION',
              },
              <String, dynamic>{
                'timeInUTC': '2022-03-25T16:20:05.020Z',
                'status': 'READY_TO_DELIVER',
              },
              <String, dynamic>{
                'timeInUTC': '2022-03-25T16:30:05.020Z',
                'status': 'ACCEPTED_BY_COURIER',
              },
              <String, dynamic>{
                'timeInUTC': '2022-03-25T16:35:05.020Z',
                'status': 'ON_THE_WAY',
              },
              <String, dynamic>{
                'timeInUTC': '2022-03-25T17:00:05.020Z',
                'status': 'DONE',
              },
            ],
          },
          'restaurants_2': <String, dynamic>{
            'selectedItems': <Map<String, dynamic>>[
              <String, dynamic>{
                'foodName': 'Mouton grille',
                'menuItemPath':
                    'restaurants/restaurants_2/menuItems/menuItems_2',
                'count': 1,
                'priceInXAF': 4500,
                'isVegetarian': false,
              },
            ],
            'delivery': <String, dynamic>{
              'fee': 100,
              'location': <String, dynamic>{
                'latitude': 3.85917,
                'longitude': 11.51905,
                'country': 'South Africa',
                'city': 'Cape Town 8000',
                'street': '36 Buitenkant St, Cape Town City Centre',
              },
            },
            'brandName': 'Italian Dream',
            'placePath': 'restaurants/restaurants_2',
            'userPath': 'users/users_1',
            'paymentInfoPath': 'payments/payments_2',
            'serviceFees': 300,
            'createdAt': '2021-05-02T10:46:29.897Z',
            'updatedAt': '2021-05-02T10:47:29.897Z',
            'total': 4900,
            'status': 'DONE',
          },
        },
      },
      'ordersGroups_4': <String, dynamic>{
        'userPath': 'users/users_2',
        'createdAt': '2021-05-02T10:44:29.897Z',
        'paymentInfoPath': 'payments/payments_2',
        'orders': <String, dynamic>{
          'restaurants_3': <String, dynamic>{
            'selectedItems': <Map<String, dynamic>>[
              <String, dynamic>{
                'menuItemUID': 1,
                'foodName': 'Legumes Saute',
                'menuItemPath':
                    'restaurants/restaurants_1/menuItems/menuItems_2',
                'count': 2,
                'priceInXAF': 2000,
                'isVegetarian': false,
              },
            ],
            'delivery': <String, dynamic>{
              'deliveryCode': '1234',
              'fee': 200,
              'deliveryContact': '+237655248756',
              'location': <String, dynamic>{
                'latitude': 3.85917,
                'longitude': 11.51905,
                'country': 'South Africa',
                'city': 'Cape Town 8000',
                'street': '36 Buitenkant St, Cape Town City Centre',
              },
            },
            'brandName': 'The Pot Luck Club',
            'placePath': 'restaurants/restaurants_3',
            'userPath': 'users/users_2',
            'paymentInfoPath': 'payments/payments_2',
            'serviceFees': 300,
            'createdAt': '2021-05-02T10:44:29.897Z',
            'updatedAt': '2021-05-02T10:44:29.897Z',
            'total': 4500,
            'status': 'READY_TO_DELIVER',
            'courierStatus': 'PENDING_COURIER',
          },
        },
      },
      'ordersGroups_5': <String, dynamic>{
        'userPath': 'users/users_5',
        'createdAt': '2021-05-02T10:44:29.897Z',
        'paymentInfoPath': 'payments/payments_2',
        'orders': <String, dynamic>{
          'restaurants_1': <String, dynamic>{
            'selectedItems': <Map<String, dynamic>>[
              <String, dynamic>{
                'menuItemUID': 1,
                'foodName': 'Legumes Saute',
                'menuItemPath':
                    'restaurants/restaurants_1/menuItems/menuItems_2',
                'count': 2,
                'priceInXAF': 2000,
                'isVegetarian': false,
              },
            ],
            'dineIn': <String, dynamic>{
              'numberOfMembers': 4,
              'arrivalDateTime': '2021-07-12T08:44:29.897Z',
            },
            'brandName': 'The Pot Luck Club',
            'placePath': 'restaurants/restaurants_1',
            'userPath': 'users/users_5',
            'paymentInfoPath': 'payments/payments_2',
            'serviceFees': 300,
            'createdAt': '2021-05-02T10:44:29.897Z',
            'updatedAt': '2021-05-02T10:44:29.897Z',
            'total': 4500,
            'status': 'EXPIRED',
          },
        },
      },
    },
    'feedbacks': {},
    'partners': <String, dynamic>{
      'users_1': <String, dynamic>{
        'toBePaid': 500,
        'userId': 'users/users_1',
        'placePath': 'restaurants/restaurants_3',
        'preparedOrders': [
          {
            'groupId': 'ordersGroups/ordersGroups_1',
            'orderIndex': 0,
            'price': 3450,
          },
        ],
      },
      'anon_uid': <String, dynamic>{
        'toBePaid': 500,
        'userId': 'users/users_1',
        'placePath': 'restaurants/restaurants_3',
        'preparedOrders': [
          {
            'groupId': 'ordersGroups/ordersGroups_1',
            'orderIndex': 0,
            'price': 3450,
          },
        ],
      },
      'users_2': <String, dynamic>{
        'toBePaid': 500,
        'userId': 'users/users_1',
        'placePath': 'restaurants/restaurants_3',
        'preparedOrders': [
          {
            'groupId': 'ordersGroups/ordersGroups_4',
            'orderIndex': 0,
            'price': 4000,
          },
        ],
      },
    },
    'couriers': <String, dynamic>{
      'users_1': <String, dynamic>{
        'isOnline': true,
        'canAcceptMultipleOrders': false,
        'canGenerateBeeOrder': false,
        'ordersForDelivery': <String, Map<String, dynamic>>{
          'ordersGroups_3::restaurants_1': <String, dynamic>{
            'deliveryFees': 200,
            'deliveryProgress': <String, dynamic>{
              'lng': 4.541256,
              'lat': 4.2158985,
              'createdAt': '2022-01-21T12:30:29.897Z',
            },
            'createdAt': '2022-01-21T12:30:29.897Z',
            'orderPath': 'ordersGroups/ordersGroups_3/orders/restaurants_1',
          },
        },
        'validationStatus': 'approved',
        'drivingLicencePath': 'couriers/users_1/driving_licence.png',
        'nationalIdentityPath':
            'couriers/users_1/national_identity_card_document.png',
      },
      'users_2': <String, dynamic>{
        'isOnline': true,
        'canAcceptMultipleOrders': false,
        'canGenerateBeeOrder': false,
        'ordersForDelivery': <String, Map<String, dynamic>>{
          'ordersGroups_3::restaurants_1': <String, dynamic>{
            'deliveryFees': 200,
            'deliveryProgress': <String, dynamic>{
              'lng': 4.541256,
              'lat': 4.2158985,
              'createdAt': '2022-01-21T12:30:29.897Z',
            },
            'createdAt': '2022-01-21T12:30:29.897Z',
            'orderPath': 'ordersGroups/ordersGroups_3/orders/restaurants_1',
          },
        },
        'validationStatus': 'pending',
        'drivingLicencePath': 'couriers/users_2/driving_licence.png',
        'nationalIdentityPath':
            'couriers/users_2/national_identity_card_document.png',
      },
    },
    'zones': <String, dynamic>{
      'zone_1': <String, dynamic>{
        'active': true,
        'name': 'douala',
        'center': <String, dynamic>{
          'latitude': 4.541256,
          'longitude': 4.2158985,
        },
        'polygon': <Map<String, dynamic>>[
          <String, dynamic>{
            'latitude': 4.58965,
            'longitude': 40213598,
          },
          <String, dynamic>{
            'latitude': 4.5524,
            'longitude': 4.55899,
          },
          <String, dynamic>{
            'latitude': 4.524156,
            'longitude': 4.558896,
          },
          <String, dynamic>{
            'latitude': 4.57789,
            'longitude': 4.255332,
          },
          <String, dynamic>{
            'latitude': 4.574789,
            'longitude': 4.2155587,
          },
          <String, dynamic>{
            'latitude': 4.8563214,
            'longitude': 4.213569,
          },
          <String, dynamic>{
            'latitude': 4.5632458,
            'longitude': 4.213569,
          },
          <String, dynamic>{
            'latitude': 4.563548,
            'longitude': 4.3215698,
          },
        ],
      },
    },
    'earningsWithdrawals': <String, dynamic>{
      'earningsWithdrawal_1': <String, dynamic>{
        'amount': 5600,
        'applicationName': 'PARTNER',
        'createdAtInUTC': 'Tue, 10 May 2022 15:36:28 GMT',
        'currency': 'XAF',
        'earningsNumber': '+237679124975',
        'gateway': 'cinetpay',
        'placePath': 'restaurants/restaurants_3',
        'status': 'PENDING',
        'updatedAtInUTC': 'Tue, 10 May 2022 15:36:33 GMT',
        'userPath': 'users/users_1',
      },
      'earningsWithdrawal_2': <String, dynamic>{
        'amount': 5600,
        'applicationName': 'PARTNER',
        'createdAtInUTC': 'Tue, 10 May 2022 15:36:28 GMT',
        'currency': 'XAF',
        'earningsNumber': '+237679124975',
        'gateway': 'cinetpay',
        'placePath': 'restaurants/restaurants_3',
        'status': 'INITIALIZED',
        'updatedAtInUTC': 'Tue, 10 May 2022 15:36:33 GMT',
        'userPath': 'users/users_1',
      },
      'earningsWithdrawal_3': <String, dynamic>{
        'amount': 5600,
        'applicationName': 'COURIER',
        'createdAtInUTC': 'Tue, 10 May 2022 15:36:28 GMT',
        'currency': 'XAF',
        'earningsNumber': '+237679124975',
        'gateway': 'cinetpay',
        'status': 'INITIALIZED',
        'updatedAtInUTC': 'Tue, 10 May 2022 15:36:33 GMT',
        'userPath': 'users/users_2',
      },
    },
    'reviewOrders': <String, dynamic>{
      'restaurants_1': <String, dynamic>{
        'singleReviewOrders': <String, dynamic>{
          'singleReview_1': <String, dynamic>{
            'orderPath': 'orders/order_1',
            'placePath': 'restaurants/restaurants_1',
            'status': 'DONE',
            'userPath': 'users/users_1',
            'punctualityQuality': 5,
            'foodQuality': 5,
            'serviceQuality': 5,
            'packagingQuality': 5,
            'orderReviewOverallScore': 5.0,
            'review': 'The service quality is nice,'
                ' I recommend you to go an enjoy too.'
                ' What do you think about it? let order now.'
                ' The packaging quality is beautiful,'
                ' I recommend you to make a take away.'
                ' What do you think about it? let order now.',
            'createdAt': '2022-01-21T12:30:29.897Z',
            'updatedAt': '2022-01-21T12:30:29.897Z',
          },
          'singleReview_2': <String, dynamic>{
            'orderPath': 'orders/order_2',
            'placePath': 'restaurants/restaurants_1',
            'status': 'DONE',
            'userPath': 'users/users_2',
            'punctualityQuality': 2,
            'foodQuality': 2,
            'serviceQuality': 4,
            'packagingQuality': 4,
            'orderReviewOverallScore': 3.0,
            'review': 'The packaging quality is beautiful,'
                ' I recommend you to make a take away.'
                ' What do you think about it? let order now.',
            'createdAt': '2022-01-21T11:30:29.897Z',
            'updatedAt': '2022-01-21T12:30:29.897Z',
          },
          'singleReview_3': <String, dynamic>{
            'orderPath': 'orders/order_2',
            'placePath': 'restaurants/restaurants_1',
            'status': 'DONE',
            'userPath': 'users/users_3',
            'review': 'The food was absolutely delicious,'
                ' I recommend you to make a take away.'
                ' What do you think about it? let order now',
            'createdAt': '2022-01-21T10:30:29.897Z',
            'updatedAt': '2022-01-21T12:30:29.897Z',
          },
          'singleReview_4': <String, dynamic>{
            'orderPath': 'orders/order_2',
            'placePath': 'restaurants/restaurants_1',
            'status': 'DONE',
            'userPath': 'users/users_2',
            'review': 'The packaging quality is beautiful,'
                ' I recommend you to make a take away.'
                ' What do you think about it? let order now',
            'createdAt': '2022-01-21T12:35:29.897Z',
            'updatedAt': '2022-01-21T12:30:29.897Z',
          },
          'singleReview_5': <String, dynamic>{
            'orderPath': 'orders/order_2',
            'placePath': 'restaurants/restaurants_1',
            'status': 'DONE',
            'userPath': 'users/users_1',
            'review': 'The service quality was nice,'
                ' I recommend you to make a take away.'
                ' What do you think about it? let order now',
            'createdAt': '2022-01-21T12:40:29.897Z',
            'updatedAt': '2022-01-21T12:30:29.897Z',
          },
        },
      },
      'restaurants_3': <String, dynamic>{
        'singleReviewOrders': <String, dynamic>{
          'singleReview_1': <String, dynamic>{
            'orderPath': 'ordersGroups/ordersGroups_1/orders/restaurants_3',
            'placePath': 'restaurants/restaurants_1',
            'status': 'DONE',
            'userPath': 'users/users_1',
            'punctualityQuality': 5,
            'foodQuality': 3,
            'serviceQuality': 4,
            'packagingQuality': 4,
            'orderReviewOverallScore': 4.0,
            'review': 'The packaging quality is beautiful,'
                ' I recommend you to make a take away.'
                ' What do you think about it? let order now',
            'createdAt': '2022-01-21T12:30:29.897Z',
            'updatedAt': '2022-01-21T12:30:29.897Z',
          },
          'singleReview_2': <String, dynamic>{
            'orderPath': 'orders/order_2',
            'placePath': 'restaurants/restaurants_3',
            'status': 'DONE',
            'userPath': 'users/users_2',
            'punctualityQuality': 5,
            'foodQuality': 3,
            'serviceQuality': 4,
            'packagingQuality': 4,
            'orderReviewOverallScore': 4.0,
            'review': 'The packaging quality is beautiful,'
                ' I recommend you to make a take away.'
                ' What do you think about it? let order now.',
            'createdAt': '2022-01-21T11:30:29.897Z',
            'updatedAt': '2022-01-21T12:30:29.897Z',
          },
          'singleReview_3': <String, dynamic>{
            'orderPath': 'orders/order_2',
            'placePath': 'restaurants/restaurants_3',
            'status': 'DONE',
            'userPath': 'users/users_3',
            'review': 'The food was absolutely delicious,'
                ' I recommend you to make a take away.'
                ' What do you think about it? let order now',
            'createdAt': '2022-01-21T10:30:29.897Z',
            'updatedAt': '2022-01-21T12:30:29.897Z',
          },
          'singleReview_4': <String, dynamic>{
            'orderPath': 'orders/order_2',
            'placePath': 'restaurants/restaurants_3',
            'status': 'DONE',
            'userPath': 'users/users_2',
            'review': 'The packaging quality is beautiful,'
                ' I recommend you to make a take away.'
                ' What do you think about it? let order now',
            'createdAt': '2022-01-21T12:35:29.897Z',
            'updatedAt': '2022-01-21T12:30:29.897Z',
          },
          'singleReview_5': <String, dynamic>{
            'orderPath': 'orders/order_2',
            'placePath': 'restaurants/restaurants_3',
            'status': 'DONE',
            'userPath': 'users/users_1',
            'review': 'The service quality was nice,'
                ' I recommend you to make a take away.'
                ' What do you think about it? let order now',
            'createdAt': '2022-01-21T12:40:29.897Z',
            'updatedAt': '2022-01-21T12:30:29.897Z',
          },
        },
      },
    },
    'reviewCouriers': <String, dynamic>{
      'users_1': <String, dynamic>{
        'singleReviewCouriers': <String, dynamic>{
          'singleReviewCouriers_1': <String, dynamic>{
            'orderPath': 'ordersGroups/ordersGroups_1/orders/restaurants_1',
            'placePath': 'restaurants/restaurants_1',
            'status': 'DONE',
            'userPath': 'users/users_1',
            'packagingState': 4,
            'politeness': 5,
            'review': 'The service quality is nice,'
                ' I recommend you to go an enjoy too.'
                ' What do you think about it? let order now.'
                ' The packaging quality is beautiful,'
                ' I recommend you to make a take away.'
                ' What do you think about it? let order now.',
            'createdAt': '2022-01-21T12:30:29.897Z',
            'updatedAt': '2022-01-21T12:30:29.897Z',
          },
        },
      },
    },
    'ordersReviews': <String, dynamic>{
      'orderReview_1': <String, dynamic>{
        'orderPath': 'ordersGroups/ordersGroups_5/orders/restaurants_1',
        'placePath': 'restaurants/restaurants_3',
        'status': 'DONE',
        'userPath': 'users/users_1',
        'punctualityQuality': 5,
        'foodQuality': 5,
        'serviceQuality': 5,
        'packagingQuality': 5,
        'orderReviewOverallScore': 5.0,
        'review': 'The service quality is nice,'
            ' I recommend you to go an enjoy too.'
            ' What do you think about it? let order now.'
            ' The packaging quality is beautiful,'
            ' I recommend you to make a take away.'
            ' What do you think about it? let order now.',
        'createdAt': '2022-01-21T12:30:29.897Z',
        'updatedAt': '2022-01-21T12:30:29.897Z',
      },
      'orderReview_2': <String, dynamic>{
        'orderPath': 'ordersGroups/ordersGroups_1/orders/restaurants_2',
        'placePath': 'restaurants/restaurants_1',
        'status': 'DONE',
        'userPath': 'users/users_2',
        'punctualityQuality': 2,
        'foodQuality': 2,
        'serviceQuality': 4,
        'packagingQuality': 4,
        'orderReviewOverallScore': 3.0,
        'review': 'The packaging quality is beautiful,'
            ' I recommend you to make a take away.'
            ' What do you think about it? let order now.',
        'createdAt': '2022-01-21T11:30:29.897Z',
        'updatedAt': '2022-01-21T12:30:29.897Z',
      },
      'orderReview_3': <String, dynamic>{
        'orderPath': 'ordersGroups/ordersGroups_1/orders/restaurants_3',
        'placePath': 'restaurants/restaurants_1',
        'status': 'DONE',
        'userPath': 'users/users_1',
        'punctualityQuality': 5,
        'foodQuality': 3,
        'serviceQuality': 4,
        'packagingQuality': 4,
        'orderReviewOverallScore': 4.0,
        'review': 'The packaging quality is beautiful,'
            ' I recommend you to make a take away.'
            ' What do you think about it? let order now',
        'createdAt': '2022-01-21T12:30:29.897Z',
        'updatedAt': '2022-01-21T12:30:29.897Z',
      },
    },
    'couriersReviews': <String, dynamic>{
      'couriersReviews_1': <String, dynamic>{
        'orderPath': 'ordersGroups/ordersGroups_5/orders/restaurants_1',
        'placePath': 'restaurants/restaurants_1',
        'status': 'DONE',
        'userPath': 'users/users_1',
        'politeness': 5,
        'packagingState': 5,
        'courierPath': 'couriers/users_1',
        'review': 'The service quality is nice,'
            ' I recommend you to order and enjoy too.',
        'createdAt': '2022-01-21T12:30:29.897Z',
        'updatedAt': '2022-01-21T12:30:29.897Z',
      },
      'couriersReviews_2': <String, dynamic>{
        'orderPath': 'ordersGroups/ordersGroups_1/orders/restaurants_2',
        'placePath': 'restaurants/restaurants_1',
        'status': 'DONE',
        'userPath': 'users/users_2',
        'politeness': 2,
        'packagingState': 2,
        'courierPath': 'couriers/users_2',
        'review': 'The packaging quality is beautiful,'
            ' I recommend you to make an oder more often.'
            ' What do you think about it? let order now',
        'createdAt': '2022-01-21T11:30:29.897Z',
        'updatedAt': '2022-01-21T12:30:29.897Z',
      },
      'couriersReviews_3': <String, dynamic>{
        'orderPath': 'ordersGroups/ordersGroups_1/orders/restaurants_3',
        'placePath': 'restaurants/restaurants_1',
        'status': 'DONE',
        'userPath': 'users/users_1',
        'politeness': 5,
        'packagingState': 3,
        'courierPath': 'couriers/users_1',
        'review': 'The packaging quality is beautiful,'
            ' I recommend you to make an oder more often.'
            ' What do you think about it? let order now',
        'createdAt': '2022-01-21T12:30:29.897Z',
        'updatedAt': '2022-01-21T12:30:29.897Z',
      },
    },
    'referralCodes': <String, dynamic>{
      'referral_code_1': <String, dynamic>{
        'code': 'BABA237',
        'autogenerated': true,
        'createdAt': '2022-01-21T12:30:29.897Z',
      },
      'referral_code_2': <String, dynamic>{
        'code': 'BOBO732',
        'autogenerated': false,
        'createdAt': '2022-01-18T11:30:29.897Z',
      },
      'referral_code_3': <String, dynamic>{
        'code': 'MABO237',
        'autogenerated': true,
        'createdAt': '2022-01-15T11:30:29.897Z',
      },
    },

    // The same way we have to create db tables before adding elements, we
    // have to add here top level keys before adding elements.
  };
  final Map<dynamic, Map<dynamic, dynamic>> _testDb;

  /// Constructs of [DatabaseFakeImplementation] with legacy database.
  DatabaseFakeImplementation.legacy() : _testDb = _legacyTestDb;

  /// Constructs of [DatabaseFakeImplementation].
  DatabaseFakeImplementation(Map<dynamic, Map<dynamic, dynamic>> database)
      : _testDb = database;
  final Map<String, String> _testStorage = {
    'imageRef1': 'assetsdefaultProfile1.png',
    'imageRef2': 'assetsdefaultProfile2.png',
  };

  final String _placeholderImagePath = 'assets/image/place_holder.png';
  StreamController<String>? _updateListener;

  @override
  Future<ImageProvider> getImage(String imageRef) async {
    return Image.asset(_testStorage[imageRef] ?? _placeholderImagePath).image;
  }

  @override
  Future<String?> getDownloadURL(String url) async {
    return _placeholderImagePath;
  }

  @override
  Future<String?> createRecord(
    String collectionPath,
    Map<String, dynamic> recordMap,
  ) async {
    final collection = collectionPath.split('/').fold<Map?>(
          _testDb,
          (previousValue, element) =>
              previousValue is Map ? previousValue[element] : null,
        );

    final recordId = (collection?.length ?? 0) + 1;
    final documentId = 'id_$recordId';
    unawaited(
      Future.value(
        collection?.putIfAbsent(
          documentId,
          () => recordMap,
        ),
      ),
    );
    _updateListener?.add(collectionPath);

    return documentId;
  }

  @override
  Future<void> removeRecordsByPath(
    String collectionPath,
    List<String> documentsIds,
  ) async {
    final collection = collectionPath.split('/').fold<Map?>(
          _testDb,
          (previousValue, element) =>
              previousValue is Map ? previousValue[element] : null,
        );
    if (collection == null) {
      _log.warning('>> Method removeRecordsById << '
          'Your collection <$collectionPath> is empty or do not exist');

      return;
    }
    for (final documentId in documentsIds) {
      unawaited(Future.value(collection.remove(documentId)));
    }
    _updateListener?.add(collectionPath);
  }

  @override
  Future<void> removeRecordByValue(
    String collectionPath,
    List<DocumentQuery> docQueries,
  ) async {
    final Set<String> keysToRemove = {};
    int counter = 0;
    final collection = collectionPath.split('/').fold<Map?>(
          _testDb,
          (previousValue, element) =>
              previousValue is Map ? previousValue[element] : null,
        );
    if (collection == null) {
      _log.warning(
        '>> Method removeRecordByValue << '
        'Your collection <$collectionPath> is empty or do not exist',
      );

      return;
    }
    collection.forEach((key, map) {
      map as Map;
      counter = _applyDocumentQueries(docQueries, map, counter);
      // If counter count matches the length of docQueries then
      // there is a match.
      if (counter == docQueries.length) {
        unawaited(Future.value(keysToRemove.add(key)));
      }

      // Reset counter for next key match.
      counter = 0;
    });

    for (var keys in keysToRemove) {
      unawaited(Future.value(collection.remove(keys)));
    }
    _updateListener?.add(collectionPath);
  }

  int _applyDocumentQueries(
    List<DocumentQuery> docQueries,
    Map<dynamic, dynamic> map,
    int counter,
  ) {
    for (var docQuery in docQueries) {
      switch (docQuery.condition) {
        case DocumentFieldCondition.isEqualTo:
          if (map[docQuery.key] == docQuery.value) {
            counter++;
          }
          break;
        case DocumentFieldCondition.isGreaterThan:
          {
            if (map[docQuery.key] > docQuery.value) {
              counter++;
            }
          }
          break;
        case DocumentFieldCondition.isGreaterThanOrEqualTo:
          {
            if (map[docQuery.key] >= docQuery.value) {
              counter++;
            }
          }
          break;
        case DocumentFieldCondition.isLessThan:
          {
            if (map[docQuery.key] < docQuery.value) {
              counter++;
            }
          }
          break;
        case DocumentFieldCondition.isLessThanOrEqualTo:
          {
            if (map[docQuery.key] <= docQuery.value) {
              counter++;
            }
          }
          break;
        case DocumentFieldCondition.isNotEqualTo:
          {
            if (map[docQuery.key] != docQuery.value) {
              counter++;
            }
          }
          break;
        case DocumentFieldCondition.whereIn:
          {
            if ((docQuery.value as List<dynamic>).contains(map[docQuery.key])) {
              counter++;
            }
          }
          break;
        default:
          _log.warning(
            'Document field condition failed (removeRecordByValue).',
          );
          break;
      }
    }

    return counter;
  }

  @override
  Stream<Map<String, Map>?> watchCollection(
    String collectionPath, {
    List<DocumentQuery> filters = const [],
    DocumentOrderBy? orderBy,
    int? limit,
  }) async* {
    yield await getCollection(
      collectionPath,
      filters: filters,
      orderBy: orderBy,
      limit: limit,
    );
    _updateListener ??= StreamController<String>.broadcast(
      onCancel: () {
        final updateListener = _updateListener;
        if (updateListener != null) {
          unawaited(updateListener.close());
          _updateListener = null;
        }
      },
    );
    final updateListener = _updateListener;
    if (updateListener != null) {
      await for (final String path in updateListener.stream) {
        if (path == collectionPath) {
          yield await getCollection(
            collectionPath,
            orderBy: orderBy,
            limit: limit,
          );
        }
      }
    } else {
      yield null;
    }
  }

  @override
  Future<Map<String, Map<dynamic, dynamic>>?> getCollection(
    String collectionPath, {
    List<DocumentQuery> filters = const [],
    DocumentOrderBy? orderBy,
    int? limit,
  }) async {
    final Map<dynamic, dynamic>? originalCol =
        collectionPath.split('/').fold<Map?>(
              _testDb,
              (previousValue, element) =>
                  previousValue is Map ? previousValue[element] : null,
            );

    // Create a deep clone of the retrieved data.
    final Map<dynamic, dynamic>? col =
        originalCol == null ? null : jsonDecode(jsonEncode(originalCol));

    final SplayTreeMap<String, Map<dynamic, dynamic>> mapOfDocuments =
        SplayTreeMap((k1, k2) {
      if (orderBy == null) {
        return k1.compareTo(k2);
      }

      final orderFlip = orderBy.descending ? -1 : 1;

      return col?[k1][orderBy.field]?.compareTo(col[k2]?[orderBy.field]) *
          orderFlip;
    });

    col?.forEach((k, val) {
      final Map map = val;
      for (var docQuery in filters) {
        final DocumentFieldCondition condition = docQuery.condition;
        if ((condition == DocumentFieldCondition.isEqualTo &&
                map[docQuery.key] != docQuery.value) ||
            (condition == DocumentFieldCondition.isGreaterThan &&
                map[docQuery.key] <= docQuery.value) ||
            (condition == DocumentFieldCondition.isGreaterThanOrEqualTo &&
                map[docQuery.key] < docQuery.value) ||
            (condition == DocumentFieldCondition.isLessThan &&
                map[docQuery.key] >= docQuery.value) ||
            (condition == DocumentFieldCondition.isLessThanOrEqualTo &&
                map[docQuery.key] > docQuery.value) ||
            (condition == DocumentFieldCondition.isNotEqualTo &&
                map[docQuery.key] == docQuery.value) ||
            (condition == DocumentFieldCondition.whereIn &&
                !(docQuery.value as List<dynamic>)
                    .contains(map[docQuery.key]))) {
          return;
        }
      }
      if (limit != null && limit >= 0) {
        if (mapOfDocuments.length < limit) {
          mapOfDocuments[k] = val;
        } else {
          return;
        }
      } else {
        mapOfDocuments[k] = val;
      }
    });

    return mapOfDocuments;
  }

  @override
  Future<Map<dynamic, dynamic>?> getRecordByDocumentPath(String path) async {
    final pathSegments = path.split('/')
      ..removeWhere((element) => element.isEmpty);
    const minimumValidPathSegmentLength = 2;
    if (pathSegments.length < minimumValidPathSegmentLength ||
        pathSegments.length % minimumValidPathSegmentLength != 0) {
      _log.warning(' Invalid path `$path`');

      return null;
    }
    final Map<dynamic, dynamic>? document = pathSegments.fold<Map?>(
      _testDb,
      (previousValue, element) =>
          previousValue is Map ? previousValue[element] : null,
    );

    // Create a deep clone of the retrieved data.
    return jsonDecode(jsonEncode(document)) as Map<dynamic, dynamic>?;
  }

  @override
  Future<bool> setRecord({
    required String documentPath,
    required Map<String, dynamic> recordMap,
    bool merge = true,
  }) async {
    final pathSegments = documentPath.split('/')
      ..removeWhere((element) => element.isEmpty);
    const minimumValidPathSegmentLength = 2;
    if (pathSegments.length < minimumValidPathSegmentLength ||
        pathSegments.length % minimumValidPathSegmentLength != 0) {
      _log.severe(
        'Invalid path to record `$documentPath`',
        null,
        StackTrace.current,
      );

      return false;
    }
    final Map<dynamic, dynamic> documentRef =
        pathSegments.fold<Map>(_testDb, (previousValue, element) {
      return previousValue[element] ??= {};
    });
    documentRef.addAll(_deepmerge(target: documentRef, source: recordMap));
    _updateListener?.add(documentPath);
    unawaited(Future.sync(pathSegments.removeLast));
    _updateListener?.add(pathSegments.join('/'));

    return true;
  }

  @override
  Future<bool> setFile(Uint8List fileData, String recordPath) async {
    _testStorage[recordPath] = XFile.fromData(fileData).path;

    return true;
  }

  dynamic _deepmerge({required dynamic target, required dynamic source}) {
    if (target is Map && source is Map) {
      final result = <String, dynamic>{...source};
      for (final key in target.keys) {
        result[key] = _deepmerge(target: target[key], source: result[key]);
      }
      return result;
    } else {
      return source ?? target;
    }
  }

  void _recursivelyFindCollection(
    Map<String, dynamic> currentMap,
    String parentPath,
    String collectionID,
    void Function(String key, Map value) applyFilter,
  ) {
    final pathLength = parentPath.split('/')
      ..removeWhere((element) => element.isEmpty);
    for (final key in currentMap.keys) {
      final value = currentMap[key];
      if (value is Map) {
        if (pathLength.length.isEven && key == collectionID) {
          value.forEach((childKey, childValue) {
            applyFilter('$parentPath/$key/$childKey', childValue);
          });
          break;
        }
        _recursivelyFindCollection(
          Map<String, dynamic>.from(value),
          '$parentPath/$key',
          collectionID,
          applyFilter,
        );
      }
    }
  }

  @override
  Future<Map<String, Map>?> getCollectionGroup(
    String collectionID, {
    List<DocumentQuery> filters = const [],
    int? limit,
    DocumentOrderBy? orderBy,
  }) async {
    final Map<String, Map<dynamic, dynamic>> originalDocs =
        <String, Map<dynamic, dynamic>>{};

    void applyFilter(String key, Map value) {
      for (var docQuery in filters) {
        final DocumentFieldCondition condition = docQuery.condition;
        if ((condition == DocumentFieldCondition.isEqualTo &&
                value[docQuery.key] != docQuery.value) ||
            (condition == DocumentFieldCondition.isGreaterThan &&
                value[docQuery.key] <= docQuery.value) ||
            (condition == DocumentFieldCondition.isGreaterThanOrEqualTo &&
                value[docQuery.key] < docQuery.value) ||
            (condition == DocumentFieldCondition.isLessThan &&
                value[docQuery.key] >= docQuery.value) ||
            (condition == DocumentFieldCondition.isLessThanOrEqualTo &&
                value[docQuery.key] > docQuery.value) ||
            (condition == DocumentFieldCondition.isNotEqualTo &&
                value[docQuery.key] == docQuery.value) ||
            (condition == DocumentFieldCondition.whereIn &&
                !(docQuery.value as List<dynamic>)
                    .contains(value[docQuery.key]))) {
          return;
        }
      }
      if (limit != null && limit > 0) {
        if (originalDocs.length < limit) {
          originalDocs[key] = value;
        } else {
          return;
        }
      } else {
        originalDocs[key] = value;
      }
    }

    _recursivelyFindCollection(
      Map<String, dynamic>.from(_testDb),
      '',
      collectionID,
      applyFilter,
    );

    // Create a deep clone of the retrieved data.
    final Map<String, Map<dynamic, dynamic>> docs =
        Map<String, Map<dynamic, dynamic>>.from(
      jsonDecode(jsonEncode(originalDocs)),
    );

    return SplayTreeMap.from(docs, (k1, k2) {
      if (orderBy == null) {
        return k1.compareTo(k2);
      }
      final orderFlip = orderBy.descending ? -1 : 1;

      final fieldValue1 = docs[k1]?[orderBy.field];
      final fieldValue2 = docs[k2]?[orderBy.field];
      if (fieldValue1 == fieldValue2) {
        return 0;
      }
      if (fieldValue1 == null) {
        return -1 * orderFlip;
      }
      if (fieldValue2 == null) {
        return 1 * orderFlip;
      }

      return fieldValue1.compareTo(fieldValue2) * orderFlip;
    });
  }

  @override
  Stream<Map<String, Map>?> watchCollectionGroup(
    String collectionID, {
    List<DocumentQuery> filters = const [],
    int? limit,
    DocumentOrderBy? orderBy,
  }) async* {
    yield await getCollectionGroup(
      collectionID,
      filters: filters,
      limit: limit,
      orderBy: orderBy,
    );
    _updateListener ??= StreamController<String>.broadcast(
      onCancel: () {
        final updateListener = _updateListener;
        if (updateListener != null) {
          unawaited(updateListener.close());
          _updateListener = null;
        }
      },
    );
    final updateListener = _updateListener;
    if (updateListener != null) {
      await for (final String path in updateListener.stream) {
        if (path == collectionID) {
          yield await getCollectionGroup(
            collectionID,
            filters: filters,
            limit: limit,
            orderBy: orderBy,
          );
        }
      }
    } else {
      yield null;
    }
  }

  @override
  Stream<Map<dynamic, dynamic>?> watchRecordByDocumentPath(String path) async* {
    yield await getRecordByDocumentPath(path);
    _updateListener ??= StreamController<String>.broadcast(
      onCancel: () {
        final updateListener = _updateListener;
        if (updateListener != null) {
          unawaited(updateListener.close());
          _updateListener = null;
        }
      },
    );
    final updateListener = _updateListener;
    if (updateListener != null) {
      yield await getRecordByDocumentPath(
        path,
      );
    } else {
      yield null;
    }
  }
}
