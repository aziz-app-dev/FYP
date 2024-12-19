const Rating = require("../models/rating");
const Restaurant = require("../models/restaurant");
const Food = require("../models/food");

module.exports = {
  // addRating: async (req, res) => {
  //   const newRating = new Rating({
  //     userId: req.user.id,
  //     ratingType: req.body.rating,
  //     product: req.body.product,
  //     rating: req.body.rating,
  //   });
  //   try {
  //     await newRating.save();
  //     if (req.body.ratingType === "Restaurant") {
  //       const restaurant = await Rating.aggregate([
  //         {
  //           match: {
  //             ratingType: req.body.ratingType,
  //             product: req.body.product,
  //           },
  //         },
  //         { group: { _id: "$product" }, averageRating: { $avg: "$rating" } },
  //       ]);
  //       if (restaurant.length > 0) {
  //         const averageRating = restaurant[0].averageRating;
  //         await Restaurant.findByIdAndUpdate(
  //           req.body.product,
  //           { rating: averageRating },
  //           { new: true }
  //         );
  //       } else if (req.body.ratingType === "Food") {
  //         const food = await Rating.aggregate([
  //           {
  //             match: {
  //               ratingType: req.body.ratingType,
  //               product: req.body.product,
  //             },
  //           },
  //           { group: { _id: "$product" }, averageRating: { $avg: "$rating" } },
  //         ]);
  //         if (food.length > 0) {
  //           const averageRating = food[0].averageRating;
  //           await Food.findByIdAndUpdate(
  //             req.body.product,
  //             { rating: averageRating },
  //             { new: true }
  //           );
  //         } else {
  //           res.status(404).json({ status: false, message: "Food not found" });
  //         }
  //       }
  //     }
  //   } catch (error) {
  //     res.status(500).json({ status: false, message: error.message });
  //   }
  // },

  addRating: async (req, res) => {
    const { ratingType, product, rating } = req.body;
    const newRating = new Rating({
      userId: req.user.id,
      ratingType: ratingType,
      product: product,
      rating: parseFloat(rating),
    });
  
    try {
      await newRating.save();
      if (ratingType === 'Restaurant') {
        const restaurant = await Rating.aggregate([
          {
            $match: {
              ratingType: ratingType,
              product: product,
            },
          },
          {
            $group: {
              _id: '$product',
              averageRating: { $avg: '$rating' },
            },
          },
        ]);
        if (restaurant.length > 0) {
          const averageRating = restaurant[0].averageRating;
          await Restaurant.findByIdAndUpdate(
            product,
            { rating: averageRating },
            { new: true }
          );
        }
      } else if (ratingType === 'Food') {
        const food = await Rating.aggregate([
          {
            $match: {
              ratingType: ratingType,
              product: product,
            },
          },
          {
            $group: {
              _id: '$product',
              averageRating: { $avg: '$rating' },
            },
          },
        ]);
        if (food.length > 0) {
          const averageRating = food[0].averageRating;
          await Food.findByIdAndUpdate(
            product,
            { rating: averageRating },
            { new: true }
          );
        } else {
          res.status(404).json({ status: false, message: 'Food not found' });
        }
      }
      res.status(200).json({ status: true, message: 'Rating added successfully' });
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },
  
  // checkRating: async (req, res) => {
  //   const ratingType = req.query.ratingType;
  //   const product = req.query.product;

  //   try {
  //     const existingRating = await Rating.findOne({
  //       userId: req.user.id,
  //       product: product,
  //       rating: ratingType,
  //     });
  //     if (existingRating) {
  //       res.status(200).json({
  //         status: true,
  //         message: "You already have rated this restaurant",
  //       });
  //     } else {
  //       res.status(200).json({
  //         status: false,
  //         message: "USer has not  rated this restaurant",
  //       });
  //     }
  //   } catch (error) {
  //     res.status(500).json({ status: false, message: error.message });
  //   }
  // },
  checkRating: async (req, res) => {
    const ratingType = req.query.ratingType;
    const product = req.query.product;
  
    try {
      const existingRating = await Rating.findOne({
        userId: req.user.id,
        product: product,
        ratingType: ratingType, // Correct this line, previously it was rating: ratingType
      });
      if (existingRating) {
        res.status(200).json({
          status: true,
          message: "You already have rated this restaurant",
          rating: existingRating.rating, // Optionally return the user's rating
        });
      } else {
        res.status(200).json({
          status: false,
          message: "User has not rated this restaurant",
        });
      }
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  }
,  
  // ! Foods Search
  findFoods: async (req, res) => {
    let searchText = req.params.search;

    let pipeline = [
      {
        $search: {
          index: "foods",
          text: {
            query: searchText,
            path: { wildcard: "*" },
          },
        },
      },
    ];

    try {
      let result = await Food.aggregate(pipeline);

      // console.log(result); // Log the result for debugging
      res.status(200).json(result);
    } catch (error) {
      console.error(`Error occurred during search: ${error.message}`); // Log the error
      res.status(500).json({ status: false, message: error.message });
    }
  },
};
