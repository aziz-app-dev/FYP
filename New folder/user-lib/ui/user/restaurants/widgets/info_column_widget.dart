import 'widgets.dart';

class InfoColumnData {
  final String value;
  final String label;

  const InfoColumnData({required this.value, required this.label});
}

class InfoColumn extends StatelessWidget {
  final InfoColumnData data;

  const InfoColumn({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          data.value,
          style: AppTextStyles.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 2.spMin),
        Text(
          data.label,
          style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
