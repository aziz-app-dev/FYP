const Settings = require("../models/settings");
const Restaurantes = require("../models/restaurant");

// Default restaurant data for single mode when no restaurant exists
const DEFAULT_RESTAURANT = {
  title: "Default Restaurant",
  time: "30 min",
  imageUrl: "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800",
  logoUrl: "https://images.unsplash.com/photo-1567521464027-f127ff144326?w=200",
  owner: "admin",
  code: "00000",
  isAvailable: true,
  pickup: true,
  delivery: true,
  coords: {
    id: "default",
    latitude: 0,
    longitude: 0,
    latitudeDelta: 0.0221,
    longitudeDelta: 0.0221,
    address: "Default Address",
    title: "Default Location",
  },
};

module.exports = {
  //! Get current settings
  getSettings: async (req, res) => {
    try {
      let settings = await Settings.findOne();

      // If no settings exist, create default settings
      if (!settings) {
        settings = new Settings();
        await settings.save();
      }

      // Exclude internal fields from response
      const { _id, __v, updatedBy, ...settingsData } = settings._doc;

      res.status(200).json({ status: true, ...settingsData });
    } catch (error) {
      res.status(500).json({
        status: false,
        message: "Error fetching settings",
        error: error.message,
      });
    }
  },

  //! Update settings (Admin only)
  updateSettings: async (req, res) => {
    const {
      serviceMode,
      defaultRestaurantId,
      allowVendorRegistration,
      appName,
      currency,
      currencySymbol,
      deliveryFee,
      taxRate,
    } = req.body;

    try {
      let settings = await Settings.findOne();

      // If no settings exist, create new settings
      if (!settings) {
        settings = new Settings();
      }

      // Update only provided fields
      if (serviceMode !== undefined) {
        settings.serviceMode = serviceMode;
        // Auto-disable vendor registration in single mode
        if (serviceMode === "single") {
          settings.allowVendorRegistration = false;
        }
      }

      // Handle default restaurant for single mode
      if (defaultRestaurantId !== undefined) {
        settings.defaultRestaurantId = defaultRestaurantId;
      } else if (serviceMode === "single" && !settings.defaultRestaurantId) {
        // If switching to single mode without specifying a restaurant,
        // find existing restaurant or create default one
        let restaurant = await Restaurantes.findOne();

        if (!restaurant) {
          // Create default restaurant if none exists
          restaurant = new Restaurantes(DEFAULT_RESTAURANT);
          await restaurant.save();
        }

        settings.defaultRestaurantId = restaurant._id;
      }
      if (allowVendorRegistration !== undefined) {
        // Only allow enabling vendor registration in multi-vendor mode
        if (settings.serviceMode === "single" && allowVendorRegistration === true) {
          return res.status(400).json({
            status: false,
            message: "Cannot enable vendor registration in single restaurant mode",
          });
        }
        settings.allowVendorRegistration = allowVendorRegistration;
      }
      if (appName !== undefined) settings.appName = appName;
      if (currency !== undefined) settings.currency = currency;
      if (currencySymbol !== undefined) settings.currencySymbol = currencySymbol;
      if (deliveryFee !== undefined) settings.deliveryFee = deliveryFee;
      if (taxRate !== undefined) settings.taxRate = taxRate;

      // Track who updated
      settings.updatedBy = req.user.id;

      await settings.save();

      res.status(200).json({
        status: true,
        message: "Settings updated successfully",
        settings: {
          serviceMode: settings.serviceMode,
          defaultRestaurantId: settings.defaultRestaurantId,
          allowVendorRegistration: settings.allowVendorRegistration,
          appName: settings.appName,
          currency: settings.currency,
          currencySymbol: settings.currencySymbol,
          deliveryFee: settings.deliveryFee,
          taxRate: settings.taxRate,
        },
      });
    } catch (error) {
      res.status(500).json({
        status: false,
        message: "Error updating settings",
        error: error.message,
      });
    }
  },
};
