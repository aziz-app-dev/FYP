const Category = require("../models/category");
const Restaurantes = require("../models/restaurant");
const Food = require("../models/food");
const Cart = require("../models/cart");
const User = require("../models/user");
const Address = require("../models/address");
const Settings = require("../models/settings");

module.exports = {
  getHomeData: async (req, res) => {
    try {
      // Always fetch public data (no auth needed)
      const categoriesPromise = Category.find(
        { title: { $ne: "More" } },
        { __v: 0 }
      );

      // Restaurants: check single mode
      const restaurantsPromise = (async () => {
        const settings = await Settings.findOne();
        if (
          settings &&
          settings.serviceMode === "single" &&
          settings.defaultRestaurantId
        ) {
          const restaurant = await Restaurantes.findById(
            settings.defaultRestaurantId,
            { __v: 0 }
          );
          return restaurant ? [restaurant] : [];
        }
        // Multi-vendor mode
        let restaurants = await Restaurantes.aggregate([
          { $match: { code: "lahr" } },
          { $sample: { size: 5 } },
          { $project: { __v: 0 } },
        ]);
        if (!restaurants.length) {
          restaurants = await Restaurantes.aggregate([
            { $sample: { size: 5 } },
            { $project: { __v: 0 } },
          ]);
        }
        return restaurants;
      })();

      const foodsPromise = Food.aggregate([
        { $match: { code: "123456" } },
        { $sample: { size: 5 } },
        { $project: { __v: 0 } },
      ]);

      // If user is authenticated, also fetch user-specific data
      let userPromise = Promise.resolve(null);
      let cartCountPromise = Promise.resolve(0);
      let defaultAddressPromise = Promise.resolve(null);

      if (req.user) {
        const userId = req.user.id;

        userPromise = User.findById(
          userId,
          "-password -createdAt -updatedAt"
        ).populate("address");

        cartCountPromise = Cart.countDocuments({ userId: userId });

        defaultAddressPromise = Address.findOne({
          userId: userId,
          default: true,
        });
      }

      // Execute all queries in parallel
      const [categories, restaurants, foods, user, cartCount, defaultAddress] =
        await Promise.all([
          categoriesPromise,
          restaurantsPromise,
          foodsPromise,
          userPromise,
          cartCountPromise,
          defaultAddressPromise,
        ]);

      res.status(200).json({
        status: true,
        categories: categories,
        restaurants: restaurants,
        foods: foods,
        user: user,
        cartCount: cartCount,
        defaultAddress: defaultAddress,
      });
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },
};
