# Lib Directory Structure

This directory contains the main source code for the Bali Calendar application, organized using clean architecture principles.

## Directory Structure

```
lib/
├── main.dart                    # Application entry point
├── core/                        # Core utilities and configurations
│   ├── constants/              # App-wide constants
│   │   ├── colors.dart         # Color palette
│   │   └── strings.dart        # String constants
│   ├── theme/                  # Theme configuration
│   │   └── app_theme.dart      # Material 3 theme
│   └── utils/                  # Utility functions
│       ├── date_utils.dart     # Date formatting utilities
│       └── validators.dart     # Input validation
├── data/                        # Data layer
│   ├── models/                 # Data models
│   │   ├── saka_date.dart      # Saka calendar model
│   │   ├── pawukon_date.dart   # Pawukon calendar model
│   │   ├── weton.dart          # Weton model
│   │   └── bali_calendar_date.dart # Combined calendar model
│   └── repositories/           # Data access layer (to be added)
├── domain/                      # Business logic layer
│   ├── services/               # Business logic services
│   │   ├── saka_service.dart   # Saka calculations
│   │   ├── pawukon_service.dart # Pawukon calculations
│   │   ├── weton_service.dart  # Weton calculations
│   │   └── bali_calendar_service.dart # Main calendar service
│   └── usecases/               # Use cases (to be added)
└── presentation/                # UI layer
    ├── screens/                # Screen widgets (to be added)
    ├── widgets/                # Reusable widgets (to be added)
    └── providers/              # State management (to be added)
```

## Architecture

The application follows clean architecture principles:

1. **Core**: Contains shared utilities, constants, and configurations
2. **Data**: Handles data models and data access
3. **Domain**: Contains business logic and services
4. **Presentation**: UI components and state management

## Key Features

- **Offline-First**: All calculations performed locally
- **Material 3**: Modern UI with Material Design 3
- **Clean Architecture**: Separation of concerns
- **Type-Safe**: Full Dart type safety
