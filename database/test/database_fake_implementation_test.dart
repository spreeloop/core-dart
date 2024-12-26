import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:spreeloop_database/database.dart';

void main() {
  unawaited(_retrieveRecordTestGroup());
  unawaited(_setRecordTestGroup());
}

Future<void> _retrieveRecordTestGroup() async {
  group('Retrieving record: ', () {
    test('Retrieve restaurant that cuisine type contain Italian', () async {
      final dbInstance = Database(DatabaseType.fake);

      final retrievedList = await dbInstance.getCollection(
        'restaurants',
        filters: [
          DocumentQuery(
            'cuisineType',
            'Italian',
            DocumentFieldCondition.arrayContains,
          ),
        ],
      );
      expect(retrievedList?.length, 4);
    });
    test('Retrieve restaurant that match list of rating', () async {
      final dbInstance = Database(DatabaseType.fake);

      final retrievedList = await dbInstance.getCollection(
        'restaurants',
        filters: [
          DocumentQuery(
            'rating',
            [4.5, 3.8],
            DocumentFieldCondition.whereIn,
          ),
        ],
      );
      expect(retrievedList?.length, 2);
    });
    test('Retrieve record by id', () async {
      final dbInstance = Database(DatabaseType.fake);
      final retrievedRestaurantName =
          await dbInstance.getRecordByDocumentPath('restaurants/restaurants_1');
      expect('The Pot Luck Club', retrievedRestaurantName?['brandName']);
    });

    test('Get all menu items on data base', () async {
      final dbInstance = Database(DatabaseType.fake);
      final collectionItems = await dbInstance.getCollectionGroup('menuItems');
      const inspectedCollectionItemsLength = 18;
      expect(collectionItems?.length, inspectedCollectionItemsLength);

      final collectionItems2 =
          await dbInstance.getCollectionGroup('menuItems', limit: 3);
      const inspectedCollectionItems2Length = 3;
      expect(collectionItems2?.length, inspectedCollectionItems2Length);
    });

    unawaited(_testRetrieveRecordByValue());
    unawaited(_testImageGetAndSet());
    unawaited(_testGetMultipleElementInCollection());
    unawaited(_testGetMultipleElementInSubCollection());
    unawaited(_removeItemsOnCollection());
    unawaited(_removeItemsOnSubCollection());
  });
}

Future<void> _removeItemsOnSubCollection() async {
  test('Remove elements of sub collection', () async {
    final dbInstance = Database(DatabaseType.fake);
    final Map<String, dynamic> restaurant = {
      'name': 'koundilla',
      'rating': 3.8,
      'menuItems': {},
    };
    final Map<String, dynamic> menu1 = {
      'foodName': 'Fufu and Eru',
      'foodType': 'Camerounian',
      'price': 65,
    };
    final Map<String, dynamic> menu2 = {
      'foodName': 'Achu or Taro',
      'foodType': 'Cameroonian',
      'price': 50,
    };
    final restaurantCreated =
        (await dbInstance.createRecord('restaurants', restaurant)) != null;
    expect(restaurantCreated, true);

    final countRestaurants =
        (await dbInstance.getCollection('restaurants'))?.length;
    final menuItemCollectionPath = 'restaurants/id_$countRestaurants/menuItems';
    final menuItemCreated1 =
        (await dbInstance.createRecord(menuItemCollectionPath, menu1)) != null;
    final menuItemCreated2 =
        (await dbInstance.createRecord(menuItemCollectionPath, menu2)) != null;
    expect(menuItemCreated1 && menuItemCreated2, true);

    final countMenuItemsBeforeRemoval =
        (await dbInstance.getCollection(menuItemCollectionPath))?.length ?? 0;

    final listOfIdOfDocumentToRemove = [
      'id_$countMenuItemsBeforeRemoval',
      'id_${countMenuItemsBeforeRemoval - 1}',
    ];
    await dbInstance.removeRecordsByPath(
      menuItemCollectionPath,
      listOfIdOfDocumentToRemove,
    );

    final countMenuItemsAfterRemoval =
        (await dbInstance.getCollection(menuItemCollectionPath))?.length ?? 0;
    expect(
      countMenuItemsAfterRemoval,
      countMenuItemsBeforeRemoval - listOfIdOfDocumentToRemove.length,
    );
  });
}

Future<void> _removeItemsOnCollection() async {
  test('Remove elements of collection', () async {
    final dbInstance = Database(DatabaseType.fake);
    final Map<String, dynamic> record = {
      'userPath': 'test id',
      'userName': 'test user',
      'userEmail': 'test@spreeloop.com',
      'userPhoneNumber': '+237696292947',
      'photoUrl': '',
    };

    final recordCreated =
        (await dbInstance.createRecord('users', record)) != null;
    expect(recordCreated, true);
    final collectionItemsBeforeRemoval =
        await dbInstance.getCollection('users');

    await dbInstance.removeRecordsByPath(
      'users',
      ['id_${collectionItemsBeforeRemoval?.length}'],
    );

    final collectionItems = await dbInstance.getCollection('users');
    expect(
      collectionItems?.length,
      (collectionItemsBeforeRemoval?.length ?? 0) - 1,
    );
  });
  unawaited(_removeItemsOnCollectionWithCondition1());
  unawaited(_removeItemsOnCollectionWithCondition2());
  unawaited(_removeItemsOnCollectionWithCondition3());
}

Future<void> _removeItemsOnCollectionWithCondition1() async {
  test('Remove elements of collection if values does not match', () async {
    final dbInstance = Database(DatabaseType.fake);
    final String key1 = 'userPath';
    final dynamic value1 = 'users/users_1';
    final String key2 = 'itemPath';
    final dynamic value2 = 'restaurants/restaurants_1/menuItems/menuItems_1';
    final DocumentFieldCondition spec1 = DocumentFieldCondition.isEqualTo;
    final DocumentFieldCondition spec2 = DocumentFieldCondition.isEqualTo;

    final List<DocumentQuery> fieldsToQuery = [
      DocumentQuery(key1, value1, spec1),
      DocumentQuery(key2, value2, spec2),
    ];

    final collectionItemsBeforeRemoval =
        await dbInstance.getCollection('favorites');

    await dbInstance.removeRecordByValue('favorites', fieldsToQuery);

    final collectionItems = await dbInstance.getCollection('favorites');
    expect(
      collectionItems?.length,
      (collectionItemsBeforeRemoval?.length ?? 0) - 1,
    );
  });
}

Future<void> _removeItemsOnCollectionWithCondition2() async {
  test('Remove elements of collection if values match', () async {
    final dbInstance = Database(DatabaseType.fake);
    final String key1 = 'userPath';
    final dynamic value1 = 'users/users_2';
    final DocumentFieldCondition spec1 = DocumentFieldCondition.isEqualTo;

    final List<DocumentQuery> fieldsToQuery = [
      DocumentQuery(key1, value1, spec1),
    ];

    final Map<String, dynamic> record1 = {
      'userPath': 'users/users_2',
    };

    final recordCreated =
        (await dbInstance.createRecord('favorites', record1)) != null;
    expect(recordCreated, true);

    final collectionItemsCountBeforeRemoval =
        (await dbInstance.getCollection('favorites'))?.length ?? 0;
    print("favorites: (${await dbInstance.getCollection('favorites')})");
    await dbInstance.removeRecordByValue('favorites', fieldsToQuery);

    final collectionItems = await dbInstance.getCollection('favorites');
    expect(collectionItems?.length, collectionItemsCountBeforeRemoval - 1);
  });
}

Future<void> _removeItemsOnCollectionWithCondition3() async {
  test('Remove elements of collection if values is greater than', () async {
    final dbInstance = Database(DatabaseType.fake);
    final String key1 = 'rating';
    final dynamic value1 = 4.0;
    final DocumentFieldCondition spec1 = DocumentFieldCondition.isGreaterThan;

    final List<DocumentQuery> fieldsToQuery = [
      DocumentQuery(key1, value1, spec1),
    ];

    final collectionItemsBeforeRemoval =
        await dbInstance.getCollection('restaurants');

    await dbInstance.removeRecordByValue('restaurants', fieldsToQuery);

    final collectionItems = await dbInstance.getCollection('restaurants');
    expect(
      collectionItems?.length,
      (collectionItemsBeforeRemoval?.length ?? 0) - 1,
    );
  });
}

Future<void> _testGetMultipleElementInSubCollection() async {
  test('Get all ellements of a sub Collection', () async {
    final dbInstance = Database(DatabaseType.fake);
    final collectionItems =
        await dbInstance.getCollection('restaurants/restaurants_1/menuItems');

    const inspectedCollectionItemsLength = 3;
    expect(collectionItems?.length, inspectedCollectionItemsLength);
    expect(collectionItems?['menuItems_2']?['foodName'], 'Legumes Saute');
  });

  test(
    'Get all menu items on data base where priceInXAF is greater than 1000',
    () async {
      final dbInstance = Database(DatabaseType.fake);
      final collectionItems = await dbInstance.getCollectionGroup(
        'menuItems',
        filters: [
          DocumentQuery(
            'priceInXAF',
            1000,
            DocumentFieldCondition.isGreaterThan,
          ),
        ],
      );
      const inspectedCollectionItemsLength = 4;
      expect(collectionItems?.length, inspectedCollectionItemsLength);
    },
  );

  test('Get all ellements of a sub Collection with limit', () async {
    final dbInstance = Database(DatabaseType.fake);
    final collectionItems = await dbInstance
        .getCollection('restaurants/restaurants_1/menuItems', limit: 1);

    expect(collectionItems?.length, 1);
  });
}

Future<void> _testGetMultipleElementInCollection() async {
  test('Get all elements of a collection', () async {
    final dbInstance = Database(DatabaseType.fake);
    final collectionItems = await dbInstance.getCollection('restaurants');

    const inspectedCollectionItemsLength = 6;
    expect(collectionItems?.length, inspectedCollectionItemsLength);
    expect(
      collectionItems?['restaurants_1']?['brandName'],
      'The Pot Luck Club',
    );
    expect(collectionItems?['restaurants_2']?['brandName'], 'Italian Dream');
  });

  test('Get all elements of a collection with limit', () async {
    final dbInstance = Database(DatabaseType.fake);
    final collectionItems =
        await dbInstance.getCollection('restaurants', limit: 3);

    const inspectedCollectionItemsLength = 3;
    expect(collectionItems?.length, inspectedCollectionItemsLength);
  });
  unawaited(_testGetMultipleElementInCollectionWithCondition());
  unawaited(_testGetMultipleElementInCollectionWithCondition0());
  unawaited(_testGetMultipleElementInCollectionWithCondition1());
  unawaited(_testGetMultipleElementInCollectionWithCondition2());
  unawaited(_testGetMultipleElementInCollectionWithCondition3());
  unawaited(_testGetMultipleElementInCollectionWithCondition4());
}

Future<void> _testGetMultipleElementInCollectionWithCondition() async {
  test('Get elements with conditions `greaterThan`.', () async {
    final dbInstance = Database(DatabaseType.fake);
    final collectionItems = await dbInstance.getCollection(
      'restaurants',
      filters: [
        DocumentQuery('rating', 3.8, DocumentFieldCondition.isGreaterThan),
      ],
    );
    expect(collectionItems?.length, 1);
    expect(
      collectionItems?['restaurants_1']?['brandName'],
      'The Pot Luck Club',
    );
  });
}

Future<void> _testGetMultipleElementInCollectionWithCondition0() async {
  test('Get elements with conditions `isGreaterThanOrEqualTo`.', () async {
    final dbInstance = Database(DatabaseType.fake);
    final collectionItems = await dbInstance.getCollection(
      'restaurants',
      filters: [
        DocumentQuery(
          'rating',
          3.8,
          DocumentFieldCondition.isGreaterThanOrEqualTo,
        ),
      ],
    );
    const inspectedCollectionItemsLength = 2;
    expect(collectionItems?.length, inspectedCollectionItemsLength);

    expect(
      collectionItems?['restaurants_1']?['brandName'],
      'The Pot Luck Club',
    );
  });
}

Future<void> _testGetMultipleElementInCollectionWithCondition1() async {
  test('Get elements with conditions `isLessThan`.', () async {
    final dbInstance = Database(DatabaseType.fake);
    final collectionItems = await dbInstance.getCollection(
      'restaurants',
      filters: [
        DocumentQuery(
          'rating',
          3.8,
          DocumentFieldCondition.isLessThan,
        ),
      ],
    );
    const inspectedCollectionItemsLength = 4;
    expect(collectionItems?.length, inspectedCollectionItemsLength);
  });
}

Future<void> _testGetMultipleElementInCollectionWithCondition2() async {
  test('Get elements with conditions `isLessThanOrEqualTo`.', () async {
    final dbInstance = Database(DatabaseType.fake);
    final collectionItems = await dbInstance.getCollection(
      'restaurants',
      filters: [
        DocumentQuery(
          'rating',
          3.8,
          DocumentFieldCondition.isLessThanOrEqualTo,
        ),
      ],
    );
    const inspectedCollectionItemsLength = 5;
    expect(collectionItems?.length, inspectedCollectionItemsLength);
    expect(collectionItems?['restaurants_2']?['brandName'], 'Italian Dream');
  });
}

Future<void> _testGetMultipleElementInCollectionWithCondition3() async {
  test('Get elements with conditions `isEqualTo`.', () async {
    final dbInstance = Database(DatabaseType.fake);
    final collectionItems = await dbInstance.getCollection(
      'restaurants',
      filters: [
        DocumentQuery(
          'brandName',
          'Italian Dream',
          DocumentFieldCondition.isEqualTo,
        ),
      ],
    );
    expect(collectionItems?.length, 1);
    expect(collectionItems?['restaurants_2']?['brandName'], 'Italian Dream');
  });
}

Future<void> _testGetMultipleElementInCollectionWithCondition4() async {
  test('Get elements with conditions `isNotEqualTo`.', () async {
    final dbInstance = Database(DatabaseType.fake);
    final collectionItems = await dbInstance.getCollection(
      'restaurants',
      filters: [
        DocumentQuery(
          'brandName',
          'Italian Dream',
          DocumentFieldCondition.isNotEqualTo,
        ),
      ],
    );
    const inspectedCollectionItemsLength = 5;
    expect(collectionItems?.length, inspectedCollectionItemsLength);

    expect(
      collectionItems?['restaurants_1']?['brandName'],
      'The Pot Luck Club',
    );
  });
}

Future<void> _testImageGetAndSet() async {
  test('get an image from db', () async {
    final dbInstance = Database(DatabaseType.fake);
    final image = await dbInstance.getImage('imageRef1');
    expect(image, isNotNull);
  });

  test('set an image from db', () async {
    final dbInstance = Database(DatabaseType.fake);
    final image = await dbInstance.setFile(Uint8List.fromList([]), 'imageRef2');
    expect(image, true);
  });
}

Future<void> _testRetrieveRecordByValue() async {
  test('Retrieve existing record by value, with a correct value', () async {
    final dbInstance = Database(DatabaseType.fake);
    final Map<String, dynamic> record = {
      'userPath': 'test id',
      'userName': 'test user',
      'userEmail': 'test@spreeloop.com',
      'userPhoneNumber': '+237696292947',
      'photoUrl': '',
    };
    final recordCreated =
        (await dbInstance.createRecord('users', record) != null);

    final retrievedList = await dbInstance.getCollection(
      'users',
      filters: [
        DocumentQuery(
          'userPhoneNumber',
          '+237696292947',
          DocumentFieldCondition.isEqualTo,
        ),
      ],
    );
    expect(recordCreated, true);
    const expectedListLength = 2;
    expect(retrievedList?.length, expectedListLength);
  });

  test(
    'Retrieve existing record by value, with an incorrect value',
    () async {
      final dbInstance = Database(DatabaseType.fake);
      final Map<String, dynamic> record = {
        'userPath': 'test id',
        'userName': 'test user',
        'userEmail': 'test@spreeloop.com',
        'userPhoneNumber': '+237696292947',
        'photoUrl': '',
      };
      final recordCreated =
          (await dbInstance.createRecord('users', record) != null);

      final retrievedList = await dbInstance.getCollection(
        'users',
        filters: [
          DocumentQuery(
            'userPhoneNumber',
            'someIncorrectNumber',
            DocumentFieldCondition.isEqualTo,
          ),
        ],
      );
      expect(recordCreated, true);
      expect(retrievedList?.length, 0);
    },
  );
  unawaited(_testNonRetrieveRecordByValue());
}

Future<void> _testNonRetrieveRecordByValue() async {
  test('Retrieve non existing record by value', () async {
    final dbInstance = Database(DatabaseType.fake);

    final retrievedList = await dbInstance.getCollection(
      'users',
      filters: [
        DocumentQuery(
          'userPhoneNumber',
          '237696292947',
          DocumentFieldCondition.isEqualTo,
        ),
      ],
    );
    expect(retrievedList?.length, 0);
  });
}

Future<void> _setRecordTestGroup() async {
  group('Set Record', () {
    final documentPath = '/temp/01';
    final document = {
      'key_1': 1,
      'key_2': 'value_2',
      'key_3': 'value_33',
      'key_4': 'value_4',
      'key_5': 'value_55',
    };
    final dbInstance = Database(DatabaseType.fake);
    test('Set record of non existing document', () async {
      final documentNotExist =
          (await dbInstance.getRecordByDocumentPath(documentPath)) == null;
      expect(documentNotExist, true);
      final setStatus = await dbInstance.setRecord(
        documentPath: documentPath,
        recordMap: document,
      );
      expect(setStatus, true);
      final doc = await dbInstance.getRecordByDocumentPath(documentPath);
      final isEqual =
          doc?.keys.every((element) => document[element] == doc[element]);
      expect(isEqual, true);
    });
    test('Set record of existing document', () async {
      final documentExist =
          (await dbInstance.getRecordByDocumentPath(documentPath)) != null;
      expect(documentExist, true);
      final newDocument = {'key_2': 2, 'key': 'X'};
      final setStatus = await dbInstance.setRecord(
        documentPath: documentPath,
        recordMap: newDocument,
      );
      expect(setStatus, true);
      final doc = await dbInstance.getRecordByDocumentPath(documentPath);
      final isEqual =
          doc?.keys.every((element) => document[element] == doc[element]);
      expect(isEqual, false);
      expect(doc?.length, document.length + 1);
    });
  });
}
