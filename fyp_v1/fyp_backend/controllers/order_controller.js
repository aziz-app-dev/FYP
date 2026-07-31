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
    // Supports comma-separated statuses, e.g. "Preparing,Ready"
    if (orderStatus) {
      query.orderStatus = orderStatus.includes(",")
        ? { $in: orderStatus.split(",") }
        : orderStatus;
    }

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

  // ! admin — all orders across every restaurant, with optional filters
  getAdminOrders: async (req, res) => {
    const { orderStatus, paymentStatus, restaurantId, userId } = req.query;

    try {
      const query = {};
      if (orderStatus) query.orderStatus = orderStatus;
      if (paymentStatus) query.paymentStatus = paymentStatus;
      if (restaurantId) query.restaurantId = restaurantId;
      if (userId) query.userId = userId;

      const orders = await Order.find(query)
        .populate({
          path: "orderItems.foodId",
          select: "title time rating imageUrl price",
        })
        .populate({
          path: "restaurantId",
          select: "title logoUrl imageUrl verification",
        })
        .populate({
          path: "userId",
          select: "username email phone profile",
        })
        .sort({ createdAt: -1 });

      res.status(200).json(orders);
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },

  // ! admin — platform-wide stats for the dashboard
  getAdminStats: async (req, res) => {
    const User = require("../models/user");
    const Restaurantes = require("../models/restaurant");

    try {
      const [statusCounts, revenueAgg, userCounts, restaurantCounts] =
        await Promise.all([
          Order.aggregate([
            { $group: { _id: "$orderStatus", count: { $sum: 1 } } },
          ]),
          Order.aggregate([
            { $match: { orderStatus: { $ne: "Cancelled" } } },
            {
              $group: {
                _id: null,
                grandTotal: { $sum: "$grandTotal" },
                orderTotal: { $sum: "$orderTotal" },
                deliveryFee: { $sum: "$deliveryFee" },
              },
            },
          ]),
          User.aggregate([
            { $group: { _id: "$userType", count: { $sum: 1 } } },
          ]),
          Restaurantes.aggregate([
            { $group: { _id: "$verification", count: { $sum: 1 } } },
          ]),
        ]);

      const orders = {};
      let totalOrders = 0;
      statusCounts.forEach((s) => {
        orders[s._id] = s.count;
        totalOrders += s.count;
      });

      const users = {};
      let totalUsers = 0;
      userCounts.forEach((u) => {
        users[u._id] = u.count;
        totalUsers += u.count;
      });

      const restaurants = {};
      let totalRestaurants = 0;
      restaurantCounts.forEach((r) => {
        restaurants[r._id] = r.count;
        totalRestaurants += r.count;
      });

      res.status(200).json({
        status: true,
        totalOrders,
        orders,
        revenue: revenueAgg[0]
          ? {
              grandTotal: revenueAgg[0].grandTotal,
              orderTotal: revenueAgg[0].orderTotal,
              deliveryFee: revenueAgg[0].deliveryFee,
            }
          : { grandTotal: 0, orderTotal: 0, deliveryFee: 0 },
        totalUsers,
        users,
        totalRestaurants,
        restaurants,
      });
    } catch (error) {
      res.status(500).json({ status: false, message: error.message });
    }
  },

  // ! update order status
  updateOrderStatus: async (req, res) => {
    const orderId = req.params.id;
    const { orderStatus } = req.body;
    const isAdmin = req.user && req.user.userType === "Admin";

    const allowedStatuses = [
      "Pending",
      "Placed",
      "Preparing",
      "Ready",
      "Out For Delivery",
      "Delivering",
      "Delivered",
      "Cancelled",
    ];
    if (!allowedStatuses.includes(orderStatus)) {
      return res.status(400).json({
        status: false,
        message: `orderStatus must be one of: ${allowedStatuses.join(", ")}`,
      });
    }

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
      // Cancelling is blocked once the food has left the restaurant —
      // but forward transitions (e.g. Out For Delivery -> Delivered)
      // must stay possible. Admins can override.
      if (
        orderStatus == "Cancelled" &&
        !isAdmin &&
        (existingOrder.orderStatus == "Out For Delivery" ||
          existingOrder.orderStatus == "Delivering" ||
          existingOrder.orderStatus == "Delivered")
      ) {
        return res
          .status(400)
          .json({
            status: false,
            message:
              'Cannot cancel this order because it is already out for delivery',
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
