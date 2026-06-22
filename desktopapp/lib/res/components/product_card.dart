// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../models/items/items_model.dart';

// class ProductCard extends StatelessWidget {
//   final Product product;
//   final VoidCallback? onTap;

//   const ProductCard({super.key, required this.product, this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(4),
//         child: Padding(
//           padding: EdgeInsets.all(6.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Center(
//                   child: Icon(
//                     Icons.shopping_bag,
//                     size: 20.spMin,
//                     color: Theme.of(context).primaryColor,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 4.h),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     product.name,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14.spMin,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   Text(
//                     '\$${product.price.toStringAsFixed(0)}',
//                     style: TextStyle(fontSize: 12.spMin, color: Colors.green),
//                   ),
//                 ],
//               ),
//               Text(
//                 'Stock: ${product.stock}',
//                 style: TextStyle(
//                   fontSize: 10.spMin,
//                   color: product.stock <= 5 ? Colors.red : Colors.grey,
//                 ),
//               ),
//               // Row(
//               //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               //   children: [
//               //     Text(
//               //       'Stock: ${product.stock}',
//               //       style: TextStyle(fontSize: 10.spMin, color: Colors.grey),
//               //     ),
//               //     const Spacer(),
//               //     if (product.stock <= 5)
//               //       Expanded(
//               //         child: Text(
//               //           'Low stock!',
//               //           style: TextStyle(fontSize: 10.spMin, color: Colors.red),
//               //           overflow: TextOverflow.ellipsis,
//               //         ),
//               //       ),
//               //   ],
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:desktopapp/res/colors/app_color.dart';
import 'package:desktopapp/res/components/app_text_widgrt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/items_model.dart';
import '../../models/brand_model.dart';
import '../../utils/app_sizes.dart';
import '../../view/product_details/product_details_view.dart';
import '../../view_models/providers/add_prduct_provider.dart';
import 'app_flushbar.dart';
import 'package:riverpod/legacy.dart';

// State class for ProductCard
class ProductCardState {
  final Brand? brand;
  final bool isLoadingBrand;
  final DateTime? lastTapTime;

  ProductCardState({this.brand, this.isLoadingBrand = false, this.lastTapTime});

  ProductCardState copyWith({
    Brand? brand,
    bool? isLoadingBrand,
    DateTime? lastTapTime,
  }) {
    return ProductCardState(
      brand: brand ?? this.brand,
      isLoadingBrand: isLoadingBrand ?? this.isLoadingBrand,
      lastTapTime: lastTapTime ?? this.lastTapTime,
    );
  }
}

// StateNotifier for ProductCard
class ProductCardNotifier extends StateNotifier<ProductCardState> {
  final Ref ref;
  final Product product;

  ProductCardNotifier(this.ref, this.product) : super(ProductCardState()) {
    _loadBrandData();
  }

  Future<void> _loadBrandData() async {
    if (product.brand != null && product.brand!.isNotEmpty) {
      state = state.copyWith(isLoadingBrand: true);
      try {
        final dbService = ref.read(databaseServiceProvider);
        final brands = await dbService.getBrands();
        final matchingBrand =
            brands.where((b) => b.name == product.brand).firstOrNull;
        state = state.copyWith(brand: matchingBrand, isLoadingBrand: false);
      } catch (e) {
        state = state.copyWith(isLoadingBrand: false);
      }
    }
  }

  void updateLastTapTime(DateTime? time) {
    state = state.copyWith(lastTapTime: time);
  }
}

class ProductCard extends ConsumerWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onDoubleTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Create a provider for this specific product
    final provider = StateNotifierProvider.autoDispose<
      ProductCardNotifier,
      ProductCardState
    >((ref) => ProductCardNotifier(ref, product));

    final cardState = ref.watch(provider);

    return Card(
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          color:
              (Theme.of(context).brightness == Brightness.dark
                  ? AppColors.dCardColor
                  : AppColors.lCardColor),
          borderRadius: BorderRadius.all(
            Radius.circular(AppSizes.borderRadiusSm.r),
          ),
        ),
        child: InkWell(
          onDoubleTap:
              onDoubleTap ??
              () async {
                final result = await Navigator.push<dynamic>(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ProductDetailsScreen(product: product),
                  ),
                );
                if (result is Map && result['success'] == true && context.mounted) {
                  AppFlushbar.success(
                    context,
                    message: result['message'] ?? 'Product updated successfully!',
                    duration: const Duration(seconds: 2),
                  );
                }
              },
          onTap: () async {
            final now = DateTime.now();

            if (cardState.lastTapTime != null &&
                now.difference(cardState.lastTapTime!) <
                    const Duration(milliseconds: 400)) {
              // Double tap detected
              ref.read(provider.notifier).updateLastTapTime(null);
              final result = await Navigator.push<dynamic>(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsScreen(product: product),
                ),
              );
              if (result is Map && result['success'] == true && context.mounted) {
                AppFlushbar.success(
                  context,
                  message: result['message'] ?? 'Product updated successfully!',
                  duration: const Duration(seconds: 2),
                );
              }
            } else {
              // Single tap
              ref.read(provider.notifier).updateLastTapTime(now);
              if (onTap != null) {
                onTap!();
              }
            }
          },
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    SizedBox(
                      height: 200.h,
                      child: Center(
                        child:
                            product.imageUrl != null &&
                                    product.imageUrl!.isNotEmpty
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.borderRadiusSm.r,
                                  ),
                                  child: Image.file(
                                    File(product.imageUrl!),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                          Icons.broken_image,
                                          size: 40.spMin,
                                          color: Colors.grey,
                                        ),
                                  ),
                                )
                                : Icon(
                                  Icons.shopping_bag,
                                  size: 35.spMin,
                                  color: Theme.of(context).primaryColor,
                                ),
                      ),
                    ),
                    // Brand Badge
                    if (cardState.brand != null &&
                        cardState.brand!.imageUrl != null &&
                        cardState.brand!.imageUrl!.isNotEmpty)
                      Positioned(
                        top: 6.h,
                        right: 6.w,
                        child: Container(
                          width: 32.h,
                          height: 32.h,
                          decoration: BoxDecoration(
                            // color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(3.h),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.r),
                            child: Image.file(
                              File(cardState.brand!.imageUrl!),
                              fit: BoxFit.contain,
                              errorBuilder:
                                  (context, error, stackTrace) => Icon(
                                    Icons.branding_watermark,
                                    size: 18.spMin,
                                    color: AppColors.primary,
                                  ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                child: Column(
                  spacing: 2.h,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    smTextBold(text: product.name, maxLines: 1),
                    Row(
                      spacing: 2.w,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        smText(
                          text: 'Rs.${product.price.toStringAsFixed(0)}',
                          color: AppColors.primary,
                        ),
                        product.isService
                            ? Flexible(
                              child: customText(
                                size: 8.spMin,
                                text: 'Services',
                                color:
                                    (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.grey300
                                        : AppColors.grey600),
                              ),
                            )
                            : Flexible(
                              child: customText(
                                size: 8.spMin,
                                text: 'Stock: ${product.stock ?? 0}',
                                color:
                                    (product.stock ?? 0) <= 5
                                        ? Colors.red
                                        : (Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.grey300
                                            : AppColors.grey600),
                              ),
                            ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
