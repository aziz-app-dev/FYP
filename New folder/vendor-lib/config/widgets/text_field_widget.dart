// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/config.dart';

// Constants
const double TEXTFIELD_BR = 12;
const double TEXTFIELD_VERTI_PAD = 14;
const double TEXTFIELD_HORI_PAD = 16;
const double CONTAINER_BR = 20;

// Helper text functions
Text text14(String text, {Color color = Colors.black}) => Text(
  text,
  style: TextStyle(fontSize: 14.spMin, color: color),
);

Text text14Bold(String text, {Color color = Colors.black}) => Text(
  text,
  style: TextStyle(
    fontSize: 14.spMin,
    color: color,
    fontWeight: FontWeight.bold,
  ),
);

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool? filled;
  final int? maxLines;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChange;
  final Function(String?)? onFieldSubmitted;
  final IconData? icon;
  final FocusNode? focusNode;
  final TextStyle? hintStyle;
  final bool isSearch;
  final bool? isDense;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? apiError;
  final Color? borderColor;
  final Color? focusedBorder;
  final Color? fillColor;
  final double borderRadius;
  final BorderSide? borderSide;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final bool? enabled;
  final bool? readOnly;
  final BoxConstraints? prefixIconConstraints;
  final EdgeInsetsGeometry? contentPadding;
  final List<TextInputFormatter>? inputFormatters;
  final Function()? onTap;

  const CustomTextField({
    super.key,
    this.focusedBorder,
    this.contentPadding,
    this.isDense,
    this.onTap,
    this.enabled,
    this.prefixIconConstraints,
    this.readOnly = false,
    this.textInputAction,
    this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.validator,
    this.icon,
    this.focusNode,
    this.isSearch = false,
    this.prefixIcon,
    this.suffixIcon,
    this.apiError,
    this.filled,
    this.maxLines = 1,
    this.borderColor,
    this.fillColor,
    this.onChange,
    this.onFieldSubmitted,
    this.hintStyle,
    this.borderRadius = TEXTFIELD_BR,
    this.borderSide,
    this.style,
    this.inputFormatters,
  });

  Color _getBorderColor(BuildContext context) {
    return borderColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade700
            : Colors.grey.shade300);
  }

  Color _getFillColor(BuildContext context) {
    return fillColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade900
            : Colors.grey.shade100);
  }

  Color _getHintColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade500
        : Colors.grey.shade600;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final borderColor = _getBorderColor(context);
    final fillColor = _getFillColor(context);
    final hintColor = _getHintColor(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          inputFormatters: inputFormatters,
          onTap: onTap,
          readOnly: readOnly ?? false,
          enabled: enabled,
          textInputAction: textInputAction,
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          obscureText: isPassword,
          maxLines: isPassword ? 1 : maxLines,
          cursorColor: colors.primary,
          style:
              style ??
              AppTextStyles.bodyMedium.copyWith(color: colors.textPrimary),
          decoration: InputDecoration(
            isDense: isDense ?? true,
            hintText: hintText,
            labelStyle: AppTextStyles.labelMedium.copyWith(color: hintColor),
            hintStyle:
                hintStyle ??
                AppTextStyles.bodyMedium.copyWith(color: hintColor),
            prefixIcon: prefixIcon,
            suffixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: suffixIcon,
            ),
            suffixIconConstraints: BoxConstraints(minWidth: 20.w, minHeight: 2),
            border: OutlineInputBorder(
              borderSide:
                  borderSide ?? BorderSide(width: 1, color: borderColor),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide:
                  borderSide ?? BorderSide(width: 1.5, color: colors.primary),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide:
                  borderSide ?? BorderSide(width: 1, color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide:
                  borderSide ?? BorderSide(width: 1, color: borderColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(width: 1, color: colors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(width: 1, color: colors.error),
            ),
            constraints: BoxConstraints(minWidth: 20.w, minHeight: 2),
            prefixIconConstraints:
                prefixIconConstraints ??
                BoxConstraints(minWidth: 40.w, minHeight: 2),
            filled: filled ?? true,
            fillColor: fillColor,
            alignLabelWithHint: false,
            contentPadding:
                contentPadding ??
                EdgeInsets.symmetric(
                  vertical: TEXTFIELD_VERTI_PAD.h,
                  horizontal: TEXTFIELD_HORI_PAD.w,
                ),
          ),
          validator: validator,
          onChanged: onChange,
          onFieldSubmitted: onFieldSubmitted,
        ),
        if (apiError != null)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5),
            child: Text(
              apiError!,
              style: TextStyle(color: colors.error, fontSize: 12.spMin),
            ),
          ),
      ],
    );
  }
}

class AppDropdown<T> extends StatelessWidget {
  final String label;
  final FontWeight? labelSize;
  final String hintText;
  final List<T?> items;
  final List<String>? displayItems;
  final T? value;
  final void Function(T?)? onChanged;
  final bool? filled;
  final bool? isDense;
  final bool? isExpanded;
  final Color? fillColor;
  final Color? lableColor;
  final BorderSide? borderSide;
  final double borderRadius;
  final Color? borderColor;

  const AppDropdown({
    super.key,
    this.labelSize,
    this.borderColor,
    required this.label,
    required this.hintText,
    required this.items,
    this.displayItems,
    required this.value,
    required this.onChanged,
    this.filled,
    this.lableColor,
    this.fillColor,
    this.borderRadius = TEXTFIELD_BR,
    this.borderSide,
    this.isDense,
    this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final borderColor =
        this.borderColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade700
            : Colors.grey.shade300);
    final fillColor =
        this.fillColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade900
            : Colors.grey.shade100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: labelSize ?? FontWeight.w600,
            color: lableColor ?? colors.textPrimary,
          ),
        ),
        SizedBox(height: 6.h),
        SizedBox(
          height: 44.h,
          child: DropdownButtonFormField<T?>(
            isExpanded: isExpanded ?? false,
            isDense: isDense ?? true,
            dropdownColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade800
                : Colors.white,
            initialValue: value,
            style: AppTextStyles.bodyMedium.copyWith(color: colors.textPrimary),
            hint: Text(
              hintText,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
              ),
            ),
            onChanged: onChanged,
            items: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final displayText =
                  displayItems != null && index < displayItems!.length
                  ? displayItems![index]
                  : item?.toString() ?? '';
              return DropdownMenuItem<T>(value: item, child: Text(displayText));
            }).toList(),
            decoration: InputDecoration(
              suffixIconConstraints: BoxConstraints(
                minWidth: 20.w,
                minHeight: 2.h,
              ),
              labelStyle: AppTextStyles.labelMedium.copyWith(
                color: colors.textSecondary,
              ),
              fillColor: fillColor,
              filled: filled ?? true,
              border: OutlineInputBorder(
                borderSide:
                    borderSide ?? BorderSide(width: 1, color: borderColor),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide:
                    borderSide ?? BorderSide(width: 1.5, color: colors.primary),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide:
                    borderSide ?? BorderSide(width: 1, color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide:
                    borderSide ?? BorderSide(width: 1, color: borderColor),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(width: 1, color: colors.error),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(width: 1, color: colors.error),
              ),
              prefixIconConstraints: BoxConstraints(
                minWidth: 20.w,
                minHeight: 10.h,
              ),
              constraints: BoxConstraints(minWidth: 20.w, minHeight: 2),
              contentPadding: EdgeInsets.symmetric(
                vertical: TEXTFIELD_VERTI_PAD.h + 2.h,
                horizontal: TEXTFIELD_HORI_PAD.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomSearchDropdown2<T> extends StatefulWidget {
  final String label;
  final String hintText;
  final String searchTxt;
  final String clearTxt;
  final List<T> items;
  final List<String> displayItems;
  final T? value;
  final void Function(T?)? onChanged;
  final bool filled;
  final bool isDense;
  final Color? fillColor;
  final Color? lableColor;
  final BorderSide? borderSide;
  final double borderRadius;
  final Color? borderColor;

  const CustomSearchDropdown2({
    super.key,
    required this.label,
    required this.hintText,
    required this.searchTxt,
    required this.clearTxt,
    this.lableColor,
    required this.items,
    required this.displayItems,
    required this.value,
    required this.onChanged,
    this.filled = true,
    this.isDense = true,
    this.fillColor,
    this.borderRadius = TEXTFIELD_BR,
    this.borderSide,
    this.borderColor,
  });

  @override
  State<CustomSearchDropdown2<T>> createState() =>
      _CustomSearchDropdown2State<T>();
}

class _CustomSearchDropdown2State<T> extends State<CustomSearchDropdown2<T>> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<List<int>> _filteredIndicesNotifier =
      ValueNotifier<List<int>>([]);

  @override
  void initState() {
    super.initState();
    _updateFilteredIndices('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _filteredIndicesNotifier.dispose();
    super.dispose();
  }

  void _updateFilteredIndices(String query) {
    if (query.isEmpty) {
      _filteredIndicesNotifier.value = List.generate(
        widget.items.length,
        (index) => index,
      );
    } else {
      _filteredIndicesNotifier.value = widget.displayItems
          .asMap()
          .entries
          .where((entry) {
            final item = entry.value.toLowerCase();
            return item.contains(query.toLowerCase());
          })
          .map((entry) => entry.key)
          .toList();
    }
  }

  void _showBottomSheet() {
    if (widget.items.isEmpty || widget.displayItems.isEmpty) return;
    _searchController.clear();
    _updateFilteredIndices('');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            final colors = context.colors;
            return Container(
              decoration: BoxDecoration(
                color: colors.scaffoldBackground,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(CONTAINER_BR),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: colors.scaffoldBackground,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(CONTAINER_BR),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            widget.onChanged?.call(null);
                            _searchController.clear();
                            _updateFilteredIndices('');
                            Navigator.pop(context);
                          },
                          child: Text(
                            widget.clearTxt,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: colors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          widget.label,
                          style: AppTextStyles.titleSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.close_rounded,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: CustomTextField(
                      hintText: widget.searchTxt,
                      controller: _searchController,
                      onChange: (value) {
                        _updateFilteredIndices(value ?? '');
                        return null;
                      },
                      isDense: true,
                      filled: widget.filled,
                      prefixIcon: Icon(
                        Icons.search,
                        size: 18.spMin,
                        color: colors.textSecondary,
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 40.w,
                        minHeight: 2.h,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: TEXTFIELD_VERTI_PAD.h,
                        horizontal: TEXTFIELD_HORI_PAD.w,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              constraints: BoxConstraints(
                                minWidth: 24.w,
                                minHeight: 24.h,
                                maxWidth: 24.w,
                                maxHeight: 24.h,
                              ),
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.clear,
                                size: 18.spMin,
                                color: colors.textSecondary,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                _updateFilteredIndices('');
                              },
                            )
                          : null,
                    ),
                  ),
                  Expanded(
                    child: ValueListenableBuilder<List<int>>(
                      valueListenable: _filteredIndicesNotifier,
                      builder: (context, filteredIndices, child) {
                        if (filteredIndices.isEmpty) {
                          return Center(
                            child: Text(
                              'No items found',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          controller: scrollController,
                          itemCount: filteredIndices.length,
                          itemBuilder: (context, index) {
                            final itemIndex = filteredIndices[index];
                            final item = widget.items[itemIndex];
                            final displayText = widget.displayItems[itemIndex];
                            final isSelected = widget.value == item;
                            return ListTile(
                              title: Text(
                                displayText,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: isSelected
                                      ? colors.primary
                                      : colors.textPrimary,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              trailing: isSelected
                                  ? Icon(
                                      Icons.check,
                                      color: colors.primary,
                                      size: 18.spMin,
                                    )
                                  : null,
                              onTap: () {
                                widget.onChanged?.call(item);
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final borderColor =
        widget.borderColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade700
            : Colors.grey.shade300);
    final fillColor =
        widget.fillColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade900
            : Colors.grey.shade100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.labelLarge.copyWith(
            color: widget.lableColor ?? colors.textPrimary,
          ),
        ),
        SizedBox(height: 6.h),
        GestureDetector(
          onTap: _showBottomSheet,
          child: Container(
            height: 44.h,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: borderColor),
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color: fillColor,
            ),
            padding: EdgeInsets.symmetric(
              vertical: TEXTFIELD_VERTI_PAD.h,
              horizontal: TEXTFIELD_HORI_PAD.w,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.value != null &&
                            widget.items.contains(widget.value) &&
                            widget.items.indexOf(widget.value as T) <
                                widget.displayItems.length
                        ? widget.displayItems[widget.items.indexOf(
                            widget.value as T,
                          )]
                        : widget.hintText,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: colors.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
