import '../../../../ui/user/food/widgets/widgets.dart';
import '../../../../bloc/user/cart/cart_bloc.dart';
import '../../../../bloc/user/cart/cart_event.dart';
import '../../../../bloc/user/cart/cart_state.dart';
import '../../../../config/widgets/order_summary_card.dart';

class CheckoutSection extends StatefulWidget {
  final CartState state;
  final dynamic settings;
  final String currencySymbol;
  final VoidCallback onCheckout;

  const CheckoutSection({
    super.key,
    required this.state,
    required this.settings,
    required this.currencySymbol,
    required this.onCheckout,
  });

  @override
  State<CheckoutSection> createState() => CheckoutSectionState();
}

class CheckoutSectionState extends State<CheckoutSection> {
  final TextEditingController _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final state = widget.state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Promo Code ────────────────────────────────────────
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.spMin),
          child: _buildPromoSection(colors, state),
        ),

        SizedBox(height: 16.spMin),

        // ─── Order Summary + Proceed ────────────────────────────
        OrderSummaryCard(
          title: 'Order Summary',
          subtotal: state.subtotal,
          deliveryFee: state.deliveryFee,
          taxAmount: state.taxAmount,
          discount: state.discount,
          total: state.total,
          child: AppButton(
            text: 'Proceed',
            onPressed: widget.onCheckout,
            backgroundColor: AppColors.black,
          ),
        ),
      ],
    );
  }

  // ─── Promo Section ──────────────────────────────────────────────

  Widget _buildPromoSection(ThemeColors colors, CartState state) {
    final hasPromo = state.promoCode != null && state.promoCode!.isNotEmpty;

    if (hasPromo) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Code display
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12.spMin,
                vertical: 10.spMin,
              ),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              //   border: Border.all(color: colors.divider),
              // ),
              child: Text(
                state.promoCode!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          // Confirmed pill
          GestureDetector(
            onTap: () {
              _promoController.clear();
              context.read<CartBloc>().add(const RemovePromoCodeEvent());
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 14.spMin,
                vertical: 10.spMin,
              ),
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(24.spMin),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Promo-code Confirmed',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4.spMin),
                  Icon(
                    Icons.close,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: 14.spMin,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    // Promo not applied — show input
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 40.spMin,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                //   border: Border.all(color: colors.divider),
                // ),
                child: TextField(
                  controller: _promoController,

                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Enter promo code',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14.spMin,
                      vertical: 16.spMin,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: colors.textHint,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.spMin),
            GestureDetector(
              onTap: state.isValidatingPromo
                  ? null
                  : () {
                      final code = _promoController.text.trim();
                      if (code.isNotEmpty) {
                        context.read<CartBloc>().add(ApplyPromoCodeEvent(code));
                      }
                    },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.spMin,
                  vertical: 12.spMin,
                ),
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: state.isValidatingPromo
                    ? SizedBox(
                        width: 18.spMin,
                        height: 18.spMin,
                        child: CircularProgressIndicator(
                          color: colors.scaffoldBackground,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Apply',
                        style: AppTextStyles.buttonMedium.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
        if (state.promoError != null) ...[
          SizedBox(height: 4.spMin),
          Text(
            state.promoError!,
            style: AppTextStyles.bodySmall.copyWith(color: colors.error),
          ),
        ],
      ],
    );
  }
}
