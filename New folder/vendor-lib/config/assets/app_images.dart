/// App image assets paths for the Food Delivery App
class AppImages {
  AppImages._();

  // ============== Base Path ==============
  static const String _basePath = 'assets';
  static const String _onboardingPath = '$_basePath/onborading';

  // ============== Food Images ==============
  static const String hamburger =
      '$_basePath/hamburger-with-beef-cheese-and-vegetables-on-a.png';
  static const String fastFoodIcon = '$_basePath/fast-food_9718703.png';
  static const String fastFoodSet =
      '$_basePath/fast-food-icon-set-design-for-fast-food.png';
  static const String fastFoodDelivery =
      '$_basePath/fast-food-icon-set-design-for-fast-food-delivery.png';
  static const String lunchBag =
      '$_basePath/brown-paper-bag-lunch-with-sandwich-and-juice-box.png';
  static const String latinFood = '$_basePath/latin-american-food.png';
  static const String latinFastFood =
      '$_basePath/latin-american-food-fast-food.png';
  static const String healthySandwich =
      '$_basePath/minimalist-healthy-lunch-sandwich-with-salad.png';

  // ============== Food Icons ==============
  static const String hamburgerIcon = '$_basePath/icons-hamburger.png';
  static const String iceCreamIcon = '$_basePath/icons-ice-cream.png';
  static const String noodlesIcon = '$_basePath/icons-noodles.png';
  static const String pizzaIcon = '$_basePath/icons-pizza.png';
  static const String homeIcon = '$_basePath/icons-home.png';
  static const String shopIcon = '$_basePath/icons-shop.png';
  static const String clockIcon = '$_basePath/icons-clock.png';
  static const String deliveryIcon = '$_basePath/icons-delivery.png';

  // ============== Screen Specific Images ==============

  // Splash Screen
  static const String splashLogo = fastFoodIcon;

  // Onboarding Screen 1 - Food Discovery
  static const String onboarding1 = '$_onboardingPath/1.jpg';

  // Onboarding Screen 2 - Fast Delivery
  static const String onboarding2 = '$_onboardingPath/2.jpg';

  // Onboarding Screen 3 - Get Started
  static const String onboarding3Main = '$_onboardingPath/3.png';
  static const String onboarding4 = '$_onboardingPath/4.png';
  static const String onboarding5 = '$_onboardingPath/5.jpg';
  static const String onboarding6 = '$_onboardingPath/6.jpg';
  static const String onboarding3Card1 = latinFood;
  static const String onboarding3Card2 = healthySandwich;

  // ============== Food Icon Images (bg_container) ==============
  static const String _foodIconPath = '$_basePath/food_icon';
  static const List<String> foodIconImages = [
    '$_foodIconPath/icons8-cheese-100.png',
    '$_foodIconPath/icons8-cheese-100 (1).png',
    '$_foodIconPath/icons8-dumplings-100.png',
    '$_foodIconPath/icons8-cherry-100.png',
    '$_foodIconPath/icons8-fish-and-chips-100.png',
    '$_foodIconPath/icons8-food-and-wine-100.png',
    '$_foodIconPath/icons8-guacamole-100.png',
    '$_foodIconPath/icons8-noodles-100.png',
    '$_foodIconPath/icons8-rice-bowl-100.png',
    '$_foodIconPath/icons8-paella-100.png',
    '$_foodIconPath/icons8-spaghetti-100.png',
    '$_foodIconPath/icons8-sandwich-with-fried-egg-100.png',
    '$_foodIconPath/icons8-sushi-100.png',
    '$_foodIconPath/icons8-salami-pizza-100.png',
    '$_foodIconPath/icons8-cola-100.png',
    '$_foodIconPath/icons8-mulled-wine-100.png',
    '$_foodIconPath/icons8-hamburger-100.png',
    '$_foodIconPath/icons8-pizza-five-eighths-100.png',
    '$_foodIconPath/icons8-street-food-100.png',
    '$_foodIconPath/icons8-mushroom-100.png',
    '$_foodIconPath/icons8-steak-100.png',
    '$_foodIconPath/icons8-poultry-leg-100.png',
    '$_foodIconPath/icons8-cup-67.png',
  ];

  // ============== Placeholder Images ==============
  static const String placeholder = fastFoodIcon;
  static const String errorImage = fastFoodIcon;

  // ============== Category Images ==============
  static const String categoryBurger = hamburger;
  static const String categoryLatin = latinFood;
  static const String categoryHealthy = healthySandwich;
  static const String categoryFastFood = fastFoodSet;
}
