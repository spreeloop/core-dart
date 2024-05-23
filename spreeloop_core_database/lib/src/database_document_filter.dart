/// A document query class for record info related data.
class DocumentQuery {
  /// The value of the field name.
  String key;

  /// The value of the field parameter.
  dynamic value;

  /// Database querying condition to be applied on the
  /// value of the field parameter.
  DocumentFieldCondition condition;

  /// Constructs the document query field class.
  DocumentQuery(this.key, this.value, this.condition);
}

/// A document field specification for querying.
enum DocumentFieldCondition {
  /// Condition that will be used to check if
  /// field value matches the database value.
  isEqualTo,

  /// Condition that will be used to check if
  /// field value is greater than the database value.
  isGreaterThan,

  /// Condition that will be used to check if
  /// field value is greater than or equals to the database value.
  isGreaterThanOrEqualTo,

  /// Condition that will be used to check if
  /// field value is less than the database value.
  isLessThan,

  /// Condition that will be used to check if
  /// field value is less than or equals to the database value.
  isLessThanOrEqualTo,

  /// Condition that will be used to check if
  /// field value is not equals to the database value.
  isNotEqualTo,

  /// Condition that will be used to check if
  /// the field matches any of the comparison values.
  whereIn
}
