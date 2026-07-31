// End-to-end API test for the whole platform:
//   client registers & places an order
//   vendor registers, opens a restaurant, adds food, fulfils the order
//   admin approves the restaurant, sees every order, overrides statuses
//
// Prerequisites: server running on BASE (below), admin seeded via seed-admin.js.
// Usage: node test-e2e.js
const BASE = process.env.BASE_URL || "http://localhost:5000";

const stamp = Date.now();
const CLIENT = { username: "E2E Client", email: `e2e_client_${stamp}@fyp.test`, password: "client12345", userType: "Customer" };
const VENDOR = { username: "E2E Vendor", email: `e2e_vendor_${stamp}@fyp.test`, password: "vendor12345", userType: "Vendor" };
const ADMIN = { email: "admin@fyp.com", password: "admin12345" };

let passed = 0;
let failed = 0;

function check(name, cond, extra = "") {
  if (cond) {
    passed++;
    console.log(`  PASS  ${name}`);
  } else {
    failed++;
    console.log(`  FAIL  ${name} ${extra}`);
  }
}

async function api(method, path, { token, body } = {}) {
  const res = await fetch(`${BASE}${path}`, {
    method,
    headers: {
      "Content-Type": "application/json",
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
    },
    body: body ? JSON.stringify(body) : undefined,
  });
  let json = null;
  try {
    json = await res.json();
  } catch (_) {}
  return { status: res.status, json };
}

async function main() {
  console.log(`E2E against ${BASE}\n`);

  // ---------- auth ----------
  console.log("1. Accounts");
  let r = await api("POST", "/register", { body: CLIENT });
  check("client registers", r.status === 201, JSON.stringify(r.json));
  r = await api("POST", "/register", { body: VENDOR });
  check("vendor registers", r.status === 201, JSON.stringify(r.json));

  r = await api("POST", "/login", { body: { email: CLIENT.email, password: CLIENT.password } });
  check("client logs in as Client", r.status === 200 && r.json.userType === "Client", JSON.stringify(r.json));
  const clientToken = r.json.userToken;
  const clientId = r.json._id;

  r = await api("POST", "/login", { body: { email: VENDOR.email, password: VENDOR.password } });
  check("vendor logs in as Vendor", r.status === 200 && r.json.userType === "Vendor");
  const vendorToken = r.json.userToken;
  const vendorId = r.json._id;

  r = await api("POST", "/login", { body: ADMIN });
  check("admin logs in as Admin", r.status === 200 && r.json.userType === "Admin", JSON.stringify(r.json));
  const adminToken = r.json.userToken;

  // ---------- restaurant lifecycle ----------
  console.log("\n2. Restaurant verification (vendor -> admin)");
  r = await api("POST", "/api/restaurant/", {
    token: vendorToken,
    body: {
      title: `E2E Diner ${stamp}`,
      time: "25 min",
      imagesUrl: "https://example.com/cover.jpg",
      imageUrl: "https://example.com/cover.jpg",
      logoUrl: "https://example.com/logo.jpg",
      owner: vendorId,
      code: "lahr",
      coords: {
        id: `${stamp}`,
        latitude: 31.5204,
        longitude: 74.3587,
        address: "Mall Road, Lahore",
        title: "E2E Diner",
      },
    },
  });
  check("vendor creates restaurant", r.status === 200, JSON.stringify(r.json));

  r = await api("GET", "/api/restaurant/admin/all", { token: adminToken });
  const myRestaurant = (r.json.restaurants || []).find((x) => x.title === `E2E Diner ${stamp}`);
  check("admin sees restaurant in admin/all", !!myRestaurant);
  check("new restaurant starts Pending", myRestaurant?.verification === "Pending");

  r = await api("GET", "/api/restaurant/admin/all", { token: clientToken });
  check("client is blocked from admin restaurant list (403)", r.status === 403);

  r = await api("PATCH", `/api/restaurant/verify/${myRestaurant._id}`, {
    token: adminToken,
    body: { verification: "Verified" },
  });
  check("admin approves restaurant", r.status === 200 && r.json.restaurant.verification === "Verified");

  // ---------- food ----------
  console.log("\n3. Food");
  r = await api("POST", "/api/foods/", {
    token: vendorToken,
    body: {
      title: "E2E Burger",
      time: "15 min",
      description: "Test burger",
      foodTags: ["burger"],
      foodType: ["fast food"],
      category: "burger",
      code: "lahr",
      price: 500,
      additives: [{ id: 1, title: "Cheese", price: "50" }],
      imageUrl: ["https://example.com/burger.jpg"],
      restaurant: myRestaurant._id,
    },
  });
  check("vendor adds food", r.status === 200 || r.status === 201, JSON.stringify(r.json));
  r = await api("GET", `/api/foods/byRestaurant/${myRestaurant._id}`);
  const food = Array.isArray(r.json) ? r.json.find((f) => f.title === "E2E Burger") : null;
  check("food listed for restaurant", !!food);

  // ---------- order lifecycle ----------
  console.log("\n4. Order lifecycle (client -> vendor)");
  const orderBody = {
    orderItems: [
      { foodId: food._id, quantity: 2, price: 500, additives: ["Cheese"], instruction: "no onions" },
    ],
    orderTotal: 1000,
    deliveryFee: 150,
    grandTotal: 1150,
    restaurantAddress: "Mall Road, Lahore",
    restaurantId: myRestaurant._id,
    restaurantCoords: [31.5204, 74.3587],
    recipientCoords: [31.53, 74.37],
    paymentMethod: "Cash",
    paymentStatus: "Pending",
    orderStatus: "Pending",
  };
  r = await api("POST", "/api/order", { token: clientToken, body: orderBody });
  check("client places order", r.status === 201 && !!r.json.orderId, JSON.stringify(r.json));
  const orderId = r.json.orderId;

  r = await api("GET", "/api/order?orderStatus=Pending", { token: clientToken });
  check("client sees own Pending order", Array.isArray(r.json) && r.json.some((o) => o._id === orderId));

  r = await api("GET", "/api/order/vendor?orderStatus=Pending", { token: vendorToken });
  check("vendor sees incoming order", Array.isArray(r.json) && r.json.some((o) => o._id === orderId));

  const setStatus = (token, status) =>
    api("PUT", `/api/order/${orderId}`, { token, body: { orderStatus: status } });

  r = await setStatus(vendorToken, "Preparing");
  check("vendor: Pending -> Preparing", r.status === 200, JSON.stringify(r.json));

  r = await api("GET", "/api/order?orderStatus=Preparing,Ready", { token: clientToken });
  check("client comma-status filter (Preparing,Ready)", Array.isArray(r.json) && r.json.some((o) => o._id === orderId));

  r = await setStatus(vendorToken, "Ready");
  check("vendor: Preparing -> Ready", r.status === 200);
  r = await setStatus(vendorToken, "Out For Delivery");
  check("vendor: Ready -> Out For Delivery", r.status === 200);

  r = await setStatus(vendorToken, "Cancelled");
  check("vendor cannot cancel after Out For Delivery (400)", r.status === 400, JSON.stringify(r.json));

  r = await setStatus(vendorToken, "Delivered");
  check("vendor: Out For Delivery -> Delivered (regression fix)", r.status === 200, JSON.stringify(r.json));

  r = await api("GET", "/api/order?orderStatus=Delivered", { token: clientToken });
  check("client sees order in Delivered", Array.isArray(r.json) && r.json.some((o) => o._id === orderId));

  r = await api("PUT", `/api/order/${orderId}`, { token: vendorToken, body: { orderStatus: "Bogus" } });
  check("invalid status rejected (400)", r.status === 400);

  // ---------- admin order powers ----------
  console.log("\n5. Admin order management");
  r = await api("POST", "/api/order", { token: clientToken, body: orderBody });
  const orderId2 = r.json.orderId;
  check("client places second order", r.status === 201 && !!orderId2);

  r = await api("PUT", `/api/order/${orderId2}`, { token: vendorToken, body: { orderStatus: "Out For Delivery" } });
  check("vendor moves second order Out For Delivery", r.status === 200);

  r = await api("PUT", `/api/order/${orderId2}`, { token: adminToken, body: { orderStatus: "Cancelled" } });
  check("admin CAN cancel after Out For Delivery (override)", r.status === 200, JSON.stringify(r.json));

  r = await api("GET", "/api/order/admin", { token: adminToken });
  const adminOrders = Array.isArray(r.json) ? r.json : [];
  const o1 = adminOrders.find((o) => o._id === orderId);
  const o2 = adminOrders.find((o) => o._id === orderId2);
  check("admin sees all orders", !!o1 && !!o2);
  check("admin orders have populated customer", o1?.userId?.email === CLIENT.email, JSON.stringify(o1?.userId));
  check("admin orders have populated restaurant", o1?.restaurantId?.title === `E2E Diner ${stamp}`);
  check("admin orders have populated food", o1?.orderItems?.[0]?.foodId?.title === "E2E Burger");

  r = await api("GET", "/api/order/admin?orderStatus=Cancelled", { token: adminToken });
  check("admin status filter works", Array.isArray(r.json) && r.json.some((o) => o._id === orderId2) && !r.json.some((o) => o._id === orderId));

  r = await api("GET", "/api/order/admin", { token: vendorToken });
  check("vendor blocked from admin orders (403)", r.status === 403);

  r = await api("GET", "/api/order/admin/stats", { token: adminToken });
  check("admin stats respond", r.status === 200 && r.json.totalOrders >= 2, JSON.stringify(r.json));
  check("stats count Delivered & Cancelled", (r.json.orders?.Delivered ?? 0) >= 1 && (r.json.orders?.Cancelled ?? 0) >= 1);
  check("stats exclude cancelled revenue", r.json.revenue.grandTotal >= 1150);

  // ---------- admin users ----------
  console.log("\n6. Admin user management");
  r = await api("GET", "/api/user/admin/all", { token: adminToken });
  const users = r.json.users || [];
  check("admin lists users", r.status === 200 && users.length >= 3);
  check("password/otp never exposed", users.every((u) => u.password === undefined && u.otp === undefined));
  check("client + vendor + admin present",
    users.some((u) => u.email === CLIENT.email) &&
    users.some((u) => u.email === VENDOR.email) &&
    users.some((u) => u.userType === "Admin"));

  r = await api("GET", "/api/user/admin/all?userType=Vendor", { token: adminToken });
  check("userType filter works", r.status === 200 && (r.json.users || []).every((u) => u.userType === "Vendor"));

  r = await api("GET", "/api/user/admin/all", { token: clientToken });
  check("client blocked from user list (403)", r.status === 403);

  // ---------- summary ----------
  console.log(`\n==== ${passed} passed, ${failed} failed ====`);
  process.exit(failed === 0 ? 0 : 1);
}

main().catch((e) => {
  console.error("E2E crashed:", e);
  process.exit(1);
});
