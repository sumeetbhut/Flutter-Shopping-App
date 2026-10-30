# Cartify - Professional E-commerce Demo

Daily Goods is a premium Flutter e-commerce application demonstrating modern UI/UX principles, robust architecture, and smooth animations. It integrates with the DummyJSON API to provide a realistic shopping experience.

## ✨ Features

- **Premium UI/UX**: Designed with a sophisticated Slate 900 & Blue 500 color palette, inspired by high-end design systems.
- **Animated Splash Screen**: Features a scaling logo and graceful entrance animations with a Radial Gradient background.
- **Secure Authentication**: 
  - Token-based login using `flutter_secure_storage`.
  - Staggered entrance animations for the login form.
  - Comprehensive error handling for invalid credentials.
- **Dynamic Product Discovery**:
  - **Staggered Grid Animations**: Products slide and fade into view using index-based delays.
  - **Smart Search**: Real-time product search with a 500ms debounce to optimize API calls.
  - **Pagination**: Infinite scrolling/lazy loading as the user reaches the end of the list.
- **Rich Detail View**:
  - **Sliver Architecture**: Collapsing app bar with product image gallery.
  - **Hero Transitions**: Seamless image transitions from the grid to the detail view.
  - **Interactive Cart**: Animated "Add to Cart" button with success states.
- **Robust Error Handling**:
  - **Network Monitoring**: Detects and reports "No Internet" or "Timeout" errors.
  - **Empty States**: Professional UI feedback when no products are found.

## 🛠 Tech Stack & Architecture

- **Framework**: Flutter (Material 3)
- **API**: [DummyJSON](https://dummyjson.com/)
- **Networking**: `http` with custom `ApiClient` (Timeouts & Exception handling)
- **Persistence**: `flutter_secure_storage`
- **Animations**: `AnimationController`, `Hero`, `AnimatedSwitcher`, and `PageRouteBuilder`.
- **Project Structure**:
  - `lib/data/`: Data models, API client, and repositories.
  - `lib/screens/`: UI screens including Splash, Login, Product List, and Product Details.

## 🚀 Technical Details

- **Project Name**: `dummy_json`
- **Package Name**: `com.app.shopappdemo`
- **Modules**: `dummy_json`, `dummy_json_android`
- **Root Folder**: `D:/Development/dummy_json/dummy_json`

## 🚀 Getting Started

1. **Clone the repository**
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **Run the app**:
   ```bash
   flutter run
   ```

## 🔑 Demo Credentials

To access the app, you can use the following demo account from DummyJSON:
- **Username**: `emilys`
- **Password**: `emilyspass`

---
*Created as a professional portfolio demonstration.*
