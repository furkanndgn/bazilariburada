# BazilariBurada  

![Platform](https://img.shields.io/badge/platform-iOS-blue)
![Swift](https://img.shields.io/badge/swift-6.0-orange)
![Xcode](https://img.shields.io/badge/Xcode-16-blue)

## Overview  

**BazilariBurada** is a grocery store app that allows users to browse and purchase groceries with ease. The app connects to a [backend](https://github.com/CAPELLAX02/grocery-store-backend) developed by a university colleague, following a well-documented API.  

## Screenshots  

Screenshots will be added.  

## Features  

- Browse grocery items from an online store.  
- Add items to the cart and place orders.  
- Uses **MVVM architecture** for a clean code structure.  
- Implements the **Coordinator pattern** for navigation.  
- UI components are built using **XIBs** for better modularity.  

## Tech Stack  

- **Language:** Swift  
- **Frameworks:** UIKit, Combine
- **Architecture:** MVVM  
- **Navigation:** Coordinator Pattern  
- **UI Development:** XIB-based reusable components  
- **Backend API:** [API Documentation](https://github.com/CAPELLAX02/grocery-store-backend/blob/master/docs/GroceryStore_API_Documentation_v1.0.pdf)

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/furkanndgn/bazilariburada.git
   ```
2. Open the `.xcodeproj` or `.xcworkspace` file.
3. Run the project on the simulator or a real device.

## Project Structure

- `Resources/Models/` - Defines the data structures.
- `Resources/Networking/` - Handles API calls.
- `Scenes/` - Contains ViewControllers and their corresponding ViewModels and coordinators.

## How It Works

1. On launch, the app fetches grocery data from the backend.
2. Users can browse available products and view details.
3. Items can be added to the cart and purchased.
4. The network layer follows a structured API based on the provided documentation.
5. Navigation is handled using the Coordinator Pattern for better modularity.
6. UI components are built using XIBs for reusability and maintainability.
