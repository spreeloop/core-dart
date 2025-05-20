import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'src/database_document_filter.dart';
import 'src/database_document_order_by.dart';
import 'src/database_fake_implementation.dart';
import 'src/database_firestore_implementation.dart';

export 'src/database_document_filter.dart';
export 'src/database_document_order_by.dart';
export 'src/database_path_utils.dart';

/// Service that provides Database implementations to apps.
abstract class Database {
  factory Database.firestore({CacheManager? cacheManager}) {
    return DatabaseFirestoreImplementation(cacheManager);
  }
  factory Database.fake(Map<dynamic, Map<dynamic, dynamic>> database) {
    return DatabaseFakeImplementation(database);
  }

  /// Returns an image from the database using the image reference from
  /// storage.
  Future<ImageProvider?> getImage(String imageRef);

  /// Returns an download url from the database using the path file reference from
  /// storage.
  Future<String?> getDownloadURL(String url);

  /// Sets a file to the database using the record path from
  /// storage and file.
  Future<bool> setFile(Uint8List fileData, String recordPath);

  /// Deletes a file from the database using the record path from storage.
  /// Returns true if the file was successfully deleted, false otherwise.
  Future<bool> deleteFile(String recordPath);

  /// Creates a record as map for database inputs and returns the generated
  /// document id.
  /// * [collectionPath] The path to the collection.
  ///   e.g - "restaurants"
  ///       - "restaurants/{restaurantId}/menuItems"
  Future<String?> createRecord(
    String collectionPath,
    Map<String, dynamic> recordMap,
  );

  /// Set a data to the given [documentPath].
  /// If the document does not exit at the given [documentPath], data will be
  /// created. Otherwise, the document will be replaces by the given
  /// [recordMap].
  /// * [documentPath] The path to the document.
  ///   e.g - "restaurants/{restaurantId}"
  /// * [recordMap] The data that will set to the document.
  /// * [merge] Using when we went to merge (merge = true) or
  /// overwrite (merge = false) the data.
  /// by default the data is merged into the existing document.
  Future<bool> setRecord({
    required String documentPath,
    required Map<String, dynamic> recordMap,
    bool merge = true,
  });

  /// Removes all documents of [collectionPath] collection
  /// who have id in [documentsIds] list.
  /// * [collectionPath] The path to the collection.
  ///   e.g - "restaurants"
  ///       - "restaurants/{restaurantId}/menuItems"
  Future<void> removeRecordsByPath(
    String collectionPath,
    List<String> documentsIds,
  );

  /// Removes all documents that match the query, from the specified collection.
  /// * [collectionPath] The path to the collection.
  ///   e.g - "restaurants"
  ///       - "restaurants/{restaurantId}/menuItems"
  Future<void> removeRecordByValue(
    String collectionPath,
    List<DocumentQuery> documentQueries,
  );

  /// Returns a map of documents records from the database.
  /// * [collectionPath] The path to the collection.
  ///   e.g - "restaurants"
  ///       - "restaurants/{restaurantId}/menuItems"
  ///       - etc...
  /// * [filters] The filter that will be applied on each record of the
  ///   collection.
  /// * [limit] The maximum number of documents to return. this integer must be
  ///   greater than 0. Otherwise (if limit is not specified or limit is lower
  ///   or equal to 0), all requested data will be returned.
  Future<Map<String, Map<dynamic, dynamic>>?> getCollection(
    String collectionPath, {
    List<DocumentQuery> filters,
    DocumentOrderBy? orderBy,
    int? limit,
  });

  /// Returns a map of documents records from the database.
  /// Each key of the returned map is a path to a document of a collection
  /// with a id [collectionID].
  /// * [collectionID] The id to the collection.
  ///   e.g - "menuItems"
  ///       - "orders"
  ///       - etc...
  /// * [filters] The filter that will be applied on each record of the
  ///   collection.
  /// * [limit] The maximum number of document to return. this integer must be
  ///   greater than 0. Otherwise (if limit is not specified or limit is lower
  ///   or equal to 0), all requested data will be returned.
  Future<Map<String, Map<dynamic, dynamic>>?> getCollectionGroup(
    String collectionID, {
    List<DocumentQuery> filters,
    int? limit,
    DocumentOrderBy? orderBy,
  });

  /// Returns a stream of map of documents records from the database.
  /// Each key of the returned map is a path to a document of a collection
  /// with a id [collectionID].
  /// * [collectionID] The id to the collection.
  ///   e.g - "menuItems"
  ///       - "orders"
  ///       - etc...
  /// * [filters] The filter that will be applied on each record of the
  ///   collection.
  /// * [limit] The maximum number of document to return. this integer must be
  ///   greater than 0. Otherwise (if limit is not specified or limit is lower
  ///   or equal to 0), all requested data will be returned.
  Stream<Map<String, Map<dynamic, dynamic>>?> watchCollectionGroup(
    String collectionID, {
    List<DocumentQuery> filters,
    int? limit,
    DocumentOrderBy? orderBy,
  });

  /// Returns a Stream of map of documents records from the database.
  /// * [collectionPath] The path to the collection.
  ///   e.g - "restaurants"
  ///       - "restaurants/{restaurantId}/menuItems"
  ///       - etc...
  /// * [filters] The filter that will be applied on each record of the
  ///   collection.
  /// * [limit] The maximum number of document to return. this integer must be
  ///   greater than 0. Otherwise (if limit is not specified or limit is lower
  ///   or equal to 0), all requested data will be returned.
  Stream<Map<String, Map<dynamic, dynamic>>?> watchCollection(
    String collectionPath, {
    List<DocumentQuery> filters,
    int? limit,
    DocumentOrderBy? orderBy,
  });

  /// Returns a map representation of the documents.
  /// * [path] is the full path of the record.
  ///   e.g - "restaurants/{restaurantId}"
  ///       - "restaurants/{restaurantId}/menuItems/{menuId}"
  ///       - etc...
  Future<Map<dynamic, dynamic>?> getRecordByDocumentPath(String path);

  /// Returns a Stream of map of documents.
  /// * [path] is the full path of the record.
  ///   e.g - "restaurants/{restaurantId}"
  ///       - "restaurants/{restaurantId}/menuItems/{menuId}"
  ///       - etc...
  Stream<Map<dynamic, dynamic>?> watchRecordByDocumentPath(String path);
}
