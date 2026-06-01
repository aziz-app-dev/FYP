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

  // Returns a ratings summary + review list for a restaurant.
  // Response: { average, count, breakdown: [n1, n2, n3, n4, n5], reviews: [...] }
  getByRestaurant: async (req, res) => {
    try {
      const { id } = req.params;
      const items = await Rating.find(
        { ratingType: "Restaurant", product: id },
      ).sort({ createdAt: -1 });

      if (items.length === 0) {
        return res.status(200).json({
          average: 0,
          count: 0,
          breakdown: [0, 0, 0, 0, 0],
          reviews: [],
        });
      }

      const breakdown = [0, 0, 0, 0, 0];
      let sum = 0;
      for (const r of items) {
        const bucket = Math.round(r.rating);
        const idx = Math.min(Math.max(bucket - 1, 0), 4);
        breakdown[idx] += 1;
        sum += r.rating;
      }
      const average = sum / items.length;
      res.status(200).json({
        average,
        count: items.length,
        breakdown, // index 0 = 1-star count, index 4 = 5-star count
        reviews: items.map((r) => ({
          _id: r._id,
          userId: r.userId,
          username: r.username,
          userPhoto: r.userPhoto,
          rating: r.rating,
          comment: r.comment,
          createdAt: r.createdAt,
        })),
      });
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },

  addRating: async (req, res) => {
    const { ratingType, product, rating, comment, username, userPhoto } =
      req.body;
    const newRating = new Rating({
      userId: req.user.id,
      username: username || "",
      userPhoto: userPhoto || "",
      ratingType: ratingType,
      product: product,
      rating: parseFloat(rating),
      comment: comment || "",
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
