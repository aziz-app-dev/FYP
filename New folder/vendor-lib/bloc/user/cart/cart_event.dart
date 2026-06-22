import 'package:equatable/equatable.dart';
import '../../../model/cart/cart_model.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

/// Load cart items
class LoadCartEvent extends CartEvent {
  const LoadCartEvent();
}

/// Add item to cart
class AddToCartEvent extends CartEvent {
  final AddToCartRequest request;

  const AddToCartEvent(this.request);

  @override
  List<Object?> get props => [request];
}

/// Remove item from cart
class RemoveFromCartEvent extends CartEvent {
  final String cartItemId;

  const RemoveFromCartEvent(this.cartItemId);

  @override
  List<Object?> get props => [cartItemId];
}

/// Increment item quantity
class IncrementQuantityEvent extends CartEvent {
  final CartItem item;

  const IncrementQuantityEvent(this.item);

  @override
  List<Object?> get props => [item];
}

/// Decrement item quantity
class DecrementQuantityEvent extends CartEvent {
  final CartItem item;

  const DecrementQuantityEvent(this.item);

  @override
  List<Object?> get props => [item];
}

/// Clear cart
class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}

/// Update delivery fee
class UpdateDeliveryFeeEvent extends CartEvent {
  final double deliveryFee;

  const UpdateDeliveryFeeEvent(this.deliveryFee);

  @override
  List<Object?> get props => [deliveryFee];
}

/// Update tax rate
class UpdateTaxRateEvent extends CartEvent {
  final double taxRate;

  const UpdateTaxRateEvent(this.taxRate);

  @override
  List<Object?> get props => [taxRate];
}

/// Apply promo code
class ApplyPromoCodeEvent extends CartEvent {
  final String promoCode;

  const ApplyPromoCodeEvent(this.promoCode);

  @override
  List<Object?> get props => [promoCode];
}

/// Remove promo code
class RemovePromoCodeEvent extends CartEvent {
  const RemovePromoCodeEvent();
}

/// Select payment method
class SelectPaymentMethodEvent extends CartEvent {
  final String paymentMethod;

  const SelectPaymentMethodEvent(this.paymentMethod);

  @override
  List<Object?> get props => [paymentMethod];
}

/// Select delivery address
class SelectDeliveryAddressEvent extends CartEvent {
  final String addressId;

  const SelectDeliveryAddressEvent(this.addressId);

  @override
  List<Object?> get props => [addressId];
}

/// Refresh cart count
class RefreshCartCountEvent extends CartEvent {
  const RefreshCartCountEvent();
}
