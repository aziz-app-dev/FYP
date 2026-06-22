import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config.dart';

class AdminSettingsGroup extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const AdminSettingsGroup({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.spMin),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(icon, color: colors.primary, size: 18.spMin),
                ),
                SizedBox(width: 12.w),
                Text(
                  title.toUpperCase(),
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.03),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(color: colors.border.withValues(alpha: 0.4)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.r),
              child: Column(children: children),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminSettingsTile extends StatelessWidget {
  final String title;
  final String value;
  final bool isNumber;
  final bool isPassword;
  final ValueChanged<String> onChanged;

  const AdminSettingsTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.isNumber = false,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final displayValue = isPassword ? '••••••••' : value;

    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          displayValue,
          style: AppTextStyles.labelSmall.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.all(8.spMin),
          decoration: BoxDecoration(
            color: colors.surfaceVariant.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.edit_rounded,
            size: 16.spMin,
            color: colors.textSecondary,
          ),
        ),
        onTap: () => _showEditDialog(context),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final colors = context.colors;
    final controller = TextEditingController(text: value);

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(24.spMin),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(28.r),
            border: Border.all(color: colors.border.withValues(alpha: 0.5)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit $title',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: controller,
                keyboardType: isNumber
                    ? TextInputType.number
                    : TextInputType.text,
                obscureText: isPassword,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter $title',
                  filled: true,
                  fillColor: colors.surfaceVariant.withValues(alpha: 0.3),
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      'CANCEL',
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      onChanged(controller.text);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: const Text('SAVE CHANGES'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminSettingsDropdownTile extends StatelessWidget {
  final String title;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const AdminSettingsDropdownTile({
    super.key,
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
      ),
      trailing: SizedBox(
        width: 120.w,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            color: colors.surfaceVariant.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              items: options.map((String val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(
                    val.length > 8 ? val.substring(0, 8) : val,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class AdminSettingsSwitchTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const AdminSettingsSwitchTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SwitchListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTextStyles.labelSmall.copyWith(
                color: colors.textSecondary,
              ),
            )
          : null,
      activeThumbColor: colors.primary,
      value: value,
      onChanged: onChanged,
    );
  }
}

class AdminSettingsSliderTile extends StatelessWidget {
  final String title;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;

  const AdminSettingsSliderTile({
    super.key,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(left: 20.w, right: 20.w, top: 8.h),
          title: Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              value.toStringAsFixed(1),
              style: AppTextStyles.labelSmall.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: divisions ?? ((max - min) * 2).toInt(),
          activeColor: colors.primary,
          inactiveColor: colors.primary.withValues(alpha: 0.1),
          onChanged: onChanged,
        ),
        SizedBox(height: 8.h),
      ],
    );
  }
}
