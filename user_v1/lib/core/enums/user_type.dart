/// Enum representing the type of user account mode
enum UserType {
  customer,
  vendor;

  /// Parse UserType from string value
  static UserType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'vendor':
        return UserType.vendor;
      case 'customer':
      default:
        return UserType.customer;
    }
  }

  /// Convert to display string
  String toDisplayString() {
    switch (this) {
      case UserType.vendor:
        return 'Vendor';
      case UserType.customer:
        return 'Customer';
    }
  }

  /// Convert to storage string
  String toStorageString() {
    switch (this) {
      case UserType.vendor:
        return 'vendor';
      case UserType.customer:
        return 'customer';
    }
  }
}
