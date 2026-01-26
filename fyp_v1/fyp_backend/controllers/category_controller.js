const Category = require("../models/category");

module.exports = {
  
  // !  create a new category

  createCategory: async (req, res) => {
    const newCategory = new Category(req.body);
    try {
      await newCategory.save();
      res
        .status(201)
        .json({ status: true, message: "Category created successfully" });
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },

  //! update category

  updateCategory: async (req, res) => {
    const id = req.params.id;
    const { title, value, imageUrl } = req.body;

    try {
      const category = await Category.findByIdAndUpdate(
        id,
        {
          title,
          value,
          imageUrl,
        },
        { new: true }
      );
      if (!category) {
        res.status(404),
          json({ status: false, message: "Couldn't find category" });
      }
      res.status(201).json({ status: true, message: "update successfully" });
    } catch (error) {
      res.status(500), json({ status: false, message: error.message });
    }
  },

  //!  delete Category

  deleteCategory: async (req, res) => {
    const id = req.params.id;
    try {
      const category = await Category.findById(id);
      if (!category) {
        res
          .status(404)
          .json({ status: false, message: "Could't find category" });
      }
      await Category.findByIdAndDelete(id);
      res
        .status(201)
        .json({ status: true, message: "Delete category successfully" });
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },

  //! get all category

  getAllCatagories: async (req, res) => {
    try {
      const categories = await Category.find({title:{$ne: "More"}}, { __v: 0 });
      res.status(200).json( categories);
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },

  // !  get random category
  getRandomCategory:async (req,res)=>{
    try {
      let category = await Category.aggregate([
        {$match:{value:{$ne:'more'}}},
        {$sample:{size:7}},
        
      ]);
      const moreCategory = await Category.find({value:'more'});

      if(moreCategory){
        category.push(moreCategory);
      }

      res.status(200).json(category);
    } catch (error) {
      res.status(500).json({status:false, message:error.message});
    }
  },

  //!  update category image

  patchCategoryImage: async (req, res) => {
    const id = req.params.id;
    const imageUrl = req.body;

    try {
      const existingCategory = await Category.findById(id);

      if (!existingCategory) {
        res
          .status(404)
          .json({ status: false, message: "Could't find category" });
      }

      const updatedCategory = new Category({
        title: existingCategory.title,
        value: existingCategory.value,
        imageUrl: imageUrl,
      });
      await updatedCategory.save();
      res
        .status(200)
        .json({ status: true, message: "Category image updated successfully" });
    } catch (error) {
      res.status(500).json({ status: true, message: error.message });
    }
  },

  
};
