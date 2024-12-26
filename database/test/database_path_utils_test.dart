import 'package:flutter_test/flutter_test.dart';
import 'package:spreeloop_database/spreeloop_database.dart';

void main() {
  group('DatabasePathUtils', () {
    test('getDocumentId returns the ID of the document', () {
      expect(
        DatabasePathUtils.getDocumentId('collectionName/resource-id'),
        'resource-id',
      );
      expect(
        DatabasePathUtils.getDocumentId('collectionName/resource-id/'),
        '',
      );
      expect(
        DatabasePathUtils.getDocumentId('collectionName'),
        'collectionName',
      );
      expect(DatabasePathUtils.getDocumentId(''), '');
    });

    test('getDatabasePath returns the path of the document', () {
      expect(
        DatabasePathUtils.getDatabasePath('collectionName', 'resource-id'),
        'collectionName/resource-id',
      );
      expect(
        DatabasePathUtils.getDatabasePath('', 'resource-id'),
        '/resource-id',
      );
      expect(
        DatabasePathUtils.getDatabasePath('collectionName', ''),
        'collectionName/',
      );
    });
    test('returns true for valid collection path', () {
      expect(
        DatabasePathUtils.isValidCollectionPath(
          'restaurant/restaurant_1/menuItem',
        ),
        isTrue,
      );
    });

    test('returns false for invalid collection path', () {
      expect(
        DatabasePathUtils.isValidCollectionPath('restaurant/restaurant_1'),
        isFalse,
      );
      expect(DatabasePathUtils.isValidCollectionPath('/'), isFalse);
      expect(DatabasePathUtils.isValidCollectionPath(''), isFalse);
    });

    test('returns parent collection path for valid path', () {
      expect(
        DatabasePathUtils.getParentCollectionPath(
          'restaurant/restaurant_1/menuItem',
        ),
        'restaurant',
      );
    });

    test('returns undefined for invalid path', () {
      expect(DatabasePathUtils.getParentCollectionPath('/'), isNull);
      expect(DatabasePathUtils.getParentCollectionPath(''), isNull);
    });

    test('returns parent document path for valid path', () {
      expect(
        DatabasePathUtils.getParentDocumentPath(
          'restaurant/restaurant_1/menuItem',
        ),
        'restaurant/restaurant_1',
      );
    });

    test('returns undefined for invalid path', () {
      expect(
        DatabasePathUtils.getParentDocumentPath('restaurant/restaurant_1'),
        isNull,
      );
      expect(DatabasePathUtils.getParentDocumentPath('/'), isNull);
      expect(DatabasePathUtils.getParentDocumentPath(''), isNull);
    });
  });
}
