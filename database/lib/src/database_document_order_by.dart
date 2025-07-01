/// A collection result ordering attribute.
class DocumentOrderBy<T> {
  /// The field name.
  String field;

  /// True when sorting should be descending.
  bool descending;

  /// The starting value in which the query will start.
  T? startAt;

  /// The ending value in which the query will start.
  T? endAt;

  /// The document path in which the query will start.
  String? startAtDocumentPath;

  /// The document path in which the query will start.
  String? startAfterDocumentPath;

  /// Constructs a new [DocumentOrderBy].
  DocumentOrderBy(
    this.field, {
    this.descending = false,
    this.startAt,
    this.endAt,
    this.startAtDocumentPath,
    this.startAfterDocumentPath,
  });
}
