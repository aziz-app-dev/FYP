import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/cart/cart_model.dart';
import '../../../repo/user/cart/cart_repo.dart';
import '../../../repo/user/offer/offer_repo.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;
  final OfferRepo _offerRepo;

  CartBloc({
    required CartRepository cartRepository,
    required OfferRepo offerRepo,
  })  : _cartRepository = cartRepository,
        _offerRepo = offerRepo,
        super(const CartState()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<IncrementQuantityEvent>(_onIncrementQuantity);
    on<DecrementQuantityEvent>(_onDecrementQuantity);
    on<ClearCartEvent>(_onClearCart);
    on<UpdateDeliveryFeeEvent>(_onUpdateDeliveryFee);
    on<UpdateTaxRateEvent>(_onUpdateTaxRate);
    on<ApplyPromoCodeEvent>(_onApplyPromoCode);
    on<RemovePromoCodeEvent>(_onRemovePromoCode);
    on<SelectPaymentMethodEvent>(_onSelectPaymentMethod);
    on<SelectDeliveryAddressEvent>(_onSelectDeliveryAddress);
    on<RefreshCartCountEvent>(_onRefreshCartCount);
  }

  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading, clearError: true));

    try {
      final items = await _cartRepository.fetchCart();
      final summary = CartSummary.calculate(
        items: items,
        deliveryFee: state.deliveryFee,
        taxRate: state.taxRate,
        discount: state.discount,
        promoCode: state.promoCode,
      );

      emit(
        state.copyWith(
          status: CartStatus.loaded,
          items: items,
          summary: summary,
          cartCount: items.length,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: CartStatus.error, error: e.toString()));
    }
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(isAddingToCart: true, clearError: true));

    try {
      final count = await _cartRepository.addToCart(event.request);
      emit(state.copyWith(isAddingToCart: false, cartCount: count));

      // Reload cart to get updated items
      add(const LoadCartEvent());
    } catch (e) {
      emit(state.copyWith(isAddingToCart: false, error: e.toString()));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCartEvent event,
    Emitter<CartState> emit,
  ) async {
    // Optimistic update: remove item locally first
    final previousItems = state.items;
    final updatedItems = state.items
        .where((item) => item.id != event.cartItemId)
        .toList();

    final summary = CartSummary.calculate(
      items: updatedItems,
      deliveryFee: state.deliveryFee,
      taxRate: state.taxRate,
      discount: state.discount,
      promoCode: state.promoCode,
    );

    emit(state.copyWith(
      items: updatedItems,
      summary: summary,
      cartCount: updatedItems.length,
    ));

    // Sync with backend in background
    try {
      await _cartRepository.removeFromCart(event.cartItemId);
    } catch (_) {
      // Revert on failure
      final revertSummary = CartSummary.calculate(
        items: previousItems,
        deliveryFee: state.deliveryFee,
        taxRate: state.taxRate,
        discount: state.discount,
        promoCode: state.promoCode,
      );
      emit(state.copyWith(
        items: previousItems,
        summary: revertSummary,
        cartCount: previousItems.length,
      ));
    }
  }

  Future<void> _onIncrementQuantity(
    IncrementQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    // Enforce max quantity limit
    if (event.item.isAtMaxQuantity) return;

    // Optimistic update: update locally first
    final updatedItems = state.items.map((item) {
      if (item.id == event.item.id) {
        return item.copyWithQuantity(item.quantity + 1);
      }
      return item;
    }).toList();

    final summary = CartSummary.calculate(
      items: updatedItems,
      deliveryFee: state.deliveryFee,
      taxRate: state.taxRate,
      discount: state.discount,
      promoCode: state.promoCode,
    );

    emit(state.copyWith(items: updatedItems, summary: summary));

    // Sync with backend in background
    try {
      final request = AddToCartRequest(
        productId: event.item.productId,
        quantity: 1,
        totalPrice: event.item.unitPrice,
        additives: event.item.additives,
        instructions: event.item.instructions,
      );
      await _cartRepository.addToCart(request);
    } catch (_) {
      // Revert on failure — reload from server
      add(const LoadCartEvent());
    }
  }

  Future<void> _onDecrementQuantity(
    DecrementQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    // Optimistic update: update locally first
    final updatedItems = state.items.map((item) {
      if (item.id == event.item.id) {
        return item.copyWithQuantity(item.quantity - 1);
      }
      return item;
    }).toList();

    // Remove items with 0 quantity
    updatedItems.removeWhere((item) => item.quantity <= 0);

    final summary = CartSummary.calculate(
      items: updatedItems,
      deliveryFee: state.deliveryFee,
      taxRate: state.taxRate,
      discount: state.discount,
      promoCode: state.promoCode,
    );

    emit(state.copyWith(
      items: updatedItems,
      summary: summary,
      cartCount: updatedItems.length,
    ));

    // Sync with backend in background
    try {
      await _cartRepository.decrementQuantity(event.item.productId);
    } catch (_) {
      // Revert on failure — reload from server
      add(const LoadCartEvent());
    }
  }

  Future<void> _onClearCart(
    ClearCartEvent event,
    Emitter<CartState> emit,
  ) async {
    // Optimistic: clear items locally first for instant UI feedback
    final previousItems = state.items;

    emit(state.copyWith(
      status: CartStatus.loaded,
      items: [],
      summary: const CartSummary(),
      cartCount: 0,
      clearPromoCode: true,
      discount: 0,
    ));

    // Sync with backend in background
    try {
      await _cartRepository.clearCart();
    } catch (_) {
      // Revert on failure
      final revertSummary = CartSummary.calculate(
        items: previousItems,
        deliveryFee: state.deliveryFee,
        taxRate: state.taxRate,
      );
      emit(state.copyWith(
        items: previousItems,
        summary: revertSummary,
        cartCount: previousItems.length,
      ));
    }
  }

  void _onUpdateDeliveryFee(
    UpdateDeliveryFeeEvent event,
    Emitter<CartState> emit,
  ) {
    final summary = CartSummary.calculate(
      items: state.items,
      deliveryFee: event.deliveryFee,
      taxRate: state.taxRate,
      discount: state.discount,
      promoCode: state.promoCode,
    );

    emit(state.copyWith(deliveryFee: event.deliveryFee, summary: summary));
  }

  void _onUpdateTaxRate(UpdateTaxRateEvent event, Emitter<CartState> emit) {
    final summary = CartSummary.calculate(
      items: state.items,
      deliveryFee: state.deliveryFee,
      taxRate: event.taxRate,
      discount: state.discount,
      promoCode: state.promoCode,
    );

    emit(state.copyWith(taxRate: event.taxRate, summary: summary));
  }

  Future<void> _onApplyPromoCode(
    ApplyPromoCodeEvent event,
    Emitter<CartState> emit,
  ) async {
    if (event.promoCode.isEmpty) return;

    emit(state.copyWith(
      isValidatingPromo: true,
      clearPromoError: true,
    ));

    try {
      final result = await _offerRepo.validatePromoCode(
        promoCode: event.promoCode,
        orderAmount: state.subtotal,
      );

      final discountAmount = (result['discountAmount'] as num?)?.toDouble() ?? 0;

      final summary = CartSummary.calculate(
        items: state.items,
        deliveryFee: state.deliveryFee,
        taxRate: state.taxRate,
        discount: discountAmount,
        promoCode: event.promoCode,
      );

      emit(state.copyWith(
        isValidatingPromo: false,
        promoCode: event.promoCode,
        discount: discountAmount,
        summary: summary,
      ));
    } catch (e) {
      emit(state.copyWith(
        isValidatingPromo: false,
        promoError: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  void _onRemovePromoCode(RemovePromoCodeEvent event, Emitter<CartState> emit) {
    final summary = CartSummary.calculate(
      items: state.items,
      deliveryFee: state.deliveryFee,
      taxRate: state.taxRate,
      discount: 0,
      promoCode: null,
    );

    emit(state.copyWith(clearPromoCode: true, discount: 0, summary: summary));
  }

  void _onSelectPaymentMethod(
    SelectPaymentMethodEvent event,
    Emitter<CartState> emit,
  ) {
    emit(state.copyWith(selectedPaymentMethod: event.paymentMethod));
  }

  void _onSelectDeliveryAddress(
    SelectDeliveryAddressEvent event,
    Emitter<CartState> emit,
  ) {
    emit(state.copyWith(selectedAddressId: event.addressId));
  }

  Future<void> _onRefreshCartCount(
    RefreshCartCountEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      final count = await _cartRepository.getCartCount();
      emit(state.copyWith(cartCount: count));
    } catch (_) {
      // Silently fail for cart count refresh
    }
  }
}
