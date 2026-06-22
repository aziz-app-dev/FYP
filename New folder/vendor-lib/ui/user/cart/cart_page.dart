import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../bloc/user/cart/cart_bloc.dart';
import '../../../bloc/user/cart/cart_event.dart';
import '../../../bloc/user/cart/cart_state.dart';
import '../../../bloc/user/main/main_bloc.dart';
import '../../../bloc/user/main/main_state.dart';
import '../../../di/service_locator.dart';
import '../../../config/config.dart';
import '../../../config/widgets/app_bar.dart';
import '../../../config/widgets/error_widget.dart';
import '../../../config/widgets/app_result_dialog.dart';
import '../../../config/widgets/screen_wapper.dart';
import '../../../model/cart/cart_model.dart';
import '../../../routes/route_name.dart';
import '../../../services/session/session_manger.dart';
import '../../../utils/toast_utils.dart';
import 'widgets/items_widget.dart';
import 'widgets/place_order_widget.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late CartBloc _cartBloc;
  final SessionManager _sessionManager = SessionManager();
  final _listKey = GlobalKey<SliverAnimatedListState>();
  List<CartItem> _animatedItems = [];
  final Set<String> _pendingRemovals = {};

  @override
  void initState() {
    super.initState();
    _cartBloc = getIt<CartBloc>();
    _animatedItems = List.from(_cartBloc.state.items);

    // Load settings and cart
    _initializeCart();
  }

  Future<void> _initializeCart() async {
    await _sessionManager.loadSettings();

    // Set delivery fee and tax rate from settings
    final settings = _sessionManager.settings;
    if (settings != null) {
      _cartBloc.add(UpdateDeliveryFeeEvent(settings.deliveryFee ?? 0));
      _cartBloc.add(UpdateTaxRateEvent(settings.taxRate ?? 0));

      // Set default payment method
      final defaultMethod = settings.defaultPaymentMethod;
      _cartBloc.add(SelectPaymentMethodEvent(defaultMethod));
    }

    // Cart items are loaded via BlocListener<MainBloc> when cart tab becomes active
  }

  @override
  void dispose() {
    _cartBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocListener<MainBloc, MainState>(
      listenWhen: (prev, curr) =>
          prev.selectedIndex != curr.selectedIndex && curr.selectedIndex == 2,
      listener: (context, state) {
        _cartBloc.add(const LoadCartEvent());
      },
      child: BlocProvider.value(
        value: _cartBloc,
        child: BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {
            if (state.status == CartStatus.loaded) {
              _syncAnimatedList(state.items);
            }
          },
          builder: (context, state) {
            final isLoading = state.status == CartStatus.loading;
            final hasError = state.status == CartStatus.error;
            final isEmpty = !isLoading && !hasError && state.items.isEmpty;

            return ScreenWrapper(
              useMobileScaffold: true,
              mobileHeader: CustomHeader(
                title: 'My Cart',
                showBackButton: false,
                verticalPadding: HeaderVerticalPadding.bottom,
                action: state.items.isNotEmpty
                    ? GestureDetector(
                        onTap: () => _showClearCartDialog(context),
                        child: Padding(
                          padding: EdgeInsets.all(4.spMin),
                          child: Icon(
                            Icons.delete_sweep_outlined,
                            size: 22.spMin,
                          ),
                        ),
                      )
                    : null,
              ),
              isLoading: isLoading,
              hasError: hasError,
              isNetworkError: isNetworkError(state.error),
              errorTitle: 'Failed to load cart',
              errorMessage: state.error ?? 'Something went wrong',
              onRetry: () => _cartBloc.add(const LoadCartEvent()),
              isEmpty: isEmpty,
              emptyTitle: 'Your Cart is Empty',
              emptyMessage: 'Add items to get started',
              emptyLottie: 'assets/lottie/Shopping Cart.json',
              emptyIcon: Icons.shopping_cart_outlined,
              mobile: _buildCartContent(context, state, colors),
            );
          },
        ),
      ),
    );
  }

  // ─── AnimatedList Sync ─────────────────────────────────────────

  void _syncAnimatedList(List<CartItem> newItems) {
    final listState = _listKey.currentState;
    if (listState == null) {
      _pendingRemovals.clear();
      _animatedItems = List.from(newItems);
      return;
    }

    // Filter out items pending local removal (avoids re-inserting
    // items that we already animated out but BLoC hasn't confirmed yet)
    final effectiveItems = newItems
        .where((e) => !_pendingRemovals.contains(e.id))
        .toList();

    // Detect removals (reverse to keep indices valid)
    for (int i = _animatedItems.length - 1; i >= 0; i--) {
      if (!effectiveItems.any((e) => e.id == _animatedItems[i].id)) {
        final removed = _animatedItems.removeAt(i);
        listState.removeItem(
          i,
          (context, animation) => _buildRemovedItem(removed, animation),
          duration: const Duration(milliseconds: 400),
        );
      }
    }

    // Detect additions
    for (int i = 0; i < effectiveItems.length; i++) {
      if (!_animatedItems.any((e) => e.id == effectiveItems[i].id)) {
        _animatedItems.insert(i, effectiveItems[i]);
        listState.insertItem(i, duration: const Duration(milliseconds: 300));
      }
    }

    // Clear confirmed pending removals (item no longer in server state)
    _pendingRemovals.removeWhere((id) => !newItems.any((e) => e.id == id));

    // Update data for existing items (quantity / price changes)
    _animatedItems = List.from(effectiveItems);
  }

  void _deleteWithAnimation(CartItem item) {
    final index = _animatedItems.indexWhere((e) => e.id == item.id);
    if (index == -1) return;

    _pendingRemovals.add(item.id);
    final removed = _animatedItems.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildRemovedItem(removed, animation),
      duration: const Duration(milliseconds: 400),
    );
    _cartBloc.add(RemoveFromCartEvent(item.id));
  }

  void _onItemDismissed(CartItem item) {
    final index = _animatedItems.indexWhere((e) => e.id == item.id);
    if (index == -1) {
      // Already removed locally, just sync with backend
      _cartBloc.add(RemoveFromCartEvent(item.id));
      return;
    }

    _pendingRemovals.add(item.id);
    _animatedItems.removeAt(index);
    // Slidable already animated the dismiss — remove slot instantly
    _listKey.currentState?.removeItem(
      index,
      (_, _) => const SizedBox.shrink(),
      duration: Duration.zero,
    );
    _cartBloc.add(RemoveFromCartEvent(item.id));
  }

  // ─── Build Methods ─────────────────────────────────────────────

  Widget _buildCartContent(
    BuildContext context,
    CartState state,
    ThemeColors colors,
  ) {
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.spMin,
                  vertical: 12.spMin,
                ),
                sliver: SliverAnimatedList(
                  key: _listKey,
                  initialItemCount: _animatedItems.length,
                  itemBuilder: (context, index, animation) {
                    if (index >= _animatedItems.length) {
                      return const SizedBox.shrink();
                    }
                    return _buildAnimatedItem(_animatedItems[index], animation);
                  },
                ),
              ),
            ],
          ),
        ),
        CheckoutSection(
          state: state,
          settings: _sessionManager.settings,
          currencySymbol: _sessionManager.currencySymbol,
          onCheckout: () => _handleCheckout(context, state),
        ),
        SizedBox(height: keyboardOpen ? 16.spMin : 100.spMin),
      ],
    );
  }

  /// Entry animation — items fade + scale in
  Widget _buildAnimatedItem(CartItem item, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      ),
      child: FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn),
        child: Padding(
          padding: EdgeInsets.only(bottom: 6.spMin),
          child: CartItemWidget(
            item: item,
            currencySymbol: _sessionManager.currencySymbol,
            onDelete: () => _deleteWithAnimation(item),
            onDismissed: () => _onItemDismissed(item),
            onIncrement: () {
              if (item.isAtMaxQuantity) {
                ToastUtils.showWarning(
                  context,
                  message: 'Max ${item.maxQuantity} items allowed',
                );
                return;
              }
              _cartBloc.add(IncrementQuantityEvent(item));
            },
            onDecrement: () {
              if (item.quantity > 1) {
                _cartBloc.add(DecrementQuantityEvent(item));
              } else {
                _showRemoveItemDialog(item);
              }
            },
          ),
        ),
      ),
    );
  }

  /// Exit animation — slide left + fade out + collapse height
  Widget _buildRemovedItem(CartItem item, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
      child: FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(-1.5, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInBack),
              ),
          child: Padding(
            padding: EdgeInsets.only(bottom: 6.spMin),
            child: CartItemWidget(
              item: item,
              currencySymbol: _sessionManager.currencySymbol,
            ),
          ),
        ),
      ),
    );
  }

  // ─── Remove Single Item ────────────────────────────────────

  void _showRemoveItemDialog(CartItem item) {
    final colors = context.colors;
    AppResultDialog.show(
      context,
      icon: Icon(
        Icons.remove_shopping_cart_outlined,
        size: 48.spMin,
        color: colors.error,
      ),
      title: 'Remove Item',
      message: 'Remove "${item.displayName}" from your cart?',
      primaryLabel: 'Remove',
      onPrimary: () {
        Navigator.pop(context);
        _deleteWithAnimation(item);
      },
      secondaryLabel: 'Cancel',
      onSecondary: () => Navigator.pop(context),
    );
  }

  // ─── Clear All ─────────────────────────────────────────────

  void _showClearCartDialog(BuildContext context) {
    final colors = context.colors;
    AppResultDialog.show(
      context,
      icon: Icon(
        Icons.delete_sweep_outlined,
        size: 48.spMin,
        color: colors.error,
      ),
      title: 'Clear Cart',
      message: 'Are you sure you want to remove all items from your cart?',
      primaryLabel: 'Clear All',
      onPrimary: () {
        Navigator.pop(context);
        _clearAllWithAnimation();
      },
      secondaryLabel: 'Cancel',
      onSecondary: () => Navigator.pop(context),
    );
  }

  void _clearAllWithAnimation() {
    final listState = _listKey.currentState;
    if (listState == null) {
      _cartBloc.add(const ClearCartEvent());
      return;
    }

    // Animate all items out in reverse order with staggered delay
    for (int i = _animatedItems.length - 1; i >= 0; i--) {
      final removed = _animatedItems[i];
      _pendingRemovals.add(removed.id);
      listState.removeItem(
        i,
        (context, animation) => _buildRemovedItem(removed, animation),
        duration: const Duration(milliseconds: 300),
      );
    }
    _animatedItems.clear();
    _cartBloc.add(const ClearCartEvent());
  }

  // ─── Checkout ──────────────────────────────────────────────────

  void _handleCheckout(BuildContext context, CartState state) {
    // Validate address selection
    final defaultAddress = _sessionManager.displayAddress;
    if (defaultAddress == null) {
      ToastUtils.showError(
        context,
        message: 'Please add a delivery address first',
      );
      return;
    }

    // Navigate to checkout confirmation
    Navigator.pushNamed(
      context,
      RouteName.checkout,
      arguments: {
        'cartItems': state.items,
        'subtotal': state.subtotal,
        'deliveryFee': state.deliveryFee,
        'taxAmount': state.taxAmount,
        'discount': state.discount,
        'total': state.total,
        'paymentMethod': state.selectedPaymentMethod,
        'addressId': defaultAddress.id,
      },
    );
  }
}
