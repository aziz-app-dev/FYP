import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/config.dart';
import '../../../config/widgets/app_bar.dart';
import '../../../config/widgets/screen_wapper.dart';
import '../../../data/exceptions/api_error_response.dart';
import '../../../model/settings/food_details_config.dart';
import '../../../model/settings/settings_model.dart';
import '../../../repo/user/settings/settings_repo.dart';
import '../../../services/session/session_manger.dart';
import '../../../utils/toast_utils.dart';

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  final SessionManager _session = SessionManager();
  final SettingsRepo _repo = SettingsRepo();
  final ValueNotifier<bool> _saving = ValueNotifier<bool>(false);
  final ValueNotifier<int> _refreshTick = ValueNotifier<int>(0);

  SettingsModel? get _settings => _session.settings;

  @override
  void dispose() {
    _saving.dispose();
    _refreshTick.dispose();
    super.dispose();
  }

  Future<void> _patchField(Map<String, dynamic> updates) async {
    log('Settings PATCH request: $updates');
    _saving.value = true;
    try {
      await _repo.patchSettings(updates);
      log('Settings PATCH success, reloading settings...');
      // Reload settings from API
      final fresh = await _repo.getSettings();
      await _session.saveSettings(fresh);
      log('Settings reloaded successfully');
      if (mounted) {
        ToastUtils.showSuccess(context, message: 'Settings updated');
        _refreshTick.value++;
      }
    } catch (e, stackTrace) {
      log('Settings PATCH error: $e', stackTrace: stackTrace);
      if (mounted) {
        final message = e is ApiErrorResponse ? e.message : e.toString();
        ToastUtils.showError(context, message: message);
      }
    } finally {
      if (mounted) _saving.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AnimatedBuilder(
      animation: Listenable.merge([_saving, _refreshTick]),
      builder: (context, _) => ScreenWrapper(
      mobileHeader: CustomHeader(
        title: 'App Settings',
        action: _saving.value
            ? SizedBox(
                width: 20.spMin,
                height: 20.spMin,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.primary,
                ),
              )
            : null,
      ),
      mobile: _settings == null
          ? Center(
              child: Text(
                'No settings loaded',
                style: TextStyle(color: colors.textSecondary),
              ),
            )
          : SingleChildScrollView(
              padding: AppSizes.paddingAllMd,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGeneralSection(colors),
                  SizedBox(height: 16.spMin),
                  _buildDeliverySection(colors),
                  SizedBox(height: 16.spMin),
                  _buildHomeConfigSection(colors),
                  SizedBox(height: 16.spMin),
                  _buildFoodDetailsConfigSection(colors),
                  SizedBox(height: 16.spMin),
                  _buildPaymentSection(colors),
                  SizedBox(height: 16.spMin),
                  _buildOrderSection(colors),
                  SizedBox(height: 40.spMin),
                ],
              ),
            ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // GENERAL SETTINGS
  // ═══════════════════════════════════════════════════════════════

  Widget _buildGeneralSection(ThemeColors colors) {
    return _SettingsSection(
      title: 'General',
      icon: Icons.settings_outlined,
      colors: colors,
      children: [
        _SettingsTextTile(
          title: 'App Name',
          value: _settings?.appName ?? 'Food Delivery',
          colors: colors,
          onSave: (v) => _patchField({'appName': v}),
        ),
        _SettingsTextTile(
          title: 'Currency',
          value: _settings?.currency ?? 'PKR',
          colors: colors,
          onSave: (v) => _patchField({'currency': v}),
        ),
        _SettingsTextTile(
          title: 'Currency Symbol',
          value: _settings?.currencySymbol ?? 'Rs',
          colors: colors,
          onSave: (v) => _patchField({'currencySymbol': v}),
        ),
        _SettingsDropdownTile(
          title: 'Service Mode',
          value: _settings?.serviceMode ?? 'multi-vendor',
          options: const ['multi-vendor', 'single'],
          colors: colors,
          onChanged: (v) => _patchField({'serviceMode': v}),
        ),
        _SettingsSwitchTile(
          title: 'Allow Vendor Registration',
          value: _settings?.allowVendorRegistration ?? true,
          colors: colors,
          onChanged: (v) => _patchField({'allowVendorRegistration': v}),
        ),
        _SettingsSwitchTile(
          title: 'Enable Ordering',
          value: _settings?.isOrderingEnabled ?? true,
          colors: colors,
          onChanged: (v) => _patchField({'enableOrdering': v}),
        ),
        if (_settings?.isOrderingEnabled == false)
          Padding(
            padding: EdgeInsets.only(left: 4.spMin, bottom: 8.spMin),
            child: Text(
              'App runs in reservation-only mode.',
              style: TextStyle(
                fontSize: 12.spMin,
                color: colors.textTertiary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // DELIVERY & FEES
  // ═══════════════════════════════════════════════════════════════

  Widget _buildDeliverySection(ThemeColors colors) {
    return _SettingsSection(
      title: 'Delivery & Fees',
      icon: Icons.delivery_dining_outlined,
      colors: colors,
      children: [
        _SettingsNumberTile(
          title: 'Delivery Fee',
          value: _settings?.deliveryFee ?? 0,
          colors: colors,
          onSave: (v) => _patchField({'deliveryFee': v}),
        ),
        _SettingsNumberTile(
          title: 'Tax Rate (%)',
          value: _settings?.taxRate ?? 0,
          colors: colors,
          onSave: (v) => _patchField({'taxRate': v}),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // HOME CONFIG
  // ═══════════════════════════════════════════════════════════════

  Widget _buildHomeConfigSection(ThemeColors colors) {
    final hc = _settings?.homeConfig;
    return _SettingsSection(
      title: 'Home Page',
      icon: Icons.home_outlined,
      colors: colors,
      children: [
        _SettingsSwitchTile(
          title: 'Show Carousel',
          value: hc?.showCarousel ?? true,
          colors: colors,
          onChanged: (v) => _patchField({
            'homeConfig': {...?hc?.toJson(), 'showCarousel': v},
          }),
        ),
        _SettingsSwitchTile(
          title: 'Show Categories',
          value: hc?.showCategories ?? true,
          colors: colors,
          onChanged: (v) => _patchField({
            'homeConfig': {...?hc?.toJson(), 'showCategories': v},
          }),
        ),
        _SettingsSwitchTile(
          title: 'Show Top Foods',
          value: hc?.showTopFoods ?? true,
          colors: colors,
          onChanged: (v) => _patchField({
            'homeConfig': {...?hc?.toJson(), 'showTopFoods': v},
          }),
        ),
        _SettingsSwitchTile(
          title: 'Show Deals',
          value: hc?.showDeals ?? true,
          colors: colors,
          onChanged: (v) => _patchField({
            'homeConfig': {...?hc?.toJson(), 'showDeals': v},
          }),
        ),
        _SettingsSwitchTile(
          title: 'Show Offers',
          value: hc?.showOffers ?? true,
          colors: colors,
          onChanged: (v) => _patchField({
            'homeConfig': {...?hc?.toJson(), 'showOffers': v},
          }),
        ),
        _SettingsSwitchTile(
          title: 'Show Top Restaurants',
          value: hc?.showTopRestaurants ?? true,
          colors: colors,
          onChanged: (v) => _patchField({
            'homeConfig': {...?hc?.toJson(), 'showTopRestaurants': v},
          }),
        ),
        _SettingsSwitchTile(
          title: 'Show Random Restaurants',
          value: hc?.showRandomRestaurants ?? true,
          colors: colors,
          onChanged: (v) => _patchField({
            'homeConfig': {...?hc?.toJson(), 'showRandomRestaurants': v},
          }),
        ),
        _SettingsNumberTile(
          title: 'Top Foods Limit',
          value: (hc?.topFoodsLimit ?? 10).toDouble(),
          colors: colors,
          isInt: true,
          onSave: (v) => _patchField({
            'homeConfig': {...?hc?.toJson(), 'topFoodsLimit': v.toInt()},
          }),
        ),
        _SettingsNumberTile(
          title: 'Deals Limit',
          value: (hc?.dealsLimit ?? 5).toDouble(),
          colors: colors,
          isInt: true,
          onSave: (v) => _patchField({
            'homeConfig': {...?hc?.toJson(), 'dealsLimit': v.toInt()},
          }),
        ),
        _SettingsNumberTile(
          title: 'Offers Limit',
          value: (hc?.offersLimit ?? 5).toDouble(),
          colors: colors,
          isInt: true,
          onSave: (v) => _patchField({
            'homeConfig': {...?hc?.toJson(), 'offersLimit': v.toInt()},
          }),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // FOOD DETAILS CONFIG
  // ═══════════════════════════════════════════════════════════════

  Widget _buildFoodDetailsConfigSection(ThemeColors colors) {
    final fdc = _settings?.foodDetailsConfig ?? FoodDetailsConfig.defaults();
    return _SettingsSection(
      title: 'Food Details Page',
      icon: Icons.restaurant_menu_outlined,
      colors: colors,
      children: [
        _SettingsDropdownTile(
          title: 'Page Layout',
          value: fdc.pageLayout,
          options: const ['page1', 'page2'],
          colors: colors,
          onChanged: (v) => _patchField({
            'foodDetailsConfig': {...fdc.toJson(), 'pageLayout': v},
          }),
        ),
        _SettingsDropdownTile(
          title: 'Restaurant Info Style',
          value: fdc.restaurantInfoStyle,
          options: const ['style1', 'style2', 'style3', 'style4'],
          colors: colors,
          onChanged: (v) => _patchField({
            'foodDetailsConfig': {...fdc.toJson(), 'restaurantInfoStyle': v},
          }),
        ),
        _SettingsDropdownTile(
          title: 'Food Info Style',
          value: fdc.foodInfoStyle,
          options: const ['style1', 'style2', 'style3'],
          colors: colors,
          onChanged: (v) => _patchField({
            'foodDetailsConfig': {...fdc.toJson(), 'foodInfoStyle': v},
          }),
        ),
        _SettingsDropdownTile(
          title: 'Ingredients Style',
          value: fdc.ingredientsStyle,
          options: const ['style1', 'style2'],
          colors: colors,
          onChanged: (v) => _patchField({
            'foodDetailsConfig': {...fdc.toJson(), 'ingredientsStyle': v},
          }),
        ),
        _SettingsNumberTile(
          title: 'Section Spacing',
          value: fdc.sectionSpacing,
          colors: colors,
          onSave: (v) => _patchField({
            'foodDetailsConfig': {...fdc.toJson(), 'sectionSpacing': v},
          }),
        ),
        _SettingsNumberTile(
          title: 'Card Border Radius',
          value: fdc.cardBorderRadius,
          colors: colors,
          onSave: (v) => _patchField({
            'foodDetailsConfig': {...fdc.toJson(), 'cardBorderRadius': v},
          }),
        ),
        _SettingsNumberTile(
          title: 'Card Border Width',
          value: fdc.cardBorderWidth,
          colors: colors,
          onSave: (v) => _patchField({
            'foodDetailsConfig': {...fdc.toJson(), 'cardBorderWidth': v},
          }),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.spMin, bottom: 4.spMin),
          child: Text(
            'Section Visibility',
            style: TextStyle(
              fontSize: 13.spMin,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
        ),
        ...FoodDetailsConfig.allSections.map(
          (section) => _SettingsSwitchTile(
            title: _sectionLabel(section),
            value: fdc.isSectionVisible(section),
            colors: colors,
            onChanged: (v) {
              final updated = Map<String, bool>.from(fdc.sectionVisibility);
              updated[section] = v;
              _patchField({
                'foodDetailsConfig': {
                  ...fdc.toJson(),
                  'sectionVisibility': updated,
                },
              });
            },
          ),
        ),
      ],
    );
  }

  String _sectionLabel(String section) {
    return section
        .replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m.group(0)}')
        .trim()
        .split(' ')
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  // ═══════════════════════════════════════════════════════════════
  // PAYMENT CONFIG
  // ═══════════════════════════════════════════════════════════════

  Widget _buildPaymentSection(ThemeColors colors) {
    final pc = _settings?.paymentConfig;
    return _SettingsSection(
      title: 'Payment',
      icon: Icons.payment_outlined,
      colors: colors,
      children: [
        _SettingsSwitchTile(
          title: 'Cash on Delivery',
          value: pc?.enableCashOnDelivery ?? true,
          colors: colors,
          onChanged: (v) => _patchField({
            'paymentConfig': {...?pc?.toJson(), 'enableCashOnDelivery': v},
          }),
        ),
        _SettingsSwitchTile(
          title: 'Online Payment',
          value: pc?.enableOnlinePayment ?? false,
          colors: colors,
          onChanged: (v) => _patchField({
            'paymentConfig': {...?pc?.toJson(), 'enableOnlinePayment': v},
          }),
        ),
        _SettingsDropdownTile(
          title: 'Default Payment',
          value: pc?.defaultPaymentMethod ?? 'cash',
          options: const ['cash', 'online'],
          colors: colors,
          onChanged: (v) => _patchField({
            'paymentConfig': {...?pc?.toJson(), 'defaultPaymentMethod': v},
          }),
        ),
        _SettingsNumberTile(
          title: 'COD Extra Charge',
          value: pc?.codExtraCharge ?? 0,
          colors: colors,
          onSave: (v) => _patchField({
            'paymentConfig': {...?pc?.toJson(), 'codExtraCharge': v},
          }),
        ),
        _SettingsNumberTile(
          title: 'Max COD Amount',
          value: pc?.maxCodAmount ?? 0,
          colors: colors,
          onSave: (v) => _patchField({
            'paymentConfig': {...?pc?.toJson(), 'maxCodAmount': v},
          }),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // ORDER CONFIG
  // ═══════════════════════════════════════════════════════════════

  Widget _buildOrderSection(ThemeColors colors) {
    final oc = _settings?.orderConfig;
    return _SettingsSection(
      title: 'Orders',
      icon: Icons.receipt_long_outlined,
      colors: colors,
      children: [
        _SettingsNumberTile(
          title: 'Min Order Amount',
          value: oc?.minOrderAmount ?? 0,
          colors: colors,
          onSave: (v) => _patchField({
            'orderConfig': {...?oc?.toJson(), 'minOrderAmount': v},
          }),
        ),
        _SettingsNumberTile(
          title: 'Max Order Amount',
          value: oc?.maxOrderAmount ?? 0,
          colors: colors,
          onSave: (v) => _patchField({
            'orderConfig': {...?oc?.toJson(), 'maxOrderAmount': v},
          }),
        ),
        _SettingsNumberTile(
          title: 'Free Delivery Threshold',
          value: oc?.freeDeliveryThreshold ?? 0,
          colors: colors,
          onSave: (v) => _patchField({
            'orderConfig': {...?oc?.toJson(), 'freeDeliveryThreshold': v},
          }),
        ),
        _SettingsNumberTile(
          title: 'Est. Delivery Time (min)',
          value: (oc?.estimatedDeliveryTime ?? 30).toDouble(),
          colors: colors,
          isInt: true,
          onSave: (v) => _patchField({
            'orderConfig': {
              ...?oc?.toJson(),
              'estimatedDeliveryTime': v.toInt(),
            },
          }),
        ),
        _SettingsSwitchTile(
          title: 'Allow Scheduled Orders',
          value: oc?.allowScheduledOrders ?? false,
          colors: colors,
          onChanged: (v) => _patchField({
            'orderConfig': {...?oc?.toJson(), 'allowScheduledOrders': v},
          }),
        ),
        _SettingsSwitchTile(
          title: 'Allow Order Notes',
          value: oc?.allowOrderNotes ?? true,
          colors: colors,
          onChanged: (v) => _patchField({
            'orderConfig': {...?oc?.toJson(), 'allowOrderNotes': v},
          }),
        ),
        _SettingsSwitchTile(
          title: 'Allow Tips',
          value: oc?.allowTips ?? false,
          colors: colors,
          onChanged: (v) => _patchField({
            'orderConfig': {...?oc?.toJson(), 'allowTips': v},
          }),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// REUSABLE SETTINGS WIDGETS
// ═══════════════════════════════════════════════════════════════════════════

class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final ThemeColors colors;
  final List<Widget> children;

  _SettingsSection({
    required this.title,
    required this.icon,
    required this.colors,
    required this.children,
  });

  final ValueNotifier<bool> _expanded = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      clipBehavior: Clip.antiAlias,
      child: ValueListenableBuilder<bool>(
        valueListenable: _expanded,
        builder: (context, expanded, _) => Column(
          children: [
            InkWell(
              onTap: () => _expanded.value = !expanded,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.spMin,
                  vertical: 14.spMin,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.spMin),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: .1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: colors.primary,
                        size: 20.spMin,
                      ),
                    ),
                    SizedBox(width: 12.spMin),
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 24.spMin,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: EdgeInsets.only(
                  left: 16.spMin,
                  right: 16.spMin,
                  bottom: 12.spMin,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(color: colors.border, height: 1),
                    SizedBox(height: 8.spMin),
                    ...children,
                  ],
                ),
              ),
              crossFadeState: expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ThemeColors colors;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitchTile({
    required this.title,
    required this.value,
    required this.colors,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.spMin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 14.spMin, color: colors.textPrimary),
            ),
          ),
          SizedBox(
            height: 32.spMin,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeTrackColor: colors.primary.withValues(alpha: .3),
              activeThumbColor: colors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTextTile extends StatelessWidget {
  final String title;
  final String value;
  final ThemeColors colors;
  final ValueChanged<String> onSave;

  const _SettingsTextTile({
    required this.title,
    required this.value,
    required this.colors,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.spMin),
      child: InkWell(
        onTap: () => _showEditDialog(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 14.spMin, color: colors.textPrimary),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.spMin,
                    color: colors.textSecondary,
                  ),
                ),
                SizedBox(width: 4.spMin),
                Icon(
                  Icons.edit_outlined,
                  size: 16.spMin,
                  color: colors.textTertiary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final controller = TextEditingController(text: value);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter $title',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (controller.text != value) {
                onSave(controller.text);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _SettingsNumberTile extends StatelessWidget {
  final String title;
  final double value;
  final ThemeColors colors;
  final ValueChanged<double> onSave;
  final bool isInt;

  const _SettingsNumberTile({
    required this.title,
    required this.value,
    required this.colors,
    required this.onSave,
    this.isInt = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = isInt
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.spMin),
      child: InkWell(
        onTap: () => _showEditDialog(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 14.spMin, color: colors.textPrimary),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  displayValue,
                  style: TextStyle(
                    fontSize: 14.spMin,
                    color: colors.textSecondary,
                  ),
                ),
                SizedBox(width: 4.spMin),
                Icon(
                  Icons.edit_outlined,
                  size: 16.spMin,
                  color: colors.textTertiary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final displayValue = isInt
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
    final controller = TextEditingController(text: displayValue);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: 'Enter $title',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              final parsed = double.tryParse(controller.text);
              if (parsed != null && parsed != value) {
                onSave(parsed);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _SettingsDropdownTile extends StatelessWidget {
  final String title;
  final String value;
  final List<String> options;
  final ThemeColors colors;
  final ValueChanged<String> onChanged;

  const _SettingsDropdownTile({
    required this.title,
    required this.value,
    required this.options,
    required this.colors,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.spMin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14.spMin, color: colors.textPrimary),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.spMin),
            decoration: BoxDecoration(
              border: Border.all(color: colors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: options.contains(value) ? value : options.first,
              underline: const SizedBox.shrink(),
              isDense: true,
              style: TextStyle(fontSize: 13.spMin, color: colors.textPrimary),
              items: options
                  .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                  .toList(),
              onChanged: (v) {
                if (v != null && v != value) onChanged(v);
              },
            ),
          ),
        ],
      ),
    );
  }
}
