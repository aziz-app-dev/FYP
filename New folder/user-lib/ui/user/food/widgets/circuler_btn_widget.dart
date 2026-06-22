import 'widgets.dart';

Widget circulerBtnWidget({
  required IconData icon,
  required VoidCallback onTap,
  Color? iconColor,
}) {
  return Material(
    color: Colors.transparent,
    // shape: const CircleBorder(),
    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
    child: InkWell(
      onTap: onTap,
      // customBorder: const CircleBorder(),
      child: Container(
        padding: EdgeInsets.all(8.spMin),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          // shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .1),
              blurRadius: 10,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: iconColor ?? AppColors.primary,
          size: 22.spMin,
        ),
      ),
    ),
  );
}
