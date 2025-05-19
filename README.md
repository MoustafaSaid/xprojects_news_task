# XProjects News App

A modern Flutter application for browsing and reading news articles with a clean and intuitive user interface.

## Features

- 📰 Browse latest news articles
- 🔍 Search functionality
- 🌐 Multi-language support
- 💾 Offline caching
- 🎨 Modern UI with custom fonts
- 📱 Responsive design for all screen sizes

## Technical Stack

- **Framework**: Flutter
- **State Management**: Flutter Bloc
- **Dependency Injection**: GetIt
- **Networking**: Dio with Retrofit
- **Local Storage**: Hive
- **Image Caching**: Cached Network Image
- **Localization**: Easy Localization
- **UI Components**: Custom implementation with Flutter ScreenUtil

## Getting Started

### Prerequisites

- Flutter SDK (^3.6.1)
- Dart SDK
- Android Studio / VS Code
- iOS development tools (for iOS development)

### Installation

1. Clone the repository:
```bash
git clone [repository-url]
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── core/           # Core functionality and utilities
├── features/       # Feature-based modules
└── main.dart       # Application entry point
```

## Dependencies

- **cached_network_image**: ^3.4.1
- **dio**: ^5.8.0+1
- **flutter_bloc**: ^9.1.1
- **get_it**: ^8.0.3
- **hive**: ^2.2.3
- **retrofit**: ^4.4.2
- **easy_localization**: ^3.0.7+1
- **flutter_screenutil**: ^5.9.3

## Development

The project follows clean architecture principles and is organized into features. Each feature contains its own:
- Data layer (repositories, data sources)
- Domain layer (entities, use cases)
- Presentation layer (UI, BLoC)

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request


