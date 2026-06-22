import 'package:equatable/equatable.dart';
import '../../../model/cart/cart_model.dart';

enum CartStatus {
  initial,
  loading,
  loaded,
  updating,
  error,
}

class CartState extends Equatable {
  final CartStatus status;
  final List<CartItem> items;
  final CartSummary summary;
  final int cartCount;
  final double deliveryFee;
  final double taxRate;
  final String? promoCode;
  final double discount;
  final String selectedPaymentMethod;
  final String? selectedAddressId;
  final String? error;
  final bool isAddingToCart;
  final bool isValidatingPromo;
  final String? promoError;

  const CartState({
    this.status = CartStatus.initial,
    this.items = const [],
    this.summary = const CartSummary(),
    this.cartCount = 0,
    this.deliveryFee = 0,
    this.taxRate = 0,
    this.promoCode,
    this.discount = 0,
    this.selectedPaymentMethod = 'cash',
    this.selectedAddressId,
    this.error,
    this.isAddingToCart = false,
    this.isValidatingPromo = false,
    this.promoError,
  });

  /// Check if cart is empty
  bool get isEmpty => items.isEmpty;

  /// Check if cart has items
  bool get isNotEmpty => items.isNotEmpty;

  /// Get subtotal
  double get subtotal =>
      items.fold<double>(0, (sum, item) => sum + item.totalPrice);

  /// Get tax amount
  double get taxAmount => subtotal * (taxRate / 100);

  /// Get total
  double get total {
    final t = subtotal + deliveryFee + taxAmount - discount;
    return t > 0 ? t : 0;
  }

  /// Get total items count
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({
    CartStatus? status,
    List<CartItem>? items,
    CartSummary? summary,
    int? cartCount,
    double? deliveryFee,
    double? taxRate,
    String? promoCode,
    double? discount,
    String? selectedPaymentMethod,
    String? selectedAddressId,
    String? error,
    bool? isAddingToCart,
    bool? isValidatingPromo,
    String? promoError,
    bool clearPromoCode = false,
    bool clearError = false,
    bool clearPromoError = false,
  }) {
    return CartState(
      status: status ?? this.status,
      items: items ?? this.items,
      summary: summary ?? this.summary,
      cartCount: cartCount ?? this.cartCount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      taxRate: taxRate ?? this.taxRate,
      promoCode: clearPromoCode ? null : promoCode ?? this.promoCode,
      discount: discount ?? this.discount,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      selectedAddressId: selectedAddressId ?? this.selectedAddressId,
      error: clearError ? null : error ?? this.error,
      isAddingToCart: isAddingToCart ?? this.isAddingToCart,
      isValidatingPromo: isValidatingPromo ?? this.isValidatingPromo,
      promoError: clearPromoError ? null : promoError ?? this.promoError,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        summary,
        cartCount,
        deliveryFee,
        taxRate,
        promoCode,
        discount,
        selectedPaymentMethod,
        selectedAddressId,
        error,
        isAddingToCart,
        isValidatingPromo,
        promoError,
      ];
}
