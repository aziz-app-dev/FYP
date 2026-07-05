# 🍔 Food Delivery Platform — Final Year Project (FYP)

A full-stack **food ordering & delivery platform** built as a Final Year Project. It
consists of two Flutter mobile applications (a **Customer app** and a **Vendor app**)
backed by a **Node.js / Express + MongoDB** REST API.

> Author: **Aziz Ur Rehman**

---

## 📌 Overview

The platform lets customers browse restaurants and food categories, search dishes,
manage a cart, place orders and rate them — while vendors manage incoming orders
through their whole lifecycle (new → preparing → ready → pickup → delivered / cancelled).

| Component | Path | Tech | Description |
|-----------|------|------|-------------|
| **Customer App** | [`fyp_v1/`](fyp_v1/) | Flutter (Dart) | Browse, search, cart, order & rate food |
| **Vendor App** | [`vendor_v1/`](vendor_v1/) | Flutter (Dart) | Manage menu & fulfil orders |
| **Backend API** | [`fyp_v1/fyp_backend/`](fyp_v1/fyp_backend/) | Node.js, Express, MongoDB | REST API, auth, business logic |

---

## 🧱 Architecture

```
FYP/
├── fyp_v1/                  # Customer Flutter app
│   ├── lib/
│   │   ├── common/          # Shared resources (colors, routes, components, utils, l10n)
│   │   ├── models/          # Data models (food, order, restaurant, rating, login, error)
│   │   ├── view models/     # GetX controllers & API services
│   │   ├── views/           # UI screens (auth, home, foods, restaurant, profile, splash)
│   │   └── main.dart
│   └── fyp_backend/         # Node.js / Express REST API (see below)
│
└── vendor_v1/               # Vendor Flutter app (same MVVM structure)
    └── lib/
        ├── common/
        ├── models/
        ├── view models/
        └── views/           # add_foods, foods, home (order-lifecycle tabs)
```

Both Flutter apps follow an **MVVM** pattern using **GetX** for state management,
routing and dependency injection.

### Backend structure

```
fyp_backend/
├── config/          # Loads environment variables
├── database/        # MongoDB (Mongoose) connection
├── controllers/     # Route handlers (auth, user, restaurant, food, cart, order, rating…)
├── models/          # Mongoose schemas (user, restaurant, food, cart, order, address…)
├── routes/          # Express routers
├── middlewares/     # JWT token verification
├── utils/           # SMTP / OTP helpers
├── seed*.js         # Database seed scripts (data, ratings, vendor orders)
└── server.js        # App entry point
```

---

## ✨ Features

**Customer app**
- Email/OTP authentication
- Browse food categories & restaurants
- Search dishes
- Location & maps (`flutter_map`, geolocation, geocoding, polylines)
- Cart & checkout
- Order tracking and rating/reviews
- Profile management

**Vendor app**
- Add & manage food items (with image upload)
- Order management across the full lifecycle:
  `New → Preparing → Ready → Pickup → Delivered / Cancelled` (+ self-delivery)

**Backend**
- JWT-based authentication & password encryption (`crypto-js`)
- OTP email delivery via `nodemailer`
- REST endpoints for restaurants, categories, foods, cart, addresses, orders, ratings, search, settings & home feed

---

## 🛠️ Tech Stack

- **Frontend:** Flutter (Dart, SDK `^3.5.1`), GetX, flutter_screenutil, google_fonts, cached_network_image, flutter_map, geolocator, lottie, flutter_svg
- **Backend:** Node.js, Express 4, Mongoose 8 (MongoDB), JSON Web Tokens, crypto-js, nodemailer, dotenv
- **Image hosting:** Cloudinary

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart `>=3.5.1`)
- [Node.js](https://nodejs.org/) (v18+ recommended)
- A [MongoDB](https://www.mongodb.com/) database (local or Atlas)

### 1. Backend API

```bash
cd fyp_v1/fyp_backend

# Install dependencies
npm install

# Configure environment
cp .env.example .env      # then fill in real values (see below)

# (Optional) seed the database
node seed.js
node seed-ratings.js
node seed-vendor-orders.js

# Run the server (nodemon)
npm start
```

The server listens on the `PORT` from your `.env` (default `5000`).

#### Environment variables (`fyp_v1/fyp_backend/.env`)

| Variable   | Description                                        |
|------------|----------------------------------------------------|
| `PORT`     | Port the Express server listens on                 |
| `MONGO_URL`| MongoDB connection string                          |
| `SECRET`   | Secret for password encryption (crypto-js)         |
| `JWT_SEC`  | Secret for signing JWT tokens                      |
| `EMAIL`    | Sender email for OTP messages                      |
| `PASSWORD` | App password for the sender email account          |

> ⚠️ **Never commit your real `.env`.** It is git-ignored; use `.env.example` as a template.

### 2. Customer app (`fyp_v1`)

```bash
cd fyp_v1
flutter pub get

# Point the app at your backend:
# edit lib/common/res/app_url/ and set `baseUrl` to your machine's IP + port,
# e.g. http://192.168.x.x:5000

flutter run
```

### 3. Vendor app (`vendor_v1`)

```bash
cd vendor_v1
flutter pub get
flutter run
```

---

## 🌐 API Endpoints (base paths)

| Router        | Base path            |
|---------------|----------------------|
| Auth          | `/`                  |
| User          | `/api/user/`         |
| Restaurant    | `/api/restaurant/`   |
| Category      | `/api/category/`     |
| Foods         | `/api/foods/`        |
| Cart          | `/api/cart/`         |
| Address       | `/api/address/`      |
| Rating        | `/api/rating/`       |
| Food search   | `/api/foodSearch/`   |
| Order         | `/api/order/`        |
| Settings      | `/api/settings/`     |
| Home feed     | `/api/home/`         |

---

## 🔒 Security Notes

- The backend `.env` (database URL, JWT secret, email password) must stay out of
  version control — it is git-ignored.
- Third-party API keys (e.g. Cloudinary) should ideally be moved into environment
  configuration rather than hardcoded in source.
- If any secret was ever committed, rotate it before publishing this repository.

---

## 📄 License

This project was developed for academic purposes as a Final Year Project.
