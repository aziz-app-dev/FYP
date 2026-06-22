import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../../../const/app_url.dart';
import '../../../data/exceptions/api_error_response.dart';
import '../../../data/exceptions/app_exception.dart';
import '../../../repo/user/address/address_repo.dart';
import '../../../services/session/session_manger.dart';
import 'address_event.dart';
import 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRepo addressRepo;
  final SessionManager sessionManager;

  AddressBloc({
    required this.addressRepo,
    required this.sessionManager,
  }) : super(AddressState.initial()) {
    on<LoadAddressesEvent>(_onLoadAddresses);
    on<LoadDefaultAddressEvent>(_onLoadDefaultAddress);
    on<AddAddressEvent>(_onAddAddress);
    on<UpdateAddressEvent>(_onUpdateAddress);
    on<DeleteAddressEvent>(_onDeleteAddress);
    on<SetDefaultAddressEvent>(_onSetDefaultAddress);
    on<SelectAddressEvent>(_onSelectAddress);
    on<DetectCurrentLocationEvent>(_onDetectLocation);
    on<ResetAddressStateEvent>(_onResetState);
  }

  Future<void> _onLoadAddresses(
    LoadAddressesEvent event,
    Emitter<AddressState> emit,
  ) async {
    // Show cached data immediately if available
    final cached = sessionManager.addresses;
    final cachedDefault = sessionManager.defaultAddress;

    if (cached != null && cached.isNotEmpty) {
      emit(state.copyWith(
        status: AddressStatus.loaded,
        addresses: cached,
        defaultAddress: cachedDefault,
        selectedAddress: state.selectedAddress ?? cachedDefault,
      ));
    } else {
      emit(state.copyWith(status: AddressStatus.loading, clearError: true));
    }

    // Then refresh from API in the background
    try {
      final token = await sessionManager.getToken();
      if (token == null || token.isEmpty) {
        if (cached == null || cached.isEmpty) {
          emit(state.copyWith(
            status: AddressStatus.error,
            errorMessage: 'Authentication required',
          ));
        }
        return;
      }

      final addresses = await addressRepo.getUserAddresses(token);

      // Find default address from the list
      final defaultAddr = addresses.where((a) => a.isDefault).firstOrNull;

      // Update cache
      await sessionManager.saveAddresses(addresses);
      if (defaultAddr != null) {
        await sessionManager.saveDefaultAddress(defaultAddr);
      }

      emit(state.copyWith(
        status: AddressStatus.loaded,
        addresses: addresses,
        defaultAddress: defaultAddr,
        selectedAddress: state.selectedAddress ?? defaultAddr,
      ));
    } on ApiErrorResponse catch (e) {
      if (cached == null || cached.isEmpty) {
        emit(state.copyWith(
          status: AddressStatus.error,
          errorMessage: e.message,
        ));
      }
    } on NoInternetException {
      if (cached == null || cached.isEmpty) {
        emit(state.copyWith(
          status: AddressStatus.error,
          errorMessage: 'No internet connection',
        ));
      }
    } catch (e) {
      if (cached == null || cached.isEmpty) {
        emit(state.copyWith(
          status: AddressStatus.error,
          errorMessage: 'Failed to load addresses: ${e.toString()}',
        ));
      }
    }
  }

  Future<void> _onLoadDefaultAddress(
    LoadDefaultAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    try {
      final token = await sessionManager.getToken();
      if (token == null || token.isEmpty) return;

      final defaultAddr = await addressRepo.getDefaultAddress(token);
      if (defaultAddr != null) {
        await sessionManager.saveDefaultAddress(defaultAddr);
        emit(state.copyWith(
          defaultAddress: defaultAddr,
          selectedAddress: state.selectedAddress ?? defaultAddr,
        ));
      }
    } catch (e) {
      // Silently fail, use cached
      final cached = sessionManager.defaultAddress;
      if (cached != null) {
        emit(state.copyWith(defaultAddress: cached));
      }
    }
  }

  Future<void> _onAddAddress(
    AddAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(status: AddressStatus.adding, clearError: true));

    try {
      final token = await sessionManager.getToken();
      if (token == null || token.isEmpty) {
        emit(state.copyWith(
          status: AddressStatus.error,
          errorMessage: 'Authentication required',
        ));
        return;
      }

      final addressData = {
        'addressLine1': event.addressLine1,
        'postalCode': event.postalCode,
        if (event.city != null) 'city': event.city,
        'district': event.district,
        'province': event.province,
        if (event.country != null) 'country': event.country,
        if (event.latitude != null) 'latitude': event.latitude,
        if (event.longitude != null) 'longitude': event.longitude,
        if (event.instruction != null) 'instruction': event.instruction,
        'default': event.setAsDefault,
      };

      final newAddress = await addressRepo.createAddress(addressData, token);

      // Update state with new address
      final updatedAddresses = [...state.addresses];

      // If new address is default, unset other defaults
      if (newAddress.isDefault) {
        for (int i = 0; i < updatedAddresses.length; i++) {
          if (updatedAddresses[i].isDefault) {
            updatedAddresses[i] = updatedAddresses[i].copyWith(isDefault: false);
          }
        }
      }

      updatedAddresses.add(newAddress);

      // Update cache
      await sessionManager.saveAddresses(updatedAddresses);
      if (newAddress.isDefault) {
        await sessionManager.saveDefaultAddress(newAddress);
      }

      emit(state.copyWith(
        status: AddressStatus.addSuccess,
        addresses: updatedAddresses,
        defaultAddress: newAddress.isDefault ? newAddress : state.defaultAddress,
        successMessage: 'Address added successfully',
      ));
    } on ApiErrorResponse catch (e) {
      emit(state.copyWith(
        status: AddressStatus.error,
        errorMessage: e.message,
      ));
    } on NoInternetException {
      emit(state.copyWith(
        status: AddressStatus.error,
        errorMessage: 'No internet connection',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AddressStatus.error,
        errorMessage: 'Failed to add address: ${e.toString()}',
      ));
    }
  }

  Future<void> _onUpdateAddress(
    UpdateAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(status: AddressStatus.updating, clearError: true));

    try {
      final token = await sessionManager.getToken();
      if (token == null || token.isEmpty) {
        emit(state.copyWith(
          status: AddressStatus.error,
          errorMessage: 'Authentication required',
        ));
        return;
      }

      final addressData = {
        'addressLine1': event.addressLine1,
        'postalCode': event.postalCode,
        if (event.city != null) 'city': event.city,
        'district': event.district,
        'province': event.province,
        if (event.country != null) 'country': event.country,
        if (event.latitude != null) 'latitude': event.latitude,
        if (event.longitude != null) 'longitude': event.longitude,
        if (event.instruction != null) 'instruction': event.instruction,
        'default': event.setAsDefault,
      };

      final updatedAddress = await addressRepo.updateAddress(
        event.addressId,
        addressData,
        token,
      );

      // Update state
      final updatedAddresses = state.addresses.map((addr) {
        if (addr.id == event.addressId) {
          return updatedAddress;
        }
        // Unset default if this one is now default
        if (updatedAddress.isDefault && addr.isDefault && addr.id != event.addressId) {
          return addr.copyWith(isDefault: false);
        }
        return addr;
      }).toList();

      // Update cache
      await sessionManager.saveAddresses(updatedAddresses);
      if (updatedAddress.isDefault) {
        await sessionManager.saveDefaultAddress(updatedAddress);
      }

      emit(state.copyWith(
        status: AddressStatus.updateSuccess,
        addresses: updatedAddresses,
        defaultAddress: updatedAddress.isDefault ? updatedAddress : state.defaultAddress,
        selectedAddress: state.selectedAddress?.id == event.addressId
            ? updatedAddress
            : state.selectedAddress,
        successMessage: 'Address updated successfully',
      ));
    } on ApiErrorResponse catch (e) {
      emit(state.copyWith(
        status: AddressStatus.error,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AddressStatus.error,
        errorMessage: 'Failed to update address: ${e.toString()}',
      ));
    }
  }

  Future<void> _onDeleteAddress(
    DeleteAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(status: AddressStatus.deleting, clearError: true));

    try {
      final token = await sessionManager.getToken();
      if (token == null || token.isEmpty) {
        emit(state.copyWith(
          status: AddressStatus.error,
          errorMessage: 'Authentication required',
        ));
        return;
      }

      await addressRepo.deleteAddress(event.addressId, token);

      // Update state
      final updatedAddresses = state.addresses
          .where((addr) => addr.id != event.addressId)
          .toList();

      // Update cache
      await sessionManager.saveAddresses(updatedAddresses);

      // Clear default if deleted
      final wasDefault = state.defaultAddress?.id == event.addressId;
      final wasSelected = state.selectedAddress?.id == event.addressId;

      emit(state.copyWith(
        status: AddressStatus.deleteSuccess,
        addresses: updatedAddresses,
        clearDefault: wasDefault,
        clearSelected: wasSelected,
        successMessage: 'Address deleted successfully',
      ));
    } on ApiErrorResponse catch (e) {
      emit(state.copyWith(
        status: AddressStatus.error,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AddressStatus.error,
        errorMessage: 'Failed to delete address: ${e.toString()}',
      ));
    }
  }

  Future<void> _onSetDefaultAddress(
    SetDefaultAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(status: AddressStatus.settingDefault, clearError: true));

    try {
      final token = await sessionManager.getToken();
      if (token == null || token.isEmpty) {
        emit(state.copyWith(
          status: AddressStatus.error,
          errorMessage: 'Authentication required',
        ));
        return;
      }

      final updatedAddress = await addressRepo.setDefaultAddress(event.addressId, token);

      // Update state - unset other defaults
      final updatedAddresses = state.addresses.map((addr) {
        if (addr.id == event.addressId) {
          return updatedAddress;
        }
        if (addr.isDefault) {
          return addr.copyWith(isDefault: false);
        }
        return addr;
      }).toList();

      // Update cache
      await sessionManager.saveAddresses(updatedAddresses);
      await sessionManager.saveDefaultAddress(updatedAddress);

      emit(state.copyWith(
        status: AddressStatus.setDefaultSuccess,
        addresses: updatedAddresses,
        defaultAddress: updatedAddress,
        successMessage: 'Default address updated',
      ));
    } on ApiErrorResponse catch (e) {
      emit(state.copyWith(
        status: AddressStatus.error,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AddressStatus.error,
        errorMessage: 'Failed to set default address: ${e.toString()}',
      ));
    }
  }

  Future<void> _onDetectLocation(
    DetectCurrentLocationEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(status: AddressStatus.detectingLocation, clearError: true));

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(state.copyWith(
          status: AddressStatus.error,
          errorMessage: 'Location services are disabled',
        ));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(state.copyWith(
            status: AddressStatus.error,
            errorMessage: 'Location permission denied',
          ));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(state.copyWith(
          status: AddressStatus.error,
          errorMessage: 'Location permission permanently denied. Please enable it in settings.',
        ));
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      String? address;
      String? district;
      String? city;
      String? province;
      String? postalCode;

      // Reverse geocode using Google Maps API
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json'
        '?latlng=${position.latitude},${position.longitude}'
        '&key=${AppUrl.googlePlacesApiKey}',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List?;

        if (results != null && results.isNotEmpty) {
          final result = results[0];
          address = result['formatted_address'];

          final components = result['address_components'] as List? ?? [];
          for (final comp in components) {
            final types = (comp['types'] as List?)?.cast<String>() ?? [];
            final value = comp['long_name'] ?? '';

            if (types.contains('sublocality') ||
                types.contains('sublocality_level_1')) {
              district = value;
            } else if (types.contains('locality')) {
              city = value;
            } else if (types.contains('administrative_area_level_1')) {
              province = value;
            } else if (types.contains('postal_code')) {
              postalCode = value;
            }
          }
        }
      }

      emit(state.copyWith(
        status: AddressStatus.locationDetected,
        detectedLatitude: position.latitude,
        detectedLongitude: position.longitude,
        detectedAddress: address,
        detectedDistrict: district,
        detectedCity: city,
        detectedProvince: province,
        detectedPostalCode: postalCode,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AddressStatus.error,
        errorMessage: 'Failed to get location',
      ));
    }
  }

  void _onSelectAddress(
    SelectAddressEvent event,
    Emitter<AddressState> emit,
  ) {
    emit(state.copyWith(selectedAddress: event.address));
  }

  void _onResetState(
    ResetAddressStateEvent event,
    Emitter<AddressState> emit,
  ) {
    emit(AddressState.initial());
  }
}
