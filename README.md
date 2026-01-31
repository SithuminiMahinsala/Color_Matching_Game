# Color Snap

A professional, logic-based memory matching game built with **SwiftUI**. Test your cognitive skills by matching colors across various game modes designed with industrial software standards.

## 🚀 Features

### **Core Gameplay**
* **Dynamic Grid Logic**: Interactive 2D grid matching with real-time score calculation.
* **Progression System**: Unlockable difficulty tiers (Easy, Medium, Hard) based on persistent win counts.
* **Special Challenges**: High-intensity modes including **Time Attack** (with time rewards) and **Memory Blitz** (with a 3-second preview phase).

### **Industrial Standards (Lecturer Requirements)**
* **Telemetry & Analytics**: Comprehensive session tracking including total clicks, game duration, and start/end timestamps, stored locally for performance analysis.
* **Privacy & Legal Compliance**: Dedicated Privacy Policy and Terms of Service views accessible from the landing and settings screens.
* **Unit Testing**: Robust testing suite utilizing **XCTest** to verify core game logic, scoring bonuses, and telemetry accuracy.

### **User Experience (UX)**
* **Haptic Feedback**: Integrated `UINotificationFeedbackGenerator` and `UIImpactFeedbackGenerator` for tactile responses on matches and errors.
* **Visual Polish**: Implemented a **Confetti Celebration** on victory and a professional **Landing View** with custom 1024x1024 branding.
* **Persistent Profiles**: Localized user profile management and leaderboard tracking via `UserDefaults`.

## 🛠 Tech Stack

* **Language**: Swift 5.10
* **Framework**: SwiftUI (Declarative UI)
* **Architecture**: MVVM (Model-View-ViewModel)
* **Testing**: XCTest Framework
* **Persistence**: `UserDefaults` with `Codable` support

## 📂 Project Structure

* `Model/`: Data structures for game cells, telemetry sessions, and player scores.
* `ViewModel/`: Core game engines, audio management, and telemetry services.
* `View/`: Modular UI components, specialized game screens, and diagnostic logs.

## 🧑‍💻 Developer

* **Name**: Sithumini Mahinsala
* **Student ID**: COBSCCOMP242P-001
