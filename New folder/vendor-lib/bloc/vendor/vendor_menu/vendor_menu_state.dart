import 'package:equatable/equatable.dart';
import '../../../model/home/home_model.dart';

enum VendorMenuStatus { initial, loading, success, error }

class VendorMenuState extends Equatable {
  final VendorMenuStatus status;
  final List<FoodItem> menuItems;
  final String? errorMessage;
  final String? successMessage;

  const VendorMenuState({
    this.status = VendorMenuStatus.initial,
    this.menuItems = const [],
    this.errorMessage,
    this.successMessage,
  });

  bool get isLoading => status == VendorMenuStatus.loading;
  bool get hasError => status == VendorMenuStatus.error;

  /// Group items by category
  Map<String, List<FoodItem>> get itemsByCategory {
    final map = <String, List<FoodItem>>{};
    for (final item in menuItems) {
      final cat = item.category ?? 'Uncategorized';
      map.putIfAbsent(cat, () => []).add(item);
    }
    return map;
  }

  VendorMenuState copyWith({
    VendorMenuStatus? status,
    List<FoodItem>? menuItems,
    String? errorMessage,
    String? successMessage,
  }) {
    return VendorMenuState(
      status: status ?? this.status,
      menuItems: menuItems ?? this.menuItems,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [status, menuItems, errorMessage, successMessage];
}
