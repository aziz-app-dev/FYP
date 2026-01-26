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
  // ! update order status
  updateOrderStatus: async (req, res) => {
    const orderId = req.params.id;
    const { orderStatus } = req.body;

    try {
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

      // Check if the current status is "Out For Delivery"
      if (
        existingOrder.orderStatus ==  'Cancelled'
      ) {
        return res
          .status(400)
          .json({
            status: false,
            message:
              'order already Cancelled',
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
