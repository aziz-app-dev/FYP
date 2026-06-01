const { response } = require("express");
const Food = require("../models/food");
const Restaurantes = require("../models/restaurant");
const Settings = require("../models/settings");

module.exports = {
  //! Create new Food item
  addFood: async (req, res) => {
    const {
      title,
      time,
      description,
      foodTags,
      foodType,
      category,
      code,
      price,
      additives,
      imageUrl,
    } = req.body;
    if (
      !title ||
      !time ||
      !description ||
      !foodTags ||
      !foodType ||
      !category ||
      !code ||
      !price ||
      !additives ||
      !imageUrl
    ) {
      return res
        .status(400)
        .json({ status: false, message: "All fields are required" });
    }

    try {
      // Enforce: the owning restaurant must exist AND be Verified.
      const restaurantId = req.body.restaurant;
      if (!restaurantId) {
        return res.status(400).json({
          status: false,
          message: "restaurant id is required",
        });
      }
      const restaurant = await Restaurantes.findById(restaurantId);
      if (!restaurant) {
        return res
          .status(404)
          .json({ status: false, message: "Restaurant not found" });
      }
      if (restaurant.verification !== "Verified") {
        return res.status(403).json({
          status: false,
          message:
            "Your restaurant is not verified yet. You cannot add foods until admin approves it.",
        });
      }

      const newFood = new Food(req.body);
      await newFood.save();
      res
        .status(200)
        .json({ status: true, message: "Food item added successfully" });
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },

  // getById: async (req, res) => {
  //   const id = req.params.id;

  //   try {
  //     const food = await Food.findById(id);
  //     if (!food) {
  //       // Ensure that the function exits after sending a 404 response
  //       return res.status(404).json({ status: false, message: "food not found" });
  //     }
  //     // Ensure that the function exits after sending the 200 response
  //     return res.status(200).json(food);
  //   } catch (error) {
  //     // Ensure that the function exits after sending a 500 response
  //     return res.status(500).json({ status: false, message: "failed to get food items" });
  //   }
  // }
  getById: async (req, res) => {
    const id = req.params.id;

    try {
      let food = await Food.findById(id).lean(); // Get a plain JS object

      if (!food) {
        // Ensure that the function exits after sending a 404 response
        return res
          .status(404)
          .json({ status: false, message: "Food not found" });
      }

      // Check if single restaurant mode
      const settings = await Settings.findOne();
      if (settings && settings.serviceMode === "single" && settings.defaultRestaurantId) {
        // In single mode, only allow fetching food from default restaurant
        if (food.restaurant && food.restaurant.toString() !== settings.defaultRestaurantId.toString()) {
          return res.status(403).json({
            status: false,
            message: "This food item is not available in single restaurant mode"
          });
        }
      }

      // Remove the __v field from the response
      const { __v, ...foodWithoutVersion } = food;

      // Ensure that the function exits after sending the 200 response
      return res.status(200).json(foodWithoutVersion);
    } catch (error) {
      // Ensure that the function exits after sending a 500 response
      return res
        .status(500)
        .json({ status: false, message: "Failed to get food item" });
    }
  },
  // !  Get food item s by restaurant
  getFoodByRestaurant: async (req, res) => {
    let restaurantId = req.params.id;

    try {
      // Check if single restaurant mode
      const settings = await Settings.findOne();
      if (settings && settings.serviceMode === "single" && settings.defaultRestaurantId) {
        // In single mode, only allow fetching from default restaurant
        if (restaurantId !== settings.defaultRestaurantId.toString()) {
          return res.status(403).json({
            status: false,
            message: "This restaurant is not available in single restaurant mode"
          });
        }
      }

      const foods = await Food.find({
        restaurant: restaurantId,
      });

      if (!foods || foods.length === 0) {
        return res
          .status(404)
          .json({ status: false, message: "No food items found" });
      }

      res.status(200).json(foods);
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },

  // !  Delete the food item

  deleteFoodById: async (req, res) => {
    const foodId = req.params.id;

    try {
      const food = await Food.foodById(foodId);
      if (!food) {
        res.status(404).json({ status: false, message: "Food not found" });
      }
      await Food.findByIdAndDelete(foodId);
      res
        .status(200)
        .json({ status: true, message: "Food deleted successfully" });
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },

  //!   Change the food availability status

  foodAvailable: async (req, res) => {
    const foodId = req.params.id;

    try {
      const food = await Food.findById(foodId);
      if (!food) {
        res.status(404).json({ status: false, message: "Food item not found" });
      }
      food.isAvailable = !food.isAvailable;
      await food.save();
      res.status(200).json({
        status: true,
        message: "Food availability successfully toggled",
      });
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },

  // !  update food item by id

  updateFoodById: async (req, res) => {
    const foodId = req.params.id;

    try {
      const updateFood = await Food.findByIdAndUpdate(foodId, req.body, {
        new: true,
        runValidators: true,
      });
      if (!updateFood) {
        res
          .status(404)
          .json({ status: false, message: "Food item not updated" });
      }
      res
        .status(200)
        .json({ status: true, message: "Food item successfully updated" });
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },

  // !   fist check tag exist in foodTag array then and add food tag to fooTag  array

  addFoodTags: async (req, res) => {
    const foodId = req.params.id;
    const { tag } = req.body;

    try {
      const food = await Food.findById(foodId);
      if (!food) {
        res.status(404).json({ status: false, message: "Food not found" });
      }
      if (food.foodTags.includes(tag)) {
        res.status(404).json({ status: false, message: "Tag already exists" });
      }
      food.foodTags.push(tag);
      await food.save();
      res.status(200).json({ status: true, message: "Tag Added successfully" });
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },

  //! get Random  food items by code
  getRandomFoodByCode: async (req, res) => {
    try {
      const randomFoodItems = await Food.aggregate([
        { $match: { code: req.params.code } },
        { $sample: { size: 5 } },
        { $project: { __v: 0 } },
      ]);
      res.status(200).json(randomFoodItems);
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },
  //! get Random food item by code
  getRandomFoodByCode2: async (req, res) => {
    try {
      const randomFoodItems = await Food.aggregate([
        { $match: { code: req.params.code } },
        { $sample: { size: 5 } }, // Get only one random item
        { $project: { __v: 0 } },
      ]);

      // Return the first object from the array
      // const randomFoodItem =
      //   randomFoodItems.length > 0 ? randomFoodItems[0] : null;

      
        res.status(200).send(randomFoodItems);
        // res.status(200).json(randomFoodItems);
      
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },

  //! getFoodByCode
  getFoodByCode: async (req, res) => {
    try {
      const randomFoodItems = await Food.aggregate([
        { $match: { code: req.params.code } },
        { $project: { __v: 0 } },
      ]);
      res.status(200).json(randomFoodItems);
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },
  // !  add food items type

  addFoodType: async (req, res) => {
    const { foodType } = req.body.foodType;
    const foodId = req.params.id;

    try {
      const food = await Food.findById(foodId);
      if (!food) {
        res.status(404).json({ status: false, message: error.message });
      }

      if (food.foodType.includes(foodType)) {
        res.status(404).json({ status: false, message: error.message });
      }
      food.foodType.push(foodType);

      await food.save();

      res
        .status(200)
        .json({ status: true, message: "Food type added successfully" });
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },

  // !   get Random food item by their category and the code
  // getRandomByCategoryAndCode: async (req, res) => {
  //   const { category, code } = req.params;
  //   try {
  //     const foods = await Food.aggregate([
  //       { $match: { category: category, code: code } },
  //       { $sample: { size: 10 } },
  //     ]);
  //     if (!foods || foods.length === 0) {
  //       foods = await Food.aggregate([
  //         { $match: { code: code } },
  //         { $sample: { size: 10 } },
  //       ]);
  //     } else {
  //       foods = await Food.aggregate([{ $match: { size: 10 } }]);
  //     }
  //     res.status(200).json(foods);
  //   } catch (error) {
  //     res.status(500).json({ status: false, message: error.message });
  //   }
  // },
  // getRandomByCategoryAndCode: async (req, res) => {
  //   const { category, code } = req.params;
  //   try {
  //     let foods = await Food.aggregate([
  //       { $match: { category: category, code: code } },
  //       { $project: { __v: 0 } },
  //     ]);
  //     if (foods.length === 0) {
  //       foods = await Food.aggregate([
  //         { $match: { code: code } },
  //         { $sample: { size: 10 } },
  //       ]);
  //       res.status(200).json([]);
  //     }
  //     else {
  //       foods = await Food.aggregate([{ $sample: { size: 10 } }]);
  //     }
  //     res.status(200).json(foods);
  //   } catch (error) {
  //     res.status(500).json({ status: false, message: error.message });
  //   }
  // },
  getRandomByCategoryAndCode: async (req, res) => {
    const { category, code } = req.params;
    try {
      let foods = await Food.aggregate([
        { $match: { category: category, code: code, isAvailable: true } },
        { $project: { __v: 0 } },
      ]);

      if (foods.length === 0) {
        // If no foods are found, respond with an empty array.
        res.status(200).json([]);
      } else {
        // If foods are found, respond with the foods array.
        res.status(200).json(foods);
      }
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },

  // !
  getFoodByCode: async (req, res) => {
    const { code } = req.params;
    try {
      let foods = await Food.aggregate([
        { $match: { code: code, isAvailable: true } },
        { $project: { __v: 0 } },
      ]);

      if (foods.length === 0) {
        // If no foods are found, respond with an empty array.
        res.status(200).json([]);
      } else {
        // If foods are found, respond with the foods array.
        res.status(200).json(foods);
      }
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },

  // ! Foods Search
  // Regex-based search that works on both local MongoDB and Atlas.
  findFoods: async (req, res) => {
    const searchText = req.params.search;

    try {
      const regex = new RegExp(searchText, "i");
      const result = await Food.find({
        $or: [
          { title: regex },
          { description: regex },
          { foodTags: regex },
          { foodType: regex },
          { category: regex },
          { code: regex },
        ],
      }).select("-__v");

      res.status(200).json(result);
    } catch (error) {
      console.error(`Error occurred during search: ${error.message}`);
      res.status(500).json({ status: false, message: error.message });
    }
  },
};
