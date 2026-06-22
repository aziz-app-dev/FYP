import 'package:desktopapp/res/components/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:desktopapp/res/colors/app_color.dart';

import '../../res/assets/image_assets.dart';
import '../../res/components/app_icon.dart';
import 'add_product_view.dart';

class ProductTypeSelectionScreen extends StatefulWidget {
  final String? initialName;

  const ProductTypeSelectionScreen({super.key, this.initialName});

  @override
  State<ProductTypeSelectionScreen> createState() =>
      _ProductTypeSelectionScreenState();
}

class _ProductTypeSelectionScreenState
    extends State<ProductTypeSelectionScreen> {
  void _onTypeSelected(bool isService) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductScreen(
          isService: isService,
          initialName: widget.initialName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.customAppBar(
        title: "Select Item Type",
        context: context,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTypeCard(
                title: 'Services',
                win11IconPath: ImageAssets.win11Services,
                icon: Icons.build,
                isService: true,
              ),
              SizedBox(width: 20.w),
              _buildTypeCard(
                title: 'Items',
                win11IconPath: ImageAssets.win11OpenBox,
                icon: Icons.inventory,
                isService: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeCard({
    required String title,
    required String win11IconPath,
    required IconData icon,
    required bool isService,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTypeSelected(isService),
        child: Card(
          elevation: 6,
          shadowColor: Colors.black.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Container(
            height: 200.h,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.primary, width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppIcon(
                  win11IconPath: win11IconPath,
                  defaultIcon: icon,
                  size: 50.spMin,
                  color: AppColors.primary,
                ),
                SizedBox(height: 10.h),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.spMin,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
