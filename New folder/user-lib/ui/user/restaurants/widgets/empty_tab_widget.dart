import 'widgets.dart';

class EmptyTab extends StatelessWidget {
  final IconData icon;
  final String message;

  const EmptyTab({
    super.key,
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48.spMin, color: colors.textSecondary),
          SizedBox(height: 12.spMin),
          Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
