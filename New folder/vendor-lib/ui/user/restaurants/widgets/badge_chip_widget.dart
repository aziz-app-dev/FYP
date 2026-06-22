import 'widgets.dart';

class BadgeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const BadgeChip({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.spMin, vertical: 6.spMin),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.spMin, color: color),
          SizedBox(width: 4.spMin),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.spMin,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
