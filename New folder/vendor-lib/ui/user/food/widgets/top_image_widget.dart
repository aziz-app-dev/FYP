import '../../../../config/widgets/price_widget.dart';
import '../../../../utils/utils.dart';
import 'widgets.dart';

Widget _foodImageErrorWidget() {
  return Container(
    color: Colors.grey[300],
    child: Icon(Icons.fastfood, size: 60.spMin, color: Colors.grey),
  );
}

class OneImageWidget extends StatelessWidget {
  const OneImageWidget({super.key, required this.food});

  final FoodDetails? food;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(8.spMin),
          height: 380.spMin,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radius3Xxl),
            child: CachedNetworkImage(
              imageUrl: food!.imageUrl ?? '',
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(child: appLoader()),
              errorWidget: (_, _, _) => _foodImageErrorWidget(),
            ),
          ),
        ),
        Positioned(
          top: 16.spMin,
          left: 16.spMin,
          child: SafeArea(
            child: circulerBtnWidget(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.pop(context),
            ),
          ),
        ),
        Positioned(
          top: 16.spMin,
          right: 16.spMin,
          child: SafeArea(
            child: circulerBtnWidget(icon: Icons.favorite_border, onTap: () {}),
          ),
        ),
      ],
    );
  }
}

class OneImageWidget2 extends StatelessWidget {
  const OneImageWidget2({super.key, required this.food});

  final FoodDetails? food;

  @override
  Widget build(BuildContext context) {
    final isSmallMob = ScreenUtils.isSmallMob(context);
    final isTablet = ScreenUtils.isTablet(context);
    final isDesktop = ScreenUtils.isDesktop(context);
    final isMobile = !isTablet && !isDesktop;

    final imageHeight = isDesktop
        ? 590.spMin
        : isTablet
        ? 470.spMin
        : 410.spMin;

    final foodImgSize = isDesktop
        ? 340.spMin
        : isTablet
        ? 290.spMin
        : isSmallMob
        ? 200.spMin
        : 190.spMin;

    final arcDepth = isDesktop
        ? 130.0
        : isTablet
        ? 120.0
        : 70.spMin;

    final titleFontSize = isMobile && !isSmallMob ? 15.spMin : 20.spMin;
    final descFontSize = isSmallMob ? 12.spMin : 10.spMin;

    return Stack(
      children: [
        // Background + content
        ClipPath(
          clipper: BottomArcClipper(arcDepth: arcDepth),
          child: SizedBox(
            height: imageHeight,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  "assets/food_seamless_pattern.jpg",
                  fit: BoxFit.cover,
                ),
                const ColoredBox(color: Color.fromRGBO(0, 0, 0, 0.85)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title & description
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          // horizontal: 10.spMin,
                          vertical: 15.spMin,
                        ),
                        child: Column(
                          children: [
                            Text(
                              food?.title ?? '',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.headlineSmall.copyWith(
                                color: Colors.white,
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (food?.description != null) ...[
                              SizedBox(height: 4.spMin),
                              Text(
                                food!.description!,
                                textAlign: TextAlign.center,
                                maxLines: isSmallMob ? 2 : 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontSize: descFontSize,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    // Food image & price
                    Column(
                      spacing: 10.spMin,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusXxl,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: food?.imageUrl ?? '',
                            width: foodImgSize,
                            height: foodImgSize,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Center(child: appLoader()),
                            errorWidget: (_, _, _) => SizedBox(
                              width: foodImgSize,
                              height: foodImgSize,
                              child: _foodImageErrorWidget(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 25.spMin),
                          child: PriceText(
                            fontSize: isDesktop ? 22.spMin : 18.spMin,
                            price: food?.displayPrice ?? food?.price ?? 0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Quantity selector
        Positioned(
          left: 20.spMin,
          top: imageHeight * 0.40,
          child: BlocBuilder<FoodDetailsBloc, FoodDetailsState>(
            buildWhen: (prev, curr) => prev.quantity != curr.quantity,
            builder: (context, state) {
              return VerticalQuantitySelector(
                quantity: state.quantity,
                isAtMinQuantity: state.quantity <= state.minQuantity,
                isAtMaxQuantity: state.quantity >= state.maxQuantity,
              );
            },
          ),
        ),

        // Back button
        Positioned(
          top: 16.spMin,
          left: 16.spMin,
          child: SafeArea(
            child: circulerBtnWidget(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.pop(context),
            ),
          ),
        ),

        // Favorite button
        Positioned(
          top: 16.spMin,
          right: 16.spMin,
          child: SafeArea(
            child: circulerBtnWidget(icon: Icons.favorite_border, onTap: () {}),
          ),
        ),
      ],
    );
  }
}

class BottomArcClipper extends CustomClipper<Path> {
  const BottomArcClipper({this.arcDepth = 80});

  final double arcDepth;

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - arcDepth);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + arcDepth * 0.7,
      size.width,
      size.height - arcDepth,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant BottomArcClipper oldClipper) =>
      oldClipper.arcDepth != arcDepth;
}
