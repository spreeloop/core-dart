/// Helper methods for manipulating database paths.
class DatabasePathUtils {
  /// Returns the ID of the document.
  static String getDocumentId(String documentPath) {
    return documentPath.split('/').last;
  }

  /// Returns the full path of the document.
  static String getDatabasePath(String collectionPath, String documentId) {
    return '$collectionPath/$documentId';
  }

  /// Checks if the provided path is a valid collection path.
  static bool isValidCollectionPath(String path) {
    final List<String> pathSegments =
        path.trim().split('/').where((segment) => segment.isNotEmpty).toList();

    return pathSegments.length % 2 == 1;
  }

  /// Checks if the provided path is a valid document path.
  static bool isValidDocumentPath(String path) {
    final List<String> pathSegments =
        path.trim().split('/').where((segment) => segment.isNotEmpty).toList();
    if (pathSegments.isEmpty) {
      return false;
    }

    return pathSegments.length % 2 == 0;
  }

  /// Returns the parent collection path of the provided entity path.
  static String? getParentCollectionPath(String path) {
    if (isValidCollectionPath(path)) {
      final pathSegments = path.split('/');
      pathSegments.removeLast();
      pathSegments.removeLast();
      final parentCollection = pathSegments.join('/');

      return isValidCollectionPath(parentCollection) ? parentCollection : null;
    }
    if (isValidDocumentPath(path)) {
      final pathSegments = path.split('/');
      pathSegments.removeLast();
      final parentCollection = pathSegments.join('/');

      return parentCollection;
    }

    return null;
  }

  /// Returns the parent document path of the provided entity path.
  static String? getParentDocumentPath(String path) {
    if (isValidCollectionPath(path)) {
      final pathSegments = path.split('/');
      pathSegments.removeLast();

      return pathSegments.join('/');
    }

    if (isValidDocumentPath(path)) {
      final pathSegments = path.split('/');
      pathSegments.removeLast();
      pathSegments.removeLast();

      return pathSegments.isEmpty ? null : pathSegments.join('/');
    }

    return null;
  }
}
