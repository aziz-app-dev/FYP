import 'package:equatable/equatable.dart';
import '../../../model/address/address_model.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

/// Load all addresses
class LoadAddressesEvent extends AddressEvent {}

/// Load default address only
class LoadDefaultAddressEvent extends AddressEvent {}

/// Add a new address
class AddAddressEvent extends AddressEvent {
  final String addressLine1;
  final String postalCode;
  final String? city;
  final String district;
  final String province;
  final String? country;
  final double? latitude;
  final double? longitude;
  final String? instruction;
  final bool setAsDefault;

  const AddAddressEvent({
    required this.addressLine1,
    required this.postalCode,
    this.city,
    required this.district,
    required this.province,
    this.country,
    this.latitude,
    this.longitude,
    this.instruction,
    this.setAsDefault = false,
  });

  @override
  List<Object?> get props => [
        addressLine1,
        postalCode,
        city,
        district,
        province,
        country,
        latitude,
        longitude,
        instruction,
        setAsDefault,
      ];
}

/// Update an existing address
class UpdateAddressEvent extends AddressEvent {
  final String addressId;
  final String addressLine1;
  final String postalCode;
  final String? city;
  final String district;
  final String province;
  final String? country;
  final double? latitude;
  final double? longitude;
  final String? instruction;
  final bool setAsDefault;

  const UpdateAddressEvent({
    required this.addressId,
    required this.addressLine1,
    required this.postalCode,
    this.city,
    required this.district,
    required this.province,
    this.country,
    this.latitude,
    this.longitude,
    this.instruction,
    this.setAsDefault = false,
  });

  @override
  List<Object?> get props => [
        addressId,
        addressLine1,
        postalCode,
        city,
        district,
        province,
        country,
        latitude,
        longitude,
        instruction,
        setAsDefault,
      ];
}

/// Delete an address
class DeleteAddressEvent extends AddressEvent {
  final String addressId;

  const DeleteAddressEvent(this.addressId);

  @override
  List<Object> get props => [addressId];
}

/// Set an address as default
class SetDefaultAddressEvent extends AddressEvent {
  final String addressId;

  const SetDefaultAddressEvent(this.addressId);

  @override
  List<Object> get props => [addressId];
}

/// Select an address for delivery (local selection without API call)
class SelectAddressEvent extends AddressEvent {
  final AddressModel address;

  const SelectAddressEvent(this.address);

  @override
  List<Object> get props => [address];
}

/// Detect current location and reverse geocode
class DetectCurrentLocationEvent extends AddressEvent {}

/// Reset address state
class ResetAddressStateEvent extends AddressEvent {}
