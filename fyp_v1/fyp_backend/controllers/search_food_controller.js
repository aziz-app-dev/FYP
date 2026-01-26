const Food = require("../models/food");

module.exports = {
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
