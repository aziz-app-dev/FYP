import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../../../bloc/shared/profile/profile_bloc.dart';
import '../../../../bloc/shared/profile/profile_event.dart';
import '../../../../bloc/shared/profile/profile_state.dart';
import '../../../../config/config.dart';

Widget buildThemeTile(BuildContext context, ThemeColors colors) {
  return BlocBuilder<ProfileBloc, ProfileState>(
    buildWhen: (previous, current) => previous.themeMode != current.themeMode,
    builder: (context, state) {
      return Card(
        margin: EdgeInsets.zero,
        color: colors.card,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12.spMin,
            vertical: 12.spMin,
          ),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r)),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.spMin),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: .1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getThemeIcon(state.themeMode),
                  color: colors.primary,
                  size: 22.spMin,
                ),
              ),
              SizedBox(width: 16.spMin),
              Expanded(
                child: Text(
                  'Theme',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.spMin,
                  vertical: 6.spMin,
                ),
                decoration: BoxDecoration(
                  color: colors.fillColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<ThemeMode>(
                    borderRadius: BorderRadius.circular(8.r),
                    value: state.themeMode,
                    isDense: true,
                    dropdownColor: colors.card,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colors.textPrimary,
                    ),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: colors.textSecondary,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              TablerIcons.brush,
                              size: 18.spMin,
                              color: colors.textSecondary,
                            ),
                            SizedBox(width: 8.spMin),
                            Text(
                              'System',
                              style: TextStyle(color: colors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.light_mode_outlined,
                              size: 18.spMin,
                              color: colors.textSecondary,
                            ),
                            SizedBox(width: 8.spMin),
                            Text(
                              'Light',
                              style: TextStyle(color: colors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.dark_mode_outlined,
                              size: 18.spMin,
                              color: colors.textSecondary,
                            ),
                            SizedBox(width: 8.spMin),
                            Text(
                              'Dark',
                              style: TextStyle(color: colors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (ThemeMode? newMode) {
                      if (newMode != null) {
                        context.read<ProfileBloc>().add(
                          ChangeThemeEvent(themeMode: newMode),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

IconData _getThemeIcon(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.system:
      return TablerIcons.brush;
    case ThemeMode.light:
      return TablerIcons.sun;
    case ThemeMode.dark:
      return TablerIcons.moon;
  }
}
