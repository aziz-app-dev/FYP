import 'package:food/ui/user/food/widgets/widgets.dart';

class QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const QtyButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.spMin),
        decoration: BoxDecoration(
          color: colors.scaffoldBackground,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 14.spMin, color: colors.textPrimary),
      ),
    );
  }
}
