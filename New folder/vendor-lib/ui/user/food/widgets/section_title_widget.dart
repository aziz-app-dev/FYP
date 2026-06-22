import 'widgets.dart';

List<Widget> _titleWidgets(String title, bool isRequired, ThemeColors colors) {
  return [
    Text(
      title,
      style: AppTextStyles.titleMedium.copyWith(
        fontWeight: FontWeight.bold,
        color: colors.textPrimary,
      ),
    ),
    if (isRequired) ...[
      SizedBox(width: 6.spMin),
      Text(
        '*',
        style: TextStyle(
          color: colors.secondary,
          fontSize: 18.spMin,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ];
}

/// Style 1: Title + optional required * + flat divider
class SectionTitle1 extends StatelessWidget {
  const SectionTitle1(this.title, {super.key, this.isRequired = false});

  final String title;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        Row(
          children: [
            ..._titleWidgets(title, isRequired, colors),
            AppSizes.horizontalSpaceSm,
            Expanded(
              child: Divider(
                color: AppColors.backgroundDark,
                height: 1,
                thickness: 1,
              ),
            ),
          ],
        ),
        AppSizes.verticalSpaceXs,
      ],
    );
  }
}

/// Style 2: Title + optional required * + divider with top padding offset
class SectionTitle2 extends StatelessWidget {
  const SectionTitle2(this.title, {super.key, this.isRequired = false});

  final String title;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        Row(
          spacing: 4.spMin,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ..._titleWidgets(title, isRequired, colors),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 8.spMin),
                child: Divider(
                  color: colors.divider,
                  height: 1,
                  thickness: 1,
                ),
              ),
            ),
          ],
        ),
        AppSizes.verticalSpaceXs,
      ],
    );
  }
}
