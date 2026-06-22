import 'package:food/ui/user/food/widgets/widgets.dart';

class PaymentMethodOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodOption({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 12.spMin, horizontal: 16.spMin),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withValues(alpha: 0.1)
              : colors.background,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? colors.primary : colors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: isSelected ? colors.primary : colors.textSecondary,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected ? colors.primary : colors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
