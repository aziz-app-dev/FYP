import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/config.dart';
import '../../../config/widgets/app_bar.dart';
import '../../../config/widgets/screen_wapper.dart';
import '../../../model/settings/card_style_settings.dart';
import '../../../services/session/session_manger.dart';

class FoodCardStyleSettingsPage extends StatelessWidget {
  FoodCardStyleSettingsPage({super.key});

  final SessionManager _sessionManager = SessionManager();
  late final ValueNotifier<CardStyleSettings> _settings =
      ValueNotifier<CardStyleSettings>(_sessionManager.cardStyleSettings);

  void _updateStyle(FoodDetailSection section, CardStyleType style) {
    final updated = _settings.value.copyWith(section: section, style: style);
    _settings.value = updated;
    _sessionManager.saveCardStyleSettings(updated);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ScreenWrapper(
      mobileHeader: CustomHeader(title: 'Card Style Settings'),
      mobile: SingleChildScrollView(
        padding: AppSizes.paddingAllMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customize the card style for each section in food details.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
              ),
            ),
            SizedBox(height: 20.spMin),
            ValueListenableBuilder<CardStyleSettings>(
              valueListenable: _settings,
              builder: (context, settings, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...FoodDetailSection.values.map(
                    (section) => _SectionStylePicker(
                      section: section,
                      currentStyle: settings.getStyle(section),
                      onStyleChanged: (style) => _updateStyle(section, style),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.spMin),
          ],
        ),
      ),
    );
  }
}

class _SectionStylePicker extends StatelessWidget {
  final FoodDetailSection section;
  final CardStyleType currentStyle;
  final ValueChanged<CardStyleType> onStyleChanged;

  const _SectionStylePicker({
    required this.section,
    required this.currentStyle,
    required this.onStyleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.only(bottom: 16.spMin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            CardStyleSettings.sectionDisplayName(section),
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: 10.spMin),
          Row(
            children: [
              Expanded(
                child: _StyleOption(
                  style: CardStyleType.style1,
                  isSelected: currentStyle == CardStyleType.style1,
                  onTap: () => onStyleChanged(CardStyleType.style1),
                ),
              ),
              SizedBox(width: 12.spMin),
              Expanded(
                child: _StyleOption(
                  style: CardStyleType.style2,
                  isSelected: currentStyle == CardStyleType.style2,
                  onTap: () => onStyleChanged(CardStyleType.style2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StyleOption extends StatelessWidget {
  final CardStyleType style;
  final bool isSelected;
  final VoidCallback onTap;

  const _StyleOption({
    required this.style,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final borderColor = isSelected ? colors.primary : colors.border;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(12.spMin),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withValues(alpha: 0.05)
              : colors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Column(
          children: [
            // Preview of the card style
            _buildPreview(colors),
            SizedBox(height: 10.spMin),
            // Label
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 18.spMin,
                  height: 18.spMin,
                  decoration: BoxDecoration(
                    color: isSelected ? colors.primary : Colors.transparent,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? null
                        : Border.all(color: colors.border, width: 1.5),
                  ),
                  child: isSelected
                      ? Icon(Icons.check, size: 12.spMin, color: colors.surface)
                      : null,
                ),
                SizedBox(width: 6.spMin),
                Text(
                  CardStyleSettings.styleDisplayName(style),
                  style: TextStyle(
                    fontSize: 12.spMin,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? colors.primary : colors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview(ThemeColors colors) {
    if (style == CardStyleType.style1) {
      return _buildStyle1Preview(colors);
    }
    return _buildStyle2Preview(colors);
  }

  /// Preview of SelectableOptionCard (Detailed Card)
  Widget _buildStyle1Preview(ThemeColors colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.spMin, vertical: 8.spMin),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: colors.primary, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox.shrink(),
              Container(
                padding: EdgeInsets.all(2.spMin),
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, size: 8.spMin, color: colors.surface),
              ),
            ],
          ),
          SizedBox(height: 4.spMin),
          Container(
            height: 8.spMin,
            width: 50.spMin,
            decoration: BoxDecoration(
              color: colors.textPrimary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(height: 4.spMin),
          Container(
            height: 6.spMin,
            width: 35.spMin,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
        ],
      ),
    );
  }

  /// Preview of SelectableOptionCard2 (Compact Chip)
  Widget _buildStyle2Preview(ThemeColors colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.spMin, vertical: 10.spMin),
      decoration: BoxDecoration(
        gradient: colors.primaryGradient,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 8.spMin,
            width: 40.spMin,
            decoration: BoxDecoration(
              color: colors.textOnPrimary.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(width: 8.spMin),
          Container(
            height: 8.spMin,
            width: 25.spMin,
            decoration: BoxDecoration(
              color: colors.textOnPrimary.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(width: 6.spMin),
          Icon(Icons.check, size: 10.spMin, color: colors.textOnPrimary),
        ],
      ),
    );
  }
}
