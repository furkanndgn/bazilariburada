# CryptoTrack  

![Platform](https://img.shields.io/badge/platform-iOS-blue)
![Swift](https://img.shields.io/badge/swift-6.0-orange)
![Xcode](https://img.shields.io/badge/Xcode-16-blue)

## Overview  
**bazilariburada** is a modern grocery shopping application for iOS that lets users browse, search, and purchase groceries with an intuitive and user-friendly interface. The [backend](https://github.com/CAPELLAX02/grocery-store-backend) is implemented by [CAPELLAX02](https://github.com/CAPELLAX02) and provides robust RESTful APIs for product listing, cart management, authentication, and order history.

## Screenshots  
Screenshots will be added.  

## Features  
- Browse and search products by category or keyword
- Product detail screen with:
  - Images, detailed description, price, stock status
  - Rating and user reviews
- Shopping cart:
  - Add/remove products
  - Adjust quantities
  - Instant price updates
- User authentication:
  - Register, login, and manage account info
- Order management:
  - Place orders and view order history
- Favorites:
  - Mark products as favorites for quick access
- Polished, mobile-first UI with UIKit and modern iOS best practices


## Tech Stack  
- **Language:** Swift  
- **Frameworks:** UIKit (IB-based custom views and controllers)
- **Persistence:** Keychain (secure tokens)
- **Networking:** URLSession
- **Architecture:** MVVM  
- **Depencency Management:** Swift Package Manager
- **API Used:** [Custom Grocery Backend](https://github.com/CAPELLAX02/grocery-store-backend)

## Project Structure
- `Application/` – App and scene lifecycle management
- `Models/` – Data models (Product, Cart, User, etc.)
- `Networking/` – Network manager, API client, and endpoints
- `Router/` – Routing logic; contains an app router and a protocol for route-emitting, implemented by VCs that handle navigation
- `Scenes/` – All feature modules (main screens, view controllers, views)
- `Utilities/` – Helpers, extensions, constants, Keychain utilities

## How It Works
1. App initializes and authenticates the user, securely storing tokens in Keychain.
2. Catalog and category data are fetched from the backend API.
3. Users can search/browse, view details, and add items to the cart.
4. All cart operations and order placements are synced via API.
5. User authentication and session tokens are securely persisted and refreshed as needed.
6. Navigation and deep-linking are handled via a dedicated Router system, promoting clean transitions and separation of concerns.

## Backend
Backend (REST API) repository: [grocery-store-backend](https://github.com/CAPELLAX02/grocery-store-backend)
Check its README and [docs](https://github.com/CAPELLAX02/grocery-store-backend/blob/master/docs/GroceryStore_API_Documentation_v1.0.pdf) for setup and documentation.

## Installation  
1. Clone the repository:  
   ```bash
   git clone https://github.com/furkanndgn/bazilariburada.git
   ```
2. Open the `bazilariburada.xcodeproj`file.
3. Ensure backend is running and your API endpoint/configuration is correct in the app.
4. Build and run the app on the simulator or a real device.
