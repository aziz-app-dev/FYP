const Cart = require("../models/cart");

module.exports = {
  // ! 1 add product
  addProductToCart: async (req, res) => {
    const userId = req.user.id;
    const { productId, totalPrice, quantity, additives, instructions } =
      req.body;
    let count;
    try {
      const existingProduct = await Cart.findOne({ userId, productId });

      if (existingProduct) {
        // existingProduct.quantity += 1;
        // existingProduct.totalPrice += totalPrice* quantity;
        existingProduct.quantity += quantity;
        existingProduct.totalPrice += totalPrice * quantity;

        await existingProduct.save();
      } else {
        const newProduct = new Cart({
          userId,
          productId,
          quantity,
          totalPrice,
          additives,
          instructions,
        });

        await newProduct.save();
      }
      count = await Cart.countDocuments({ userId });
      res.status(201).json({ status: true, count: count });
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },

  // // ! 2 remove product
  // removeProduct: async (req, res) => {
  //   const itemId = req.params.id;
  //   const userId = req.user.id;
  //   let count;

  //   try {
  //     const existingProduct = await Cart.findOne(itemId);
  //     if (!existingProduct) {
  //       res.status(404).json({ status: false, message: "Product not found" });
  //     }
  //     await Cart.findOneAndDelete({ _id: itemId });
  //     count = await countDocuments({ userId });
  //     res.status(200).json({ status: true, cartCount: count });
  //   } catch (error) {
  //     res.status(500).json({ status: false, message: error.message });
  //   }
  // },
  // ! 2 remove product
removeProduct: async (req, res) => {
  const itemId = req.params.id;
  const userId = req.user.id;
  let count;

  try {
    const existingProduct = await Cart.findOne({ _id: itemId }); // Corrected line
    if (!existingProduct) {
      return res.status(404).json({ status: false, message: "Product not found" });
    }
    await Cart.findOneAndDelete({ _id: itemId });
    count = await Cart.countDocuments({ userId }); // Corrected line
    res.status(200).json({ status: true, cartCount: count });
  } catch (error) {
    res.status(500).json({ status: false, message: error.message });
  }
},

  // ! 3 fetch product
  fetchUserCart: async (req, res) => {
    const userId = req.user.id;
    try {
      const userCart = await Cart.find({ userId: userId }).populate({
        path: "productId",
        select: "title restaurant rating ratingCount price imageUrl",
      });

      res.status(200).json(userCart);
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },
  // ! 4 clear user cart product
  clearUserCart: async (req, res) => {
    const userId = req.user.id;
    try {
      await Cart.deleteMany({ userId: userId });
      res.status(200).json({ status: true, message: "Cart cleared" });
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },
  // ! 5 get user cart count
  getCartCount: async (req, res) => {
    const userId = req.user.id;
    try {
      const count = await Cart.countDocuments({ userId: userId });
      res.status(200).json({ status: true, cartCount: count });
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },
  // ! 6 decrement user cart qty
  decrementProductQty: async (req, res) => {
    const userId = req.user.id;
    const productId = req.params.id;
  
    try {
      const existingProduct = await Cart.findOne({ userId, productId });
  
      if (!existingProduct) {
        return res.status(404).json({ status: false, message: "Product not found" });
      }
      if (existingProduct) {
        
        const productPrice = existingProduct.totalPrice / existingProduct.quantity;

        if (existingProduct.quantity > 1) {
          existingProduct.quantity -= 1;
          existingProduct.totalPrice -= productPrice;
          await existingProduct.save();
          return res.status(200).json({
            status: true,
            message: "Product decremented successfully",
          });
        } else {
          await Cart.findOneAndDelete({ userId, productId });
          const count = await Cart.countDocuments({ userId });
          return res.status(200).json({
            status: true,
            message: "Product removed from cart",
            cartCount: count,
          });
        }
      }
      
    } catch (error) {
      return res.status(500).json({ status: false, message: error.message });
    }
  },
  };
