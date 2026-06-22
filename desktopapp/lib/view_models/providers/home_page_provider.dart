import '../states/home_page_state.dart';
import '../services/database/database_services.dart';
import 'package:riverpod/legacy.dart';

class HomePageNotifier extends StateNotifier<HomePageState> {
  final DatabaseService _dbService;

  HomePageNotifier(this._dbService) : super(const HomePageState()) {
    loadProducts();
    loadBrands();
    loadCategories();
  }

  // Load brands from database (only those with products)
  Future<void> loadBrands() async {
    try {
      final brands = await _dbService.getBrands();
      final products = await _dbService.getProducts();

      // Get brand names that have at least one product
      final brandsWithProducts = products
          .where((p) => p.brand != null && p.brand!.isNotEmpty)
          .map((p) => p.brand!)
          .toSet();

      // Filter brands to only include those with products and deduplicate by name
      final seenBrandNames = <String>{};
      final filteredBrands = brands
          .where((brand) => brandsWithProducts.contains(brand.name))
          .where((brand) => seenBrandNames.add(brand.name)) // Returns false if already in set
          .toList();

      state = state.copyWith(brands: filteredBrands, brandsLoading: false);
    } catch (e) {
      state = state.copyWith(brandsLoading: false);
    }
  }

  // Load categories from database (only those with products)
  Future<void> loadCategories() async {
    try {
      final categories = await _dbService.getCategories();
      final products = await _dbService.getProducts();

      // Get category names that have at least one product
      final categoriesWithProducts = products
          .where((p) => p.category != null && p.category!.isNotEmpty)
          .map((p) => p.category!)
          .toSet();

      // Filter categories to only include those with products and deduplicate by name
      final seenCategoryNames = <String>{};
      final filteredCategories = categories
          .where((category) => categoriesWithProducts.contains(category.name))
          .where((category) => seenCategoryNames.add(category.name)) // Returns false if already in set
          .toList();

      state = state.copyWith(categories: filteredCategories, categoriesLoading: false);
    } catch (e) {
      state = state.copyWith(categoriesLoading: false);
    }
  }

  // Load products from database
  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final products = await _dbService.getProducts();
      final bills = await _dbService.getBills();

      // Calculate product sales from bills
      final Map<String, int> productSalesCount = {};
      for (final bill in bills) {
        for (final entry in bill.quantities.entries) {
          final productId = entry.key;
          final quantity = entry.value;
          productSalesCount[productId] =
              (productSalesCount[productId] ?? 0) + quantity;
        }
      }

      // Get top selling products (top 10)
      final topSelling = [...products]..sort((a, b) {
        final aSales = productSalesCount[a.id] ?? 0;
        final bSales = productSalesCount[b.id] ?? 0;
        return bSales.compareTo(aSales);
      });
      final topSellingProducts = topSelling.take(10).toList();

      // Get latest items (non-services, sorted by createdAt)
      final latestItems =
          products.where((p) => !p.isService).toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      final latest10Items = latestItems.take(10).toList();

      // Get latest services (sorted by createdAt)
      final latestServices =
          products.where((p) => p.isService).toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      final latest10Services = latestServices.take(10).toList();

      // Get low stock items (stock < 10 and not services)
      final lowStockItems =
          products
              .where(
                (p) =>
                    !p.isService &&
                    p.stock != null &&
                    p.stock! < 10 &&
                    p.stock! > 0,
              )
              .toList()
            ..sort((a, b) => (a.stock ?? 0).compareTo(b.stock ?? 0));

      state = state.copyWith(
        products: products,
        topSellingProducts: topSellingProducts,
        latestItems: latest10Items,
        latestServices: latest10Services,
        lowStockItems: lowStockItems,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Refresh products
  Future<void> refreshProducts() async {
    await loadProducts();
    await loadBrands();
    await loadCategories();
  }
}

// Provider
final homePageProvider =
    StateNotifierProvider.autoDispose<HomePageNotifier, HomePageState>(
      (ref) => HomePageNotifier(DatabaseService()),
    );
