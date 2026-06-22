import '../../../../config/widgets/price_widget.dart';
import 'widgets.dart';

class BottomCartBar extends StatelessWidget {
  final double totalPrice;
  final int quantity;
  final int minQuantity;
  final int maxQuantity;
  final bool isAvailable;
  final bool hasRequiredCustomizations;
  final String title;
  final double basePrice;

  const BottomCartBar({
    super.key,
    required this.totalPrice,
    required this.quantity,
    this.minQuantity = 1,
    this.maxQuantity = 10,
    this.isAvailable = true,
    this.hasRequiredCustomizations = true,
    required this.title,
    required this.basePrice,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final canAddToCart = isAvailable && hasRequiredCustomizations;
    return Container(
      padding: AppSizes.paddingAllMd,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusMd),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!hasRequiredCustomizations)
            Padding(
              padding: EdgeInsets.only(bottom: 8.spMin),
              child: Text(
                'Please select all required options',
                style: TextStyle(color: colors.error, fontSize: 12.spMin),
              ),
            ),
          Row(
            children: [
              //! Title & Price (replaced quantity selector)
              Expanded(
                child: Row(
                  children: [PriceText(price: totalPrice, fontSize: 18.spMin)],
                ),
              ),
              SizedBox(width: 16.spMin),
              //! Add to Cart Button
              Expanded(
                child: AppButton(
                  height: 35.spMin,
                  icon: Icons.shopping_bag,
                  iconSize: 16.spMin,
                  text: isAvailable ? 'Add to Cart' : 'Unavailable',
                  onPressed: canAddToCart
                      ? () {
                          context.read<FoodDetailsBloc>().add(
                            const AddToCartEvent(),
                          );
                        }
                      : () {},
                ),
                // GestureDetector(
                //   onTap:
                // canAddToCart
                //       ? () {
                //           context.read<FoodDetailsBloc>().add(
                //             const AddToCartEvent(),
                //           );
                //         }
                //       : null,
                //   child: Container(
                //     padding: EdgeInsets.symmetric(vertical: 16.spMin),
                //     decoration: BoxDecoration(
                //       gradient: canAddToCart ? colors.primaryGradient : null,
                //       color: canAddToCart ? null : colors.buttonDisabled,
                //       borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                //       boxShadow: canAddToCart
                //           ? [
                //               BoxShadow(
                //                 color: colors.primary.withValues(alpha: .3),
                //                 blurRadius: 10,
                //                 offset: const Offset(0, 5),
                //               ),
                //             ]
                //           : null,
                //     ),
                //     child: Center(
                //       child: Text(
                //         isAvailable
                //             ? 'Add to Cart'
                //             : 'Unavailable',
                //         style: TextStyle(
                //           color: canAddToCart
                //               ? colors.textOnPrimary
                //               : colors.buttonDisabledText,
                //           fontSize: 16.spMin,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
