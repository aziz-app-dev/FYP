const Restaurantes = require("../models/restaurant");
const Settings = require("../models/settings");

module.exports = {
  //! Add restaurant
  addRestaurant: async (req, res) => {
    const { title, time, imagesUrl, owner, code, logoUrl, coords } = req.body;
  
    if (
      !title ||
      !time ||
      !imagesUrl ||
      !owner ||
      !code ||
      !logoUrl ||
      !coords ||
      !coords.latitude ||
      !coords.longitude ||
      !coords.title ||
      !coords.address
    ) {
      return res.status(400).json({
        status: false,
        message: "All fields (title, time, imagesUrl, owner, code, logoUrl, coords) are required"
      });
    }
  
    try {
      const newRestaurant = new Restaurantes(req.body);
      await newRestaurant.save();
      res.status(200).json({ status: true, message: "Restaurant successfully created!" });
    } catch (error) {
      res.status(500).json({ status: false, message: 
        " Error creating restaurant" 
      });
    }
  },
  

  //! change the availability of a restaurant
  restaurantAvailability: async (req, res) => {
    const restaurantId = req.params.id;
    try {
      const restaurant = await Restaurantes.findById(restaurantId);
      if (!restaurant) {
        res
          .status(403)
          .json({ status: false, message: "Restaurant not found" });
      }
      restaurant.isAvailable = !restaurant.isAvailable;
      await restaurant.save();
      res.status(200).json({
        status: true,
        message: "Availability successfully toggled",
        isAvailable: restaurant.isAvailable,
      });
    } catch (error) {
      res
        .status(500)
        .json({ status: false, message: "Error toggling restaurant" });
    }
  },

  //! Delete a restaurant

  deleteRestaurant: async (req, res) => {
    const restaurantId = req.params.id;

    try {
      const restaurant = await Restaurantes.findById(restaurantId);
      if (!restaurant) {
        res
          .status(403)
          .json({ status: false, message: "Restaurant not found" });
      }
      await Restaurantes.findByIdAndDelete(restaurantId);
      res
        .status(200)
        .json({ status: true, message: "Restaurant deleted successfully" });
    } catch (error) {
      res
        .status(500)
        .json({ status: false, message: "Error deleting restaurant" });
    }
  },
  // ! getRestaurant
  getRestaurantById: async (req, res) => {
    const restaurantId = req.params.id;

    try {
      // Check if single restaurant mode
      const settings = await Settings.findOne();
      if (settings && settings.serviceMode === "single" && settings.defaultRestaurantId) {
        if (restaurantId !== settings.defaultRestaurantId.toString()) {
          return res.status(403).json({
            status: false,
            message: "This restaurant is not available in single restaurant mode"
          });
        }
      }

      const restaurant = await Restaurantes.findById(restaurantId);
      if (!restaurant) {
        return res.status(404).json({ status: false, message: "No restaurant found." });
      }
      res.status(200).json(restaurant);
    } catch (error) {
      res.status(500).json({
        status: false,
        message: "Error to retrieve restaurant",
        error: error.message,
      });
    }
  }
,

  //!   Get random restaurant

  getRandomRestaurant: async (req, res) => {
    let randomRestaurant = [];
    try {
      // Check if single restaurant mode
      const settings = await Settings.findOne();
      if (settings && settings.serviceMode === "single" && settings.defaultRestaurantId) {
        const restaurant = await Restaurantes.findById(settings.defaultRestaurantId, { __v: 0 });
        if (restaurant) {
          return res.status(200).json([restaurant]);
        }
        return res.status(404).json({ status: false, message: "Default restaurant not found" });
      }

      // Multi-vendor mode
      const code = req.params.code;
      if (code) {
        randomRestaurant = await Restaurantes.aggregate([
          { $match: { code: code } },
          { $sample: { size: 5 } },
          { $project: { __v: 0 } },
        ]);
      }

      if (!randomRestaurant.length) {
        randomRestaurant = await Restaurantes.aggregate([
          { $sample: { size: 5 } },
          { $project: { __v: 0 } },
        ]);
      }

      if (randomRestaurant.length) {
        res.status(200).json(randomRestaurant);
      }
    } catch (error) {
      res.status(404).json({
        status: false,
        message: "Error to find restaurant",
        error: error.message,
      });
    }
  },
  // ! Get all nearByRestaurant
  getAllNearByRestaurant: async (req, res) => {
    let allNearByRestaurants = [];
    try {
      // Check if single restaurant mode
      const settings = await Settings.findOne();
      if (settings && settings.serviceMode === "single" && settings.defaultRestaurantId) {
        const restaurant = await Restaurantes.findById(settings.defaultRestaurantId, { __v: 0 });
        if (restaurant) {
          return res.status(200).json([restaurant]);
        }
        return res.status(404).json({ status: false, message: "Default restaurant not found" });
      }

      // Multi-vendor mode
      const code = req.params.code;
      if (code) {
        allNearByRestaurants = await Restaurantes.aggregate([
          { $match: { code: code } },
          { $project: { __v: 0 } },
        ]);
      }

      if (!allNearByRestaurants.length) {
        allNearByRestaurants = await Restaurantes.aggregate([
          { $project: { __v: 0 } },
        ]);
      }

      if (allNearByRestaurants.length) {
        res.status(200).json(allNearByRestaurants);
      }
    } catch (error) {
      res.status(404).json({
        status: false,
        message: "Error to find restaurant",
        error: error.message,
      });
    }
  },

  //! Get default/active restaurant (useful for single mode)
  getDefaultRestaurant: async (req, res) => {
    try {
      const settings = await Settings.findOne();

      // In single mode, return the default restaurant
      if (settings && settings.serviceMode === "single" && settings.defaultRestaurantId) {
        const restaurant = await Restaurantes.findById(settings.defaultRestaurantId, { __v: 0 });
        if (restaurant) {
          return res.status(200).json({
            status: true,
            serviceMode: "single",
            restaurant: restaurant
          });
        }
        return res.status(404).json({ status: false, message: "Default restaurant not found" });
      }

      // In multi-vendor mode, return info that it's multi-vendor
      return res.status(200).json({
        status: true,
        serviceMode: "multi-vendor",
        message: "App is in multi-vendor mode. Use other endpoints to get restaurants."
      });
    } catch (error) {
      res.status(500).json({
        status: false,
        message: "Error getting default restaurant",
        error: error.message,
      });
    }
  },

  //! Get all restaurants (Admin only - for selecting default restaurant)
  getAllRestaurantsAdmin: async (req, res) => {
    try {
      const restaurants = await Restaurantes.find({}, { __v: 0 }).sort({ createdAt: -1 });
      res.status(200).json({
        status: true,
        count: restaurants.length,
        restaurants: restaurants
      });
    } catch (error) {
      res.status(500).json({
        status: false,
        message: "Error fetching restaurants",
        error: error.message,
      });
    }
  }
};
