# 📱 Smart Expense Tracker - Flutter Mobile App

[![Flutter](https://img.shields.io/badge/framework-Flutter-02569B?style=flat-square&logo=flutter)](https://flutter.dev/)
[![Riverpod](https://img.shields.io/badge/state-Riverpod-00BCD4?style=flat-square)](https://riverpod.dev/)
[![Dart](https://img.shields.io/badge/language-Dart-0175C2?style=flat-square&logo=dart)](https://dart.dev/)
[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat-square)](LICENSE)

A beautiful, modern mobile application for personal finance management. Built with Flutter, following professional state management and architecture patterns.

## 🚀 Key Features

- **🔐 Authentication:** Secure login and registration with persistent session handling.
- **💸 Transaction Management:** Track both Expenses and Income with ease.
- **📄 Detailed Lists:** View transactions with pagination, filtering, and long-press actions.
- **➕ Easy Entry:** Intuitive add/edit forms for all transaction types.
- **📊 Interactive Analytics:** Visualize your spending habits with beautiful charts (fl_chart).
- **🎨 Premium UI:** Clean, modern design with support for Light and Dark modes.
- **⚙️ Preferences:** Manage currency settings, theme selection, and user profile.
- **🏗️ Solid Architecture:** Clean Separation of Concerns using Domain-Driven Design (DDD) principles.

## 🛠️ Tech Stack

- **Framework:** [Flutter](https://flutter.dev/)
- **State Management:** [Riverpod 2.0](https://riverpod.dev/) (with Generators)
- **Routing:** [GoRouter](https://pub.dev/packages/go_router)
- **Networking:** [Dio](https://pub.dev/packages/dio)
- **Storage:** [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
- **Charts:** [FL Chart](https://pub.dev/packages/fl_chart)
- **Icons:** [Cupertino Icons](https://pub.dev/packages/cupertino_icons)
- **Animations:** [Shimmer](https://pub.dev/packages/shimmer) for loading states

## 📂 Project Structure

Following the feature-first approach:

```text
lib/
├── core/                  # Core utilities, routing, and networking
├── features/              # Feature modules (Auth, Expense, Income, etc.)
│   ├── domain/            # Entities and repository interfaces
│   ├── infrastructure/    # API services and repository implementations
│   └── presentation/      # UI Widgets, Screens, and Providers (Riverpod)
├── main.dart              # Application entry point
└── app.dart               # Root MaterialApp configuration
```

## 🚦 Getting Started

### Prerequisites

- Flutter SDK (^3.9.2)
- Android Studio / VS Code with Flutter extension
- An emulator or physical device

### Installation

1.  **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd expense-tracker-frontend
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Configure API base URL:**
    Update your configuration file (e.g., `lib/core/constants/api_constants.dart`) with your backend server URL.

### Running the App

```bash
flutter run
```

### Running Tests

```bash
flutter test
```

## 📸 Screenshots

*(Add screenshots here after generation or implementation)*

## 📄 License

This project is [MIT licensed](LICENSE).

