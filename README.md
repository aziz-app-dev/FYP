# 🍔 Food Delivery Platform — Final Year Project (FYP)

A full-stack **food ordering & delivery platform** built as a Final Year Project. It
consists of three Flutter applications (**Customer**, **Vendor** and **Super Admin**)
backed by a **Node.js / Express + MongoDB** REST API.

> Author: **Aziz Ur Rehman**

---

## 📌 Overview

Customers browse restaurants and food categories, search dishes, manage a cart,
place orders and rate them. Vendors manage their menu and fulfil incoming orders
through the whole lifecycle. The Super Admin oversees the entire platform:
every order, restaurant verification, and all user accounts.

| Component | Path | Tech | Description |
|-----------|------|------|-------------|
| **Customer App** | [`user_v1/`](user_v1/) | Flutter (Dart) | Browse, search, cart, order & rate food |
| **Vendor App** | [`fyp_v1/`](fyp_v1/) | Flutter (Dart) | Manage menu & fulfil orders |
| **Super Admin App** | [`admin_v1/`](admin_v1/) | Flutter (Dart) | Platform dashboard, all orders, restaurant approval, users |
| **Backend API** | [`fyp_v1/fyp_backend/`](fyp_v1/fyp_backend/) | Node.js, Express, MongoDB | REST API, auth, business logic |
| *(legacy)* | `vendor_v1/`, `fyp_v1/user-lib/` | — | Early prototype / pre-migration customer source, kept for reference |

---

## 🧱 Architecture

```
FYP/
├── user_v1/                 # Customer Flutter app (package name: user_v1)
│   └── lib/                 # view / view_models / models / repository(hooks) / res
│
├── fyp_v1/                  # Vendor Flutter app
│   ├── lib/                 # views / view models / models / common (MVVM + GetX)
│   └── fyp_backend/         # Node.js / Express REST API (see below)
│
├── admin_v1/                # Super Admin Flutter app
│   └── lib/                 # views / view models / models / common (same MVVM style)
│
└── vendor_v1/               # (legacy prototype, superseded by fyp_v1/lib)
```

All Flutter apps follow an **MVVM** pattern using **GetX** for state management,
routing and dependency injection, and share the same color palette / API layer
conventions.

### Backend structure

```
fyp_backend/
├── config/          # Loads environment variables
├── database/        # MongoDB (Mongoose) connection
├── controllers/     # Route handlers (auth, user, restaurant, food, cart, order, rating…)
├── models/          # Mongoose schemas (user, restaurant, food, cart, order, address…)
├── routes/          # Express routers
├── middlewares/     # JWT verification (verifyToken / verifyVendor / verifyAdmin …)
├── utils/           # SMTP / OTP helpers
├── seed*.js         # Database seed scripts (data, ratings, vendor orders)
├── seed-admin.js    # Creates / resets the Super Admin account
├── test-e2e.js      # End-to-end API test across all three roles
└── server.js        # App entry point
```

---

## ✨ Features

**Customer app (`user_v1`)**
- Email/OTP authentication
- Browse food categories & restaurants, search dishes
- Location & maps (`flutter_map`, geolocation, geocoding, polylines)
- Cart & checkout
- Order tracking (`Pending → Preparing/Ready → Delivering → Delivered / Cancelled`)
- Rating/reviews and profile management

**Vendor app (`fyp_v1`)**
- Create a restaurant (goes to admin for verification)
- Add & manage food items (with image upload)
- Order management across the full lifecycle:
  `New → Preparing → Ready → Pickup / Self-Delivery → Delivered / Cancelled`
- Sales analytics

**Super Admin app (`admin_v1`)**
- Dashboard: total orders, revenue, orders-by-status, users & restaurants breakdown
- **Orders**: every order on the platform, filterable by status, with customer /
  restaurant / items detail and full status override (including cancelling an
  order at any stage — something vendors cannot do)
- **Restaurants**: approve / reject / re-review vendor restaurant applications
- **Users**: list all accounts, filter by role (Customer / Vendor / Admin / Driver)
- Admin-only login guard (`userType == 'Admin'`)

**Backend**
- JWT-based auth & role middlewares (`Client`, `Vendor`, `Admin`, `Driver`)
- Admin endpoints:
  - `GET /api/order/admin` — all orders (populated customer/restaurant/foods, filters)
  - `GET /api/order/admin/stats` — platform stats for the dashboard
  - `GET /api/user/admin/all` — all users (`?userType=` filter)
  - `GET /api/restaurant/admin/all`, `PATCH /api/restaurant/verify/:id`
- Customer order listing supports comma-separated statuses (e.g. `Preparing,Ready`)
- OTP email delivery via `nodemailer`, image hosting via Cloudinary

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart `>=3.5.1`)
- [Node.js](https://nodejs.org/) (v18+ recommended)
- A [MongoDB](https://www.mongodb.com/) database (local or Atlas)

### 1. Backend API

```bash
cd fyp_v1/fyp_backend

npm install

# Configure environment
cp .env.example .env      # then fill in real values

# (Optional) seed demo data
node seed.js
node seed-ratings.js
node seed-vendor-orders.js

# Create the Super Admin account (default admin@fyp.com / admin12345)
node seed-admin.js [email] [password]

# Run the server
npm start                 # listens on PORT from .env (default 5000)
```

#### Environment variables (`fyp_v1/fyp_backend/.env`)

| Variable   | Description                                        |
|------------|----------------------------------------------------|
| `PORT`     | Port the Express server listens on                 |
| `MONGO_URL`| MongoDB connection string                          |
| `SECRET`   | Secret for password encryption (crypto-js)         |
| `JWT_SEC`  | Secret for signing JWT tokens                      |
| `EMAIL`    | Sender email for OTP messages                      |
| `PASSWORD` | App password for the sender email account          |

> ⚠️ **Never commit your real `.env`.** Use `.env.example` as a template.

### 2. The Flutter apps

Each app reads the backend address from its `AppUrl.baseUrl`
(`lib/**/app_url/app_url.dart`). The admin app also accepts a build-time
override, no code edit needed:

```bash
# Customer app
cd user_v1 && flutter pub get && flutter run

# Vendor app
cd fyp_v1 && flutter pub get && flutter run

# Super Admin app (Android / Web / Windows)
cd admin_v1 && flutter pub get
flutter run --dart-define=BASE_URL=http://<your-ip>:5000
```

Login to the admin app with the account created by `seed-admin.js`
(default `admin@fyp.com` / `admin12345`).

---

## 🧪 Testing

```bash
# End-to-end API test (server must be running + admin seeded):
cd fyp_v1/fyp_backend && node test-e2e.js
# Covers: registration/login for all 3 roles, restaurant approval,
# food creation, full order lifecycle, admin overrides, role security.

# Flutter tests / static analysis:
cd admin_v1 && flutter analyze && flutter test
cd user_v1  && flutter analyze && flutter test
cd fyp_v1   && flutter analyze && flutter test
```

---

## 🌐 API Endpoints (base paths)

| Router        | Base path            | Notable admin routes                     |
|---------------|----------------------|------------------------------------------|
| Auth          | `/`                  |                                          |
| User          | `/api/user/`         | `GET admin/all`                          |
| Restaurant    | `/api/restaurant/`   | `GET admin/all`, `PATCH verify/:id`      |
| Category      | `/api/category/`     |                                          |
| Foods         | `/api/foods/`        |                                          |
| Cart          | `/api/cart/`         |                                          |
| Address       | `/api/address/`      |                                          |
| Rating        | `/api/rating/`       |                                          |
| Food search   | `/api/foodSearch/`   |                                          |
| Order         | `/api/order/`        | `GET admin`, `GET admin/stats`           |
| Settings      | `/api/settings/`     |                                          |
| Home feed     | `/api/home/`         |                                          |

---

## 🔒 Security Notes

- The backend `.env` (database URL, JWT secret, email password) must stay out of
  version control — it is git-ignored.
- Third-party API keys (e.g. Cloudinary) should ideally be moved into environment
  configuration rather than hardcoded in source.
- If any secret was ever committed, rotate it before publishing this repository.
- Change the default admin password (`node seed-admin.js admin@fyp.com <new-password>`)
  before demoing or deploying.

---

## 📄 License

This project was developed for academic purposes as a Final Year Project.
