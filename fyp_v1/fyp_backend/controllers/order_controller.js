const Order = require("../models/order");

module.exports = {
  // !  place order
  placeOrder: async (req, res) => {
    const newOrder = new Order({
      ...req.body,
      userId: req.user.id,
    });
    try {
      await newOrder.save();
      const orderId = newOrder._id;
      res.status(201).json({
        status: true,
        message: "Order Placed Successfully",
        orderId: orderId,
      });
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },

  // //   !  get uer order

  //  getUserOrders: async (req, res) => {
  //   const userId = req.user.id;
  //   const { paymentStatus, orderStatus } = req.query;
  //   let query = { userId };

  //   if (paymentStatus) query.paymentStatus = paymentStatus;

  //   if (orderStatus === orderStatus) {
  //     query.orderStatus = orderStatus;
  //   }

  //   try {
  //     const orders = await Order.find({ query }).populate(
  //      {path: "orderItems.foodId",
  //       select: "title time rating imageUrl" }
  //     );
  //     res.status(200).json(orders);
  //   } catch (error) {
  //     res.status(500).json({ status: false, message: error.message });
  //   }
  // },
  // !  get user orders
  getUserOrders: async (req, res) => {
    const userId = req.user.id;
    const { paymentStatus, orderStatus } = req.query;
    let query = { userId };

    if (paymentStatus) query.paymentStatus = paymentStatus;
    if (orderStatus) query.orderStatus = orderStatus;

    try {
      const orders = await Order.find(query).populate({
        path: "orderItems.foodId",
        select: "title time rating imageUrl",
      });
      res.status(200).json(orders);
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },
  // ! vendor orders — all orders sent to a specific restaurant
  getVendorOrders: async (req, res) => {
    const Restaurantes = require("../models/restaurant");
    const { orderStatus, paymentStatus } = req.query;
    const ownerId = req.user.id;

    try {
      // All restaurants owned by this vendor
      const myRestaurants = await Restaurantes.find({ owner: ownerId }, { _id: 1 });
      const restaurantIds = myRestaurants.map((r) => r._id.toString());

      if (restaurantIds.length === 0) {
        return res.status(200).json([]);
      }

      const query = { restaurantId: { $in: restaurantIds } };
      if (orderStatus) query.orderStatus = orderStatus;
      if (paymentStatus) query.paymentStatus = paymentStatus;

      const orders = await Order.find(query)
        .populate({
          path: "orderItems.foodId",
          select: "title time rating imageUrl price",
        })
        .sort({ createdAt: -1 });

      res.status(200).json(orders);
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },

  // ! update order status
  updateOrderStatus: async (req, res) => {
    const orderId = req.params.id;
    const { orderStatus } = req.body;

    try {
      // Check if the order exists
      const existingOrder = await Order.findById(orderId);
      if (!existingOrder) {
        return res
          .status(404)
          .json({ status: false, message: "Order not found" });
      }

      // Re-cancelling an already-cancelled order is a no-op; block it.
      // But allow restoring (Cancelled -> Pending/Preparing/etc.) so
      // the vendor can undo a mistaken cancellation.
      if (
        existingOrder.orderStatus == 'Cancelled' &&
        orderStatus == 'Cancelled'
      ) {
        return res.status(400).json({
          status: false,
          message: 'order already Cancelled',
        });
      }
      if (
        existingOrder.orderStatus == "Out For Delivery" ||
        existingOrder.orderStatus == "Delivered"
      ) {
        return res
          .status(400)
          .json({
            status: false,
            message:
              'Cannot can not Cancel order because order is out for delivery',
          });
      }

      const updatedOrder = await Order.findByIdAndUpdate(
        orderId,
        { orderStatus },
        { new: true }
      );

      if (updatedOrder) {
        res
          .status(200)
          .json({ status: true, message: "Order Status Updated Successfully" });
      } else {
        res
          .status(404)
          .json({ status: false, message: "Failed to Update Order" });
      }
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },
};
