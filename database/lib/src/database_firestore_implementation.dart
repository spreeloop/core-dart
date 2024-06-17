import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:logging/logging.dart';

import '../database.dart';

/// [FirebaseHttpFileService] is another common file service which parses a
/// firebase reference into, to standard url which can be passed to the
/// standard [HttpFileService].
class FirebaseHttpFileService extends HttpFileService {
  @override
  Future<FileServiceResponse> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    final ref = FirebaseStorage.instance.ref().child(url);
    final url0 = await ref.getDownloadURL();

    return super.get(url0);
  }
}

/// Use [FirebaseCacheManager] if you want to download files
/// from firebase storage and store them in your local cache.
class FirebaseCacheManager extends CacheManager {
  /// Firebase cache key.
  static const key = 'firebaseCache';

  /// Initialize his root instance.
  static final FirebaseCacheManager _instance = FirebaseCacheManager._();

  /// Constructs a new [FirebaseCacheManager].
  factory FirebaseCacheManager() {
    return _instance;
  }

  /// Connect to the firebase service for improvements.
  FirebaseCacheManager._()
      : super(Config(key, fileService: FirebaseHttpFileService()));
}

/// Database implementation using Firebase Firestore & Storage.
class DatabaseFirestoreImplementation implements Database {
  final FirebaseFirestore _databaseReference = FirebaseFirestore.instance;
  final _log = Logger('DbInterfaceFirestoreImplementation');
  final CacheManager _cacheManager;

  @override
  Future<ImageProvider?> getImage(String imageRef) async {
    if (imageRef.isEmpty) {
      return null;
    }

    try {
      // Caching not supported on Web.
      final imageUrl = kIsWeb
          ? await FirebaseStorage.instance
              .ref()
              .child(imageRef)
              .getDownloadURL()
          : imageRef;

      return CachedNetworkImageProvider(
        imageUrl,
        cacheManager: _cacheManager,
      );
    } on FirebaseException catch (e) {
      _log.severe(e.toString(), e, e.stackTrace);

      return null;
    }
  }

  @override
  Future<String?> createRecord(
    String collectionPath,
    Map<String, dynamic> recordMap,
  ) async {
    try {
      final documentRef =
          await _databaseReference.collection(collectionPath).add(recordMap);

      return documentRef.id;
    } on FirebaseException catch (e) {
      _log.severe(e.toString(), e, e.stackTrace);
    }

    return null;
  }

  @override
  Future<void> removeRecordsByPath(
    String collectionPath,
    List<String> documentsIds,
  ) async {
    if (documentsIds.isEmpty) return;
    try {
      final WriteBatch batch = _databaseReference.batch();
      for (final documentId in documentsIds) {
        final docReference =
            _databaseReference.doc('$collectionPath/$documentId');
        batch.delete(docReference);
      }
      await batch.commit();
      _log.fine('Records removed');
    } on FirebaseException catch (e) {
      _log.severe(e.toString(), e, e.stackTrace);
    }
  }

  @override
  Future<void> removeRecordByValue(
    String collectionPath,
    List<DocumentQuery> documentQueries,
  ) async {
    if (documentQueries.isEmpty) return;
    final WriteBatch batch = _databaseReference.batch();

    try {
      Query query = _databaseReference.collection(collectionPath);

      query = _applyQueries(documentQueries, query);

      final querySnapshot = await query.get();
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } on FirebaseException catch (e) {
      _log.severe(e.toString(), e, e.stackTrace);
    }
  }

  Query<Object?> _applyQueries(
    List<DocumentQuery> documentQueries,
    Query<Object?> query,
  ) {
    for (var docQuery in documentQueries) {
      switch (docQuery.condition) {
        case DocumentFieldCondition.isEqualTo:
          {
            query = query.where(docQuery.key, isEqualTo: docQuery.value);
          }
          break;
        case DocumentFieldCondition.isGreaterThan:
          {
            query = query.where(docQuery.key, isGreaterThan: docQuery.value);
          }
          break;
        case DocumentFieldCondition.isGreaterThanOrEqualTo:
          {
            query = query.where(
              docQuery.key,
              isGreaterThanOrEqualTo: docQuery.value,
            );
          }
          break;
        case DocumentFieldCondition.isLessThan:
          {
            query = query.where(docQuery.key, isLessThan: docQuery.value);
          }
          break;
        case DocumentFieldCondition.isLessThanOrEqualTo:
          {
            query =
                query.where(docQuery.key, isLessThanOrEqualTo: docQuery.value);
          }
          break;
        case DocumentFieldCondition.isNotEqualTo:
          {
            query = query.where(docQuery.key, isNotEqualTo: docQuery.value);
          }
          break;
        case DocumentFieldCondition.whereIn:
          {
            query = query.where(docQuery.key, whereIn: docQuery.value);
          }
          break;
        default:
          _log.severe(
            'Unknown Document field condition ${docQuery.condition}',
            null,
            StackTrace.current,
          );
          break;
      }
    }

    return query;
  }

  @override
  Future<Map<String, Map<dynamic, dynamic>>?> getCollection(
    String collectionPath, {
    List<DocumentQuery> filters = const [],
    DocumentOrderBy? orderBy,
    int? limit,
  }) async {
    try {
      Query query = _databaseReference.collection(collectionPath);
      for (DocumentQuery docQuery in filters) {
        switch (docQuery.condition) {
          case DocumentFieldCondition.isEqualTo:
            query = query.where(docQuery.key, isEqualTo: docQuery.value);
            break;
          case DocumentFieldCondition.isGreaterThan:
            query = query.where(docQuery.key, isGreaterThan: docQuery.value);
            break;
          case DocumentFieldCondition.isGreaterThanOrEqualTo:
            query = query.where(
              docQuery.key,
              isGreaterThanOrEqualTo: docQuery.value,
            );
            break;
          case DocumentFieldCondition.isLessThan:
            query = query.where(docQuery.key, isLessThan: docQuery.value);
            break;
          case DocumentFieldCondition.isLessThanOrEqualTo:
            query =
                query.where(docQuery.key, isLessThanOrEqualTo: docQuery.value);
            break;
          case DocumentFieldCondition.isNotEqualTo:
            query = query.where(docQuery.key, isNotEqualTo: docQuery.value);
            break;
          case DocumentFieldCondition.whereIn:
            query = query.where(docQuery.key, whereIn: docQuery.value);
            break;
        }
      }

      if (limit != null && limit > 0) {
        query = query.limit(limit);
      }

      if (orderBy != null) {
        query = query.orderBy(orderBy.field, descending: orderBy.descending);
        if (orderBy.startAt != null) {
          query = query.startAt([orderBy.startAt]);
        }
        if (orderBy.endAt != null) {
          query = query.endAt([orderBy.endAt]);
        }
      }

      final QuerySnapshot result = await query.get();
      final Map<String, Map<dynamic, dynamic>> list =
          <String, Map<dynamic, dynamic>>{};

      for (int idx = 0; idx < result.docs.length; ++idx) {
        final documentValue = result.docs[idx].data() as Map<String, dynamic>;
        list[result.docs[idx].id] = documentValue;
      }

      return list;
    } on FirebaseException catch (e) {
      _log.severe(e.toString(), e, e.stackTrace);

      return null;
    }
  }

  @override
  Stream<Map<String, Map<dynamic, dynamic>>?> watchCollection(
    String collectionPath, {
    List<DocumentQuery> filters = const [],
    DocumentOrderBy? orderBy,
    int? limit,
  }) async* {
    try {
      Query query = _databaseReference.collection(collectionPath);
      for (DocumentQuery docQuery in filters) {
        switch (docQuery.condition) {
          case DocumentFieldCondition.isEqualTo:
            query = query.where(docQuery.key, isEqualTo: docQuery.value);
            break;
          case DocumentFieldCondition.isGreaterThan:
            query = query.where(docQuery.key, isGreaterThan: docQuery.value);
            break;
          case DocumentFieldCondition.isGreaterThanOrEqualTo:
            query = query.where(
              docQuery.key,
              isGreaterThanOrEqualTo: docQuery.value,
            );
            break;
          case DocumentFieldCondition.isLessThan:
            query = query.where(docQuery.key, isLessThan: docQuery.value);
            break;
          case DocumentFieldCondition.isLessThanOrEqualTo:
            query =
                query.where(docQuery.key, isLessThanOrEqualTo: docQuery.value);
            break;
          case DocumentFieldCondition.isNotEqualTo:
            query = query.where(docQuery.key, isNotEqualTo: docQuery.value);
            break;
          case DocumentFieldCondition.whereIn:
            query = query.where(docQuery.key, whereIn: docQuery.value);
            break;
        }
      }

      if (limit != null && limit > 0) {
        query = query.limit(limit);
      }
      if (orderBy != null) {
        query = query.orderBy(orderBy.field, descending: orderBy.descending);
        if (orderBy.startAt != null) {
          query = query.startAt([orderBy.startAt]);
        }
        if (orderBy.endAt != null) {
          query = query.endAt([orderBy.endAt]);
        }
      }
      final Stream<QuerySnapshot> result = query.snapshots();

      await for (final querySnapshot in result) {
        final Map<String, Map<dynamic, dynamic>> list =
            <String, Map<dynamic, dynamic>>{};

        for (int idx = 0; idx < querySnapshot.docs.length; ++idx) {
          final documentValue =
              querySnapshot.docs[idx].data() as Map<String, dynamic>;
          list[querySnapshot.docs[idx].id] = documentValue;
        }
        yield list;
      }
    } on FirebaseException catch (e) {
      _log.severe(e.toString(), e, e.stackTrace);
      yield null;
    }
  }

  @override
  Future<Map<String, dynamic>?> getRecordByDocumentPath(String path) async {
    try {
      final DocumentSnapshot result = await _databaseReference.doc(path).get();

      return result.data() as Map<String, dynamic>?;
    } on FirebaseException catch (e) {
      _log.severe(e.toString(), e, e.stackTrace);

      return null;
    }
  }

  @override
  Future<bool> setRecord({
    required String documentPath,
    required Map<String, dynamic> recordMap,
    bool merge = true,
  }) async {
    try {
      await _databaseReference
          .doc(documentPath)
          .set(recordMap, SetOptions(merge: merge));

      return true;
    } on FirebaseException catch (e) {
      _log.severe(e.toString(), e, e.stackTrace);

      return false;
    }
  }

  @override
  Future<bool> setFile(Uint8List fileData, String recordPath) async {
    final FirebaseStorage referenceStorage = FirebaseStorage.instance;
    try {
      final uploadTask =
          await referenceStorage.ref(recordPath).putData(fileData);

      return uploadTask.state == TaskState.success;
    } on FirebaseException catch (e) {
      _log.warning(e.toString());

      return false;
    }
  }

  @override
  Future<Map<String, Map>?> getCollectionGroup(
    String collectionID, {
    List<DocumentQuery> filters = const [],
    int? limit,
    DocumentOrderBy? orderBy,
  }) async {
    try {
      Query query = _databaseReference.collectionGroup(collectionID);
      for (DocumentQuery docQuery in filters) {
        switch (docQuery.condition) {
          case DocumentFieldCondition.isEqualTo:
            query = query.where(docQuery.key, isEqualTo: docQuery.value);
            break;
          case DocumentFieldCondition.isGreaterThan:
            query = query.where(docQuery.key, isGreaterThan: docQuery.value);
            break;
          case DocumentFieldCondition.isGreaterThanOrEqualTo:
            query = query.where(
              docQuery.key,
              isGreaterThanOrEqualTo: docQuery.value,
            );
            break;
          case DocumentFieldCondition.isLessThan:
            query = query.where(docQuery.key, isLessThan: docQuery.value);
            break;
          case DocumentFieldCondition.isLessThanOrEqualTo:
            query =
                query.where(docQuery.key, isLessThanOrEqualTo: docQuery.value);
            break;
          case DocumentFieldCondition.isNotEqualTo:
            query = query.where(docQuery.key, isNotEqualTo: docQuery.value);
            break;
          case DocumentFieldCondition.whereIn:
            query = query.where(docQuery.key, whereIn: docQuery.value);
            break;
        }
      }
      if (limit != null && limit > 0) {
        query = query.limit(limit);
      }
      if (orderBy != null) {
        query = query.orderBy(orderBy.field, descending: orderBy.descending);
        if (orderBy.startAt != null) {
          query = query.startAt([orderBy.startAt]);
        }
        if (orderBy.endAt != null) {
          query = query.endAt([orderBy.endAt]);
        }
      }
      final QuerySnapshot result = await query.get();
      final Map<String, Map<dynamic, dynamic>> list =
          <String, Map<dynamic, dynamic>>{};

      for (final docQuerySnapshot in result.docs) {
        final documentValue = docQuerySnapshot.data() as Map<String, dynamic>;
        list[docQuerySnapshot.reference.path] = documentValue;
      }

      return list;
    } on FirebaseException catch (e) {
      _log.severe(e.toString(), e, e.stackTrace);

      return null;
    }
  }

  @override
  Stream<Map<String, Map>?> watchCollectionGroup(
    String collectionID, {
    List<DocumentQuery> filters = const [],
    int? limit,
    DocumentOrderBy? orderBy,
  }) async* {
    try {
      Query query = _databaseReference.collectionGroup(collectionID);
      for (DocumentQuery docQuery in filters) {
        switch (docQuery.condition) {
          case DocumentFieldCondition.isEqualTo:
            query = query.where(docQuery.key, isEqualTo: docQuery.value);
            break;
          case DocumentFieldCondition.isGreaterThan:
            query = query.where(docQuery.key, isGreaterThan: docQuery.value);
            break;
          case DocumentFieldCondition.isGreaterThanOrEqualTo:
            query = query.where(
              docQuery.key,
              isGreaterThanOrEqualTo: docQuery.value,
            );
            break;
          case DocumentFieldCondition.isLessThan:
            query = query.where(docQuery.key, isLessThan: docQuery.value);
            break;
          case DocumentFieldCondition.isLessThanOrEqualTo:
            query =
                query.where(docQuery.key, isLessThanOrEqualTo: docQuery.value);
            break;
          case DocumentFieldCondition.isNotEqualTo:
            query = query.where(docQuery.key, isNotEqualTo: docQuery.value);
            break;
          case DocumentFieldCondition.whereIn:
            query = query.where(docQuery.key, whereIn: docQuery.value);
            break;
        }
      }
      if (limit != null && limit > 0) {
        query = query.limit(limit);
      }
      if (orderBy != null) {
        query = query.orderBy(orderBy.field, descending: orderBy.descending);
        if (orderBy.startAt != null) {
          query = query.startAt([orderBy.startAt]);
        }
        if (orderBy.endAt != null) {
          query = query.endAt([orderBy.endAt]);
        }
      }
      final Stream<QuerySnapshot> result = query.snapshots();
      await for (final querySnapshot in result) {
        final Map<String, Map<dynamic, dynamic>> list =
            <String, Map<dynamic, dynamic>>{};
        for (final docQuerySnapshot in querySnapshot.docs) {
          final documentValue = docQuerySnapshot.data() as Map<String, dynamic>;
          list[docQuerySnapshot.reference.path] = documentValue;
        }
        yield list;
      }
    } on FirebaseException catch (e) {
      _log.severe(e.toString(), e, e.stackTrace);
      yield null;
    }
  }

  @override
  Stream<Map<dynamic, dynamic>?> watchRecordByDocumentPath(String path) async* {
    try {
      final Stream<DocumentSnapshot> resultSnapshots =
          _databaseReference.doc(path).snapshots();
      final data = resultSnapshots.map<Map<dynamic, dynamic>>(
        (documentShaphot) => documentShaphot.data() as Map<dynamic, dynamic>,
      );
      yield* data;
    } on FirebaseException catch (e) {
      _log.severe(e.toString(), e, e.stackTrace);
      yield null;
    }
  }

  @override
  Future<String?> getDonwloadLink(String url) async {
    if (url.isEmpty) {
      return null;
    }
    try {
      return await FirebaseStorage.instance.ref().child(url).getDownloadURL();
    } on FirebaseException catch (e) {
      _log.severe(e.toString(), e, e.stackTrace);

      return null;
    }
  }

  /// Constructs a new [DatabaseFirestoreImplementation].
  DatabaseFirestoreImplementation(CacheManager? cacheManager)
      : _cacheManager = cacheManager ?? FirebaseCacheManager();
}
