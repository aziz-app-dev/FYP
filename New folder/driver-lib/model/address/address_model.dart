import 'package:equatable/equatable.dart';

class AddressModel extends Equatable {
  final String? id;
  final String? userId;
  final String addressLine1;
  final String postalCode;
  final String? city;
  final String district;
  final String province;
  final String? country;
  final double? latitude;
  final double? longitude;
  final String? instruction;
  final bool isDefault;
  final String? createdAt;
  final String? updatedAt;

  const AddressModel({
    this.id,
    this.userId,
    required this.addressLine1,
    required this.postalCode,
    this.city,
    required this.district,
    required this.province,
    this.country,
    this.latitude,
    this.longitude,
    this.instruction,
    this.isDefault = false,
    this.createdAt,
    this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['_id']?.toString(),
      userId: json['userId']?.toString(),
      addressLine1: json['addressLine1'] ?? '',
      postalCode: json['postalCode'] ?? '',
      city: json['city'],
      district: json['district'] ?? '',
      province: json['province'] ?? '',
      country: json['country'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      instruction: json['instruction'],
      isDefault: json['default'] ?? false,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      if (userId != null) 'userId': userId,
      'addressLine1': addressLine1,
      'postalCode': postalCode,
      if (city != null) 'city': city,
      'district': district,
      'province': province,
      if (country != null) 'country': country,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (instruction != null) 'instruction': instruction,
      'default': isDefault,
    };
  }

  AddressModel copyWith({
    String? id,
    String? userId,
    String? addressLine1,
    String? postalCode,
    String? city,
    String? district,
    String? province,
    String? country,
    double? latitude,
    double? longitude,
    String? instruction,
    bool? isDefault,
    String? createdAt,
    String? updatedAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      addressLine1: addressLine1 ?? this.addressLine1,
      postalCode: postalCode ?? this.postalCode,
      city: city ?? this.city,
      district: district ?? this.district,
      province: province ?? this.province,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      instruction: instruction ?? this.instruction,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get formatted address string
  String get formattedAddress {
    final parts = <String>[];
    parts.add(addressLine1);
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (district.isNotEmpty) parts.add(district);
    if (province.isNotEmpty) parts.add(province);
    if (postalCode.isNotEmpty) parts.add(postalCode);
    return parts.join(', ');
  }

  /// Get short address (for display in header)
  String get shortAddress {
    if (city != null && city!.isNotEmpty) {
      return '$addressLine1, $city';
    }
    return '$addressLine1, $district';
  }

  /// Get full address (alias for formattedAddress)
  String get fullAddress => formattedAddress;

  /// Get address type label
  String? get addressType {
    if (isDefault) return 'Default Address';
    return null;
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        addressLine1,
        postalCode,
        city,
        district,
        province,
        country,
        latitude,
        longitude,
        instruction,
        isDefault,
      ];
}
