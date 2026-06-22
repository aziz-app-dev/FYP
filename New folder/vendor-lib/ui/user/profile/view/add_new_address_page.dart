import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

import '../../../../const/app_url.dart';
import '../../../../di/service_locator.dart';
import '0_all_profile_view.dart';

class AddNewAddressPage extends StatefulWidget {
  final AddressModel? address; // For editing

  const AddNewAddressPage({super.key, this.address});

  @override
  State<AddNewAddressPage> createState() => _AddNewAddressPageState();
}

class _AddNewAddressPageState extends State<AddNewAddressPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _addressLine1Controller;
  late TextEditingController _postalCodeController;
  late TextEditingController _cityController;
  late TextEditingController _districtController;
  late TextEditingController _provinceController;
  late TextEditingController _instructionController;

  final ValueNotifier<bool> _setAsDefault = ValueNotifier<bool>(false);
  bool get isEditing => widget.address != null;

  double? _latitude;
  double? _longitude;

  final ValueNotifier<bool> _isSavePressed = ValueNotifier<bool>(false);
  final _addressFocusNode = FocusNode();
  late AddressBloc _addressBloc;

  @override
  void initState() {
    super.initState();

    _addressBloc = getIt<AddressBloc>();

    final address = widget.address;

    _addressLine1Controller = TextEditingController(
      text: address?.addressLine1 ?? '',
    );
    _postalCodeController = TextEditingController(
      text: address?.postalCode ?? '',
    );
    _cityController = TextEditingController(text: address?.city ?? '');
    _districtController = TextEditingController(text: address?.district ?? '');
    _provinceController = TextEditingController(text: address?.province ?? '');
    _instructionController = TextEditingController(
      text: address?.instruction ?? '',
    );
    _setAsDefault.value = address?.isDefault ?? false;
    _latitude = address?.latitude;
    _longitude = address?.longitude;
  }

  @override
  void dispose() {
    _addressLine1Controller.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _provinceController.dispose();
    _instructionController.dispose();
    _addressFocusNode.dispose();
    _addressBloc.close();
    _setAsDefault.dispose();
    _isSavePressed.dispose();
    super.dispose();
  }

  void _onPlaceSelected(Prediction prediction) {
    _addressLine1Controller.text = prediction.description ?? '';
    _addressLine1Controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _addressLine1Controller.text.length),
    );

    final components = prediction.description?.split(', ') ?? [];
    if (components.length >= 2) {
      if (components.length >= 3) {
        _districtController.text = components[1];
        _cityController.text = components[2];
      }
      if (components.length >= 4) {
        _provinceController.text = components[3];
      }
    }
  }

  void _onPlaceDetailsReceived(Prediction prediction) {
    _latitude = double.tryParse(prediction.lat ?? '');
    _longitude = double.tryParse(prediction.lng ?? '');
  }

  void _saveAddress() {
    if (!_formKey.currentState!.validate()) return;

    if (isEditing) {
      _addressBloc.add(
        UpdateAddressEvent(
          addressId: widget.address!.id!,
          addressLine1: _addressLine1Controller.text.trim(),
          postalCode: _postalCodeController.text.trim(),
          city: _cityController.text.trim().isEmpty
              ? null
              : _cityController.text.trim(),
          district: _districtController.text.trim(),
          province: _provinceController.text.trim(),
          instruction: _instructionController.text.trim().isEmpty
              ? null
              : _instructionController.text.trim(),
          setAsDefault: _setAsDefault.value,
          latitude: _latitude,
          longitude: _longitude,
        ),
      );
    } else {
      _addressBloc.add(
        AddAddressEvent(
          addressLine1: _addressLine1Controller.text.trim(),
          postalCode: _postalCodeController.text.trim(),
          city: _cityController.text.trim().isEmpty
              ? null
              : _cityController.text.trim(),
          district: _districtController.text.trim(),
          province: _provinceController.text.trim(),
          instruction: _instructionController.text.trim().isEmpty
              ? null
              : _instructionController.text.trim(),
          setAsDefault: _setAsDefault.value,
          latitude: _latitude,
          longitude: _longitude,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    Widget content = BlocConsumer<AddressBloc, AddressState>(
      bloc: _addressBloc,
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AddressStatus.addSuccess ||
            state.status == AddressStatus.updateSuccess) {
          Navigator.pop(context, true);
        }

        if (state.status == AddressStatus.locationDetected) {
          if (state.detectedAddress != null) {
            _addressLine1Controller.text = state.detectedAddress!;
          }
          if (state.detectedDistrict != null) {
            _districtController.text = state.detectedDistrict!;
          }
          if (state.detectedCity != null) {
            _cityController.text = state.detectedCity!;
          }
          if (state.detectedProvince != null) {
            _provinceController.text = state.detectedProvince!;
          }
          if (state.detectedPostalCode != null) {
            _postalCodeController.text = state.detectedPostalCode!;
          }
          _latitude = state.detectedLatitude;
          _longitude = state.detectedLongitude;
          ToastUtils.showSuccess(context, message: 'Location detected');
        }

        if (state.status == AddressStatus.error && state.errorMessage != null) {
          ToastUtils.showError(context, message: state.errorMessage!);
        }
      },
      builder: (context, state) {
        final isSaving = state.isAdding || state.isUpdating;
        final isDetecting = state.isDetectingLocation;

        return ScreenWrapper(
          useMobileScaffold: true,
          mobileHeader: CustomHeader(
            title: isEditing ? 'Edit Address' : 'Add New Address',
          ),
          mobile: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: AppSizes.paddingAllMd,
                    child: Column(
                      spacing: 20.spMin,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAddressRow(colors, isDetecting),

                        _buildTextField(
                          label: 'District',
                          hint: 'Manhattan',
                          controller: _districtController,
                          icon: Icons.map_outlined,
                          colors: colors,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'District is required';
                            }
                            return null;
                          },
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                label: 'City',
                                hint: 'New York',
                                controller: _cityController,
                                icon: Icons.location_city_outlined,
                                colors: colors,
                              ),
                            ),
                            SizedBox(width: 8.spMin),
                            Expanded(
                              child: _buildTextField(
                                label: 'Province/State',
                                hint: 'NY',
                                controller: _provinceController,
                                icon: Icons.public_outlined,
                                colors: colors,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),

                        _buildTextField(
                          label: 'Postal Code',
                          hint: '10001',
                          controller: _postalCodeController,
                          icon: Icons.markunread_mailbox_outlined,
                          colors: colors,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Postal code is required';
                            }
                            return null;
                          },
                        ),

                        _buildTextField(
                          label: 'Delivery Instructions',
                          hint: 'Ring doorbell, leave at door, etc.',
                          controller: _instructionController,
                          icon: Icons.note_outlined,
                          colors: colors,
                          maxLines: 2,
                        ),

                        SizedBox(height: 20.spMin),
                      ],
                    ),
                  ),
                ),

                _buildSaveSection(colors, isSaving),
              ],
            ),
          ),
        );
      },
    );

    return BlocProvider.value(value: _addressBloc, child: content);
  }

  Widget _buildAddressRow(ThemeColors colors, bool isDetecting) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Street Address',
          style: AppTextStyles.bodyMedium.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.spMin),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GooglePlaceAutoCompleteTextField(
                boxDecoration: BoxDecoration(
                  border: Border.all(width: 0, color: Colors.transparent),
                ),
                textEditingController: _addressLine1Controller,
                focusNode: _addressFocusNode,
                googleAPIKey: AppUrl.googlePlacesApiKey,
                inputDecoration: InputDecoration(
                  hintText: 'Search for your address',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 12.w, right: 6.w),
                    child: Icon(
                      Icons.location_on_outlined,
                      color: colors.primary,
                      size: 20.spMin,
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.spMin,
                    vertical: 14.spMin,
                  ),
                ),
                textStyle: AppTextStyles.bodyLarge.copyWith(
                  color: colors.textPrimary,
                ),
                debounceTime: 400,
                countries: const ['pk'],
                isLatLngRequired: true,
                getPlaceDetailWithLatLng: _onPlaceDetailsReceived,
                itemClick: _onPlaceSelected,
                seperatedBuilder: Divider(height: 1, color: colors.divider),
                itemBuilder: (context, index, Prediction prediction) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.spMin,
                      vertical: 8.spMin,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.place_outlined,
                          size: 18.spMin,
                          color: colors.textSecondary,
                        ),
                        SizedBox(width: 8.spMin),
                        Expanded(
                          child: Text(
                            prediction.description ?? '',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: colors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                isCrossBtnShown: true,
              ),
            ),
            SizedBox(width: 10.spMin),
            GestureDetector(
              onTap: isDetecting
                  ? null
                  : () => _addressBloc.add(DetectCurrentLocationEvent()),
              child: Container(
                width: 45.spMin,
                height: 45.spMin,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: isDetecting
                    ? appLoader(color: colors.primary, size: 22.spMin)
                    : Center(
                        child: Icon(
                          Icons.my_location,
                          size: 22.spMin,
                          color: colors.primary,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSaveSection(ThemeColors colors, bool isSaving) {
    return AnimatedBuilder(
      animation: Listenable.merge([_setAsDefault, _isSavePressed]),
      builder: (context, _) {
        final setAsDefault = _setAsDefault.value;
        final isSavePressed = _isSavePressed.value;
        return Container(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: EdgeInsets.all(16.spMin),
          padding: EdgeInsets.all(16.spMin),
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: setAsDefault
                  ? colors.primary.withValues(alpha: 0.4)
                  : colors.border,
              width: setAsDefault ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: (setAsDefault ? colors.primary : colors.shadow)
                    .withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _setAsDefault.value = !setAsDefault,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: 40.spMin,
                      height: 40.spMin,
                      decoration: BoxDecoration(
                        color: setAsDefault
                            ? colors.primary.withValues(alpha: 0.12)
                            : colors.scaffoldBackground,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(scale: animation, child: child),
                          child: Icon(
                            setAsDefault
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            key: ValueKey(setAsDefault),
                            size: 22.spMin,
                            color: setAsDefault
                                ? colors.primary
                                : colors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.spMin),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Set as default',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                          Text(
                            'Primary delivery address',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _setAsDefault.value = !setAsDefault,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: 50.spMin,
                        height: 28.spMin,
                        padding: EdgeInsets.all(3.spMin),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.r),
                          color: setAsDefault
                              ? colors.primary
                              : colors.textSecondary.withValues(alpha: 0.3),
                        ),
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          alignment: setAsDefault
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            width: 22.spMin,
                            height: 22.spMin,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: setAsDefault
                                  ? Icon(
                                      Icons.check,
                                      key: const ValueKey(true),
                                      size: 14.spMin,
                                      color: colors.primary,
                                    )
                                  : SizedBox(key: const ValueKey(false)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.spMin),

              GestureDetector(
                onTapDown: (_) {
                  if (!isSaving) _isSavePressed.value = true;
                },
                onTapUp: (_) {
                  _isSavePressed.value = false;
                  if (!isSaving) _saveAddress();
                },
                onTapCancel: () => _isSavePressed.value = false,
                child: AnimatedScale(
                  scale: isSavePressed ? 0.96 : 1.0,
                  duration: const Duration(milliseconds: 120),
                  curve: Curves.easeInOut,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    height: 45.spMin,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      gradient: LinearGradient(
                        colors: isSaving
                            ? [
                                colors.primary.withValues(alpha: 0.6),
                                colors.primary.withValues(alpha: 0.4),
                              ]
                            : [
                                colors.primary,
                                colors.primary.withValues(alpha: 0.85),
                              ],
                      ),
                      boxShadow: [
                        if (!isSaving)
                          BoxShadow(
                            color: colors.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                    child: Center(
                      child: isSaving
                          ? appLoader(color: Colors.white, size: 22)
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isEditing
                                      ? Icons.save_rounded
                                      : Icons.add_location_alt_rounded,
                                  size: 20.spMin,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 8.spMin),
                                Text(
                                  isEditing ? 'Update Address' : 'Save Address',
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    required ThemeColors colors,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.spMin),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 12.w, right: 6.w),
              child: Icon(icon, color: colors.primary, size: 18.spMin),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.spMin,
              vertical: 14.spMin,
            ),
          ),
          style: AppTextStyles.bodyLarge.copyWith(color: colors.textPrimary),
        ),
      ],
    );
  }
}
