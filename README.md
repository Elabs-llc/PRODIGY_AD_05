# QR Code Pro 🎯

<div align="center">

[![Flutter](https://img.shields.io/badge/Flutter-3.5+-02569B?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.5+-0175C2?style=for-the-badge&logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

**Production-ready QR Code Scanner & Generator built with enterprise-grade architecture**

[Features](#features) • [Architecture](#architecture) • [Installation](#installation) • [Usage](#usage) • [Contributing](#contributing)

</div>

---

## 📱 Overview

QR Code Pro is a professional, production-ready Flutter application for scanning and generating QR codes. Built following Google's best practices and clean architecture principles, it provides enterprise-level features with a beautiful, Material Design 3 interface.

## ✨ Features

### Core Functionality
- 📷 **Advanced QR Code Scanner** - Real-time scanning with mobile_scanner
- 🎨 **Customizable QR Generator** - Create QR codes with custom colors and styles
- 💾 **Smart History Management** - Automatically save and organize all QR codes
- ⭐ **Favorites System** - Mark important QR codes for quick access
- 🔍 **Powerful Search** - Find QR codes instantly with full-text search

### Security & Validation
- 🔒 **Input Validation** - Comprehensive validation for all QR code data
- 🛡️ **Security Scanning** - Automatic detection of malicious patterns (XSS, SQL injection)
- 🔐 **Local Storage** - All data encrypted and stored securely on device
- ⚠️ **Safety Warnings** - Alerts for potentially dangerous content

### User Experience
- 🎯 **Material Design 3** - Modern, beautiful UI following latest guidelines
- 🌓 **Dark/Light Theme** - Automatic or manual theme switching
- 📊 **QR Type Detection** - Automatic detection of URL, email, phone, WiFi, etc.
- 📤 **Easy Sharing** - Share QR codes via any platform
- 📋 **Quick Copy** - One-tap clipboard functionality
- 🔗 **Smart Actions** - Direct actions for URLs, emails, and phone numbers

### Advanced Features
- 💿 **Export Options** - Save as PNG with high quality
- 📱 **Cross-Platform** - iOS, Android, Web, Windows, macOS, Linux
- 🎨 **Color Customization** - Customize QR code and background colors
- 📝 **Title & Notes** - Add metadata to generated codes
- 🔄 **Auto-save History** - Never lose a scanned or generated code
- ⚡ **Fast Performance** - Optimized for speed and efficiency

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/
│   ├── constants/        # App-wide constants
│   ├── errors/          # Custom exceptions and failures
│   ├── theme/           # Material Design 3 theming
│   ├── utils/           # Validators and utilities
│   └── logging/         # Centralized logging
│
├── data/
│   ├── models/          # Data models with Hive serialization
│   ├── datasources/     # Local storage implementation
│   └── repositories/    # Repository implementations
│
├── domain/
│   ├── entities/        # Business entities
│   ├── repositories/    # Repository interfaces
│   └── usecases/        # Business logic
│
├── presentation/
│   ├── providers/       # Riverpod state management
│   ├── pages/          # UI screens
│   └── widgets/        # Reusable widgets
│
└── main.dart           # App entry point
```

### Key Design Patterns
- ✅ **Clean Architecture** - Separation of concerns
- ✅ **Repository Pattern** - Data abstraction layer
- ✅ **Provider Pattern** - State management with Riverpod
- ✅ **Either Pattern** - Functional error handling with dartz
- ✅ **Dependency Injection** - Loosely coupled components

## 🛠️ Technologies & Dependencies

### Core
- **Flutter SDK** - 3.5.3+
- **Dart** - 3.5.3+
- **flutter_riverpod** - State management
- **hive** - Fast, local database
- **dartz** - Functional programming (Either, Option)

### QR Code
- **mobile_scanner** - Modern QR scanner
- **qr_flutter** - Advanced QR generation
- **barcode_widget** - QR code widgets

### Storage & Security
- **hive_flutter** - NoSQL database
- **shared_preferences** - Key-value storage
- **encrypt** - Data encryption
- **crypto** - Cryptographic functions

### UI/UX
- **Material Design 3** - Latest design system
- **animations** - Smooth transitions
- **share_plus** - Native sharing
- **url_launcher** - Open links

### Utilities
- **logger** - Beautiful console logging
- **intl** - Internationalization
- **uuid** - Unique identifiers
- **permission_handler** - Runtime permissions

### Development
- **very_good_analysis** - Strict linting rules
- **build_runner** - Code generation
- **mockito** - Testing mocks

## 📦 Installation

### Prerequisites
- Flutter SDK 3.5.3 or higher
- Dart SDK 3.5.3 or higher
- Android Studio / VS Code
- Xcode (for iOS development)

### Setup

1. **Clone the repository**
```bash
git clone https://github.com/Elabs-llc/PRODIGY_AD_05.git
cd PRODIGY_AD_05
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate code** (for Hive adapters)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Run the app**
```bash
flutter run
```

### Platform-Specific Setup

#### Android
- Minimum SDK: 21
- Target SDK: 34
- Required permissions: Camera, Storage

#### iOS
- Minimum iOS: 12.0
- Required: Camera usage description in Info.plist

#### Web
- Modern browsers with camera support

## 🚀 Usage

### Scanning QR Codes
1. Launch the app and tap **"Scan QR Code"**
2. Grant camera permissions when prompted
3. Align QR code within the frame
4. View results with automatic type detection
5. Copy, share, or open the content

### Generating QR Codes
1. Tap **"Generate QR"** from home screen
2. Enter your content (text, URL, etc.)
3. Customize colors if desired
4. Tap **"Generate QR Code"**
5. Share, save, or copy the generated code

### Managing History
1. Navigate to **"History"** tab
2. Search, filter, or browse all codes
3. Mark favorites with the star icon
4. Tap any item to view details
5. Swipe or tap delete to remove items

### Settings
1. Go to **"Settings"** tab
2. Choose theme (Light/Dark/System)
3. View app version and licenses
4. Manage data and privacy options

## 🏆 Code Quality

This project maintains high code quality standards:

- ✅ **Clean Architecture** - Maintainable, testable code
- ✅ **SOLID Principles** - Object-oriented best practices
- ✅ **Error Handling** - Comprehensive error management
- ✅ **Logging** - Detailed logging for debugging
- ✅ **Validation** - Input validation at all levels
- ✅ **Security** - Protection against common vulnerabilities
- ✅ **Performance** - Optimized for speed and efficiency
- ✅ **Accessibility** - WCAG-compliant UI

## 📝 Project Structure

```
PRODIGY_AD_05/
├── lib/
│   ├── core/                 # Core utilities
│   ├── data/                 # Data layer
│   ├── domain/               # Business logic
│   ├── presentation/         # UI layer
│   └── main.dart
├── assets/                   # Images, fonts
├── test/                     # Unit tests
├── integration_test/         # Integration tests
├── android/                  # Android platform
├── ios/                      # iOS platform
├── web/                      # Web platform
├── pubspec.yaml             # Dependencies
└── README.md                # This file
```

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Coding Standards
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `very_good_analysis` linting rules
- Write tests for new features
- Document public APIs
- Keep PRs focused and atomic

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

**Elabs LLC**
- GitHub: [@Elabs-llc](https://github.com/Elabs-llc)
- Repository: [PRODIGY_AD_05](https://github.com/Elabs-llc/PRODIGY_AD_05)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for design guidelines
- Open source community for excellent packages

## 📞 Support

For support, please:
- Open an issue on [GitHub Issues](https://github.com/Elabs-llc/PRODIGY_AD_05/issues)
- Check existing documentation
- Review the code examples

---

<div align="center">

**Built with ❤️ using Flutter**

[⬆ Back to Top](#qr-code-pro-)

</div>