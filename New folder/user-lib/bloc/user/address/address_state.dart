import 'package:equatable/equatable.dart';
import '../../../model/address/address_model.dart';

enum AddressStatus {
  initial,
  loading,
  loaded,
  adding,
  addSuccess,
  updating,
  updateSuccess,
  deleting,
  deleteSuccess,
  settingDefault,
  setDefaultSuccess,
  detectingLocation,
  locationDetected,
  error,
}

class AddressState extends Equatable {
  final AddressStatus status;
  final List<AddressModel> addresses;
  final AddressModel? defaultAddress;
  final AddressModel? selectedAddress;
  final String? errorMessage;
  final String? successMessage;
  final double? detectedLatitude;
  final double? detectedLongitude;
  final String? detectedAddress;
  final String? detectedDistrict;
  final String? detectedCity;
  final String? detectedProvince;
  final String? detectedPostalCode;

  const AddressState({
    this.status = AddressStatus.initial,
    this.addresses = const [],
    this.defaultAddress,
    this.selectedAddress,
    this.errorMessage,
    this.successMessage,
    this.detectedLatitude,
    this.detectedLongitude,
    this.detectedAddress,
    this.detectedDistrict,
    this.detectedCity,
    this.detectedProvince,
    this.detectedPostalCode,
  });

  factory AddressState.initial() {
    return const AddressState();
  }

  AddressState copyWith({
    AddressStatus? status,
    List<AddressModel>? addresses,
    AddressModel? defaultAddress,
    AddressModel? selectedAddress,
    String? errorMessage,
    String? successMessage,
    double? detectedLatitude,
    double? detectedLongitude,
    String? detectedAddress,
    String? detectedDistrict,
    String? detectedCity,
    String? detectedProvince,
    String? detectedPostalCode,
    bool clearDefault = false,
    bool clearSelected = false,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return AddressState(
      status: status ?? this.status,
      addresses: addresses ?? this.addresses,
      defaultAddress: clearDefault ? null : (defaultAddress ?? this.defaultAddress),
      selectedAddress: clearSelected ? null : (selectedAddress ?? this.selectedAddress),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
      detectedLatitude: detectedLatitude ?? this.detectedLatitude,
      detectedLongitude: detectedLongitude ?? this.detectedLongitude,
      detectedAddress: detectedAddress ?? this.detectedAddress,
      detectedDistrict: detectedDistrict ?? this.detectedDistrict,
      detectedCity: detectedCity ?? this.detectedCity,
      detectedProvince: detectedProvince ?? this.detectedProvince,
      detectedPostalCode: detectedPostalCode ?? this.detectedPostalCode,
    );
  }

  /// Check if loading addresses
  bool get isLoading => status == AddressStatus.loading;

  /// Check if adding address
  bool get isAdding => status == AddressStatus.adding;

  /// Check if updating address
  bool get isUpdating => status == AddressStatus.updating;

  /// Check if deleting address
  bool get isDeleting => status == AddressStatus.deleting;

  /// Check if setting default
  bool get isSettingDefault => status == AddressStatus.settingDefault;

  /// Check if detecting location
  bool get isDetectingLocation => status == AddressStatus.detectingLocation;

  /// Check if any operation is in progress
  bool get isBusy => isLoading || isAdding || isUpdating || isDeleting || isSettingDefault || isDetectingLocation;

  /// Check if has addresses
  bool get hasAddresses => addresses.isNotEmpty;

  /// Get the address to display (selected > default > first)
  AddressModel? get displayAddress {
    if (selectedAddress != null) return selectedAddress;
    if (defaultAddress != null) return defaultAddress;
    if (addresses.isNotEmpty) {
      // Try to find default from list
      final def = addresses.where((a) => a.isDefault).firstOrNull;
      if (def != null) return def;
      return addresses.first;
    }
    return null;
  }

  @override
  List<Object?> get props => [
        status,
        addresses,
        defaultAddress,
        selectedAddress,
        errorMessage,
        successMessage,
        detectedLatitude,
        detectedLongitude,
        detectedAddress,
        detectedDistrict,
        detectedCity,
        detectedProvince,
        detectedPostalCode,
      ];
}
