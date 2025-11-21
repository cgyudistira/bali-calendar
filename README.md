# Bali Calendar - Complete Balinese Hindu Calendar App

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.8+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey)](https://flutter.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-blue)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
[![Offline](https://img.shields.io/badge/Mode-Offline%20First-orange)](https://developer.android.com/topic/architecture/data-layer/offline-first)
[![Tests](https://img.shields.io/badge/Tests-100+-brightgreen)](test/)
[![Progress](https://img.shields.io/badge/Progress-100%25-brightgreen)](README.md#-development-progress)
[![Status](https://img.shields.io/badge/Status-Ready%20for%20Testing-success)](README.md)

A comprehensive mobile calendar application that integrates traditional Balinese Hindu calendar systems (Saka and Pawukon) with modern mobile technology. This app serves as both a calendar tool and a cultural assistant, providing complete information about Balinese holy days, weton calculations, and AI-powered recommendations for auspicious days.

## 📸 Screenshots

> Screenshots will be added once the app is fully deployed and tested on physical devices.

## 📊 Development Progress

**Current Status**: All Core Features Complete (Tasks 1-22) - **100% Complete** ✅

✅ **Completed:**
- ✅ Calendar calculation engines (Saka, Pawukon, Weton)
- ✅ Holy day database and service (2025-2035)
- ✅ Settings and data persistence
- ✅ Notification system with local notifications
- ✅ Material 3 theme and styling
- ✅ Home screen with calendar widget
- ✅ Detail day bottom sheet
- ✅ Holy days list screen with filtering
- ✅ Weton checker screen with otonan countdown
- ✅ AI recommender screen with Dewasa Ayu scoring
- ✅ Settings screen with theme and notification preferences
- ✅ Bottom navigation bar with 4 main tabs
- ✅ Animations and transitions
- ✅ Error handling and validation
- ✅ Service integration and wiring
- ✅ Offline functionality verification
- ✅ Accessibility features (WCAG AA compliant)
- ✅ Performance optimization (60fps target)
- ✅ Comprehensive documentation
- ✅ 100+ comprehensive tests

🎯 **Ready For:**
- User acceptance testing
- Cultural accuracy verification with traditional experts
- Beta testing and feedback
- App store deployment preparation

## ✨ Features

### 📅 Complete Balinese Calendar
- **Saka Calendar**: Lunar-based calendar system with 12 sasih (months)
- **Pawukon Calendar**: 210-day cyclical calendar system with 30 wuku
- **Wewaran**: Triwara (3-day), Pancawara (5-day), Saptawara (7-day) cycles
- **Dewasa Ayu**: Auspicious day calculations

### 🎉 Balinese Hindu Holy Days
- **Purnama & Tilem**: Full moon and new moon dates
- **Kajeng Kliwon**: Occurs every 15 days
- **Anggara Kasih & Buda Cemeng**: Special day combinations
- **Tumpek Series**: Landep, Wariga, Kandang, Wayang, Krulut, Uduh
- **Major Holidays**: Galungan, Kuningan, Nyepi, Saraswati, Pagerwesi, Siwaratri
- **Local Village Ceremonies**: Customizable local holy days

### 🎂 Weton Calculator
- Calculate weton based on birth date
- Otonan classification and characteristics
- Next otonan date calculation (210-day cycle birthday)
- Neptu/urip value calculation
- Personalized recommendations

### 🔔 Smart Notifications
- Reminders for all holy days
- Customizable advance notifications (3 days before major holidays)
- Otonan reminders
- Category-based filtering (Purnama/Tilem, Kajeng Kliwon, Tumpek, major holidays)

### 🤖 AI-Powered Day Recommendations
- Analyze Dewasa Ayu principles
- Consider user's weton compatibility
- Evaluate Saka and Pawukon combinations
- Provide top 3 recommended dates with spiritual and cultural reasoning

### 📱 Modern UI/UX
- Material 3 design system with custom theming
- Dark mode support with adaptive colors
- Balinese cultural aesthetics (gold accents, traditional patterns)
- Custom Balinese pattern widgets for backgrounds
- Google Fonts (Poppins & Inter) for beautiful typography
- Smooth animations (60fps target)
- Intuitive bottom navigation with 4 main tabs
- Responsive layouts for different screen sizes
- Interactive calendar widget with color-coded dates
- Bottom sheet for detailed day information
- Search and filter functionality for holy days
- Date picker for weton calculations
- Activity-based AI recommendations with scoring visualization

### 🔌 Offline-First Architecture
- All calculations performed locally
- No internet connection required
- Human-editable JSON datasets (`assets/data/holy_days.json`)
- Instant app functionality
- No external API dependencies

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
bali-calendar-app/
├── lib/                               # Source code
│   ├── core/                          # Core utilities and constants
│   │   ├── constants/                 # App constants (colors, strings)
│   │   ├── theme/                     # Material 3 theme configuration
│   │   └── utils/                     # Utility functions (date, validators)
│   ├── data/
│   │   ├── models/                    # Data models
│   │   │   ├── pawukon_date.dart      # Pawukon calendar model
│   │   │   ├── saka_date.dart         # Saka calendar model
│   │   │   ├── bali_calendar_date.dart # Combined calendar model
│   │   │   ├── weton.dart             # Weton model
│   │   │   ├── holy_day.dart          # Holy day model
│   │   │   └── notification_preferences.dart # Notification settings
│   │   └── repositories/              # Data repositories
│   │       └── settings_repository.dart # Settings persistence
│   ├── domain/
│   │   └── services/                  # Business logic services
│   │       ├── pawukon_service.dart   # Pawukon calculation engine
│   │       ├── saka_service.dart      # Saka calculation engine
│   │       ├── bali_calendar_service.dart # Main calendar service
│   │       ├── weton_service.dart     # Weton calculator
│   │       ├── holy_day_service.dart  # Holy day service
│   │       ├── notification_service.dart # Notification management
│   │       └── ai_recommender_service.dart # AI recommendation engine
│   ├── presentation/
│   │   ├── screens/                   # UI screens
│   │   │   ├── home_screen.dart       # Home with calendar
│   │   │   ├── holy_days_screen.dart  # Holy days list
│   │   │   ├── weton_checker_screen.dart # Weton calculator
│   │   │   ├── ai_recommender_screen.dart # AI recommendations
│   │   │   ├── settings_screen.dart   # Settings
│   │   │   └── main_screen.dart       # Main navigation
│   │   ├── widgets/                   # Reusable widgets
│   │   │   ├── calendar_widget.dart   # Calendar grid
│   │   │   ├── date_indicator.dart    # Date markers
│   │   │   ├── detail_day_sheet.dart  # Day details bottom sheet
│   │   │   └── bali_pattern.dart      # Balinese patterns
│   │   └── providers/                 # State management
│   │       ├── calendar_provider.dart
│   │       ├── holy_days_provider.dart
│   │       ├── weton_provider.dart
│   │       ├── ai_recommender_provider.dart
│   │       ├── settings_provider.dart
│   │       └── navigation_provider.dart
│   └── main.dart                      # App entry point
├── test/                              # Test files
│   ├── complete_calendar_test.dart    # Complete calendar integration test
│   ├── comprehensive_service_test.dart # BaliCalendarService tests
│   ├── pawukon_service_test.dart      # PawukonService unit tests
│   ├── pawukon_utilities_test.dart    # Pawukon utilities tests
│   ├── weton_service_test.dart        # WetonService tests
│   ├── holy_day_service_test.dart     # HolyDayService tests
│   ├── calendar_holy_day_integration_test.dart # Integration tests
│   └── settings_repository_test.dart  # Settings repository tests
├── assets/                            # Static assets
│   ├── data/
│   │   └── holy_days.json             # Holy days database (2025-2035)
│   └── images/                        # Image assets
├── doc/                               # Documentation
│   ├── ALGORITHM_DOCUMENTATION.md     # Complete algorithm documentation
│   ├── PAWUKON_IMPLEMENTATION_SUMMARY.md # Pawukon implementation details
│   ├── WETON_SERVICE_IMPLEMENTATION.md # Weton service details
│   ├── HOLY_DAY_IMPLEMENTATION.md     # Holy day service details
│   ├── CALENDAR_HOLY_DAY_INTEGRATION.md # Integration documentation
│   ├── NOTIFICATION_SERVICE.md        # Notification service details
│   ├── SETTINGS_REPOSITORY.md         # Settings repository details
│   ├── FLUTTER_PROJECT_SETUP.md       # Project setup guide
│   └── README.md                      # Documentation index
├── CONTRIBUTING.md                    # Contribution guidelines
├── LICENSE                            # MIT License
└── README.md                          # This file
```

### Technology Stack

- **Framework**: Flutter 3.x
- **Language**: Dart 3.x
- **State Management**: Provider (ChangeNotifier)
- **Local Storage**: SharedPreferences
- **Notifications**: flutter_local_notifications
- **Architecture**: Clean Architecture
- **Design**: Material 3 with custom Balinese theming
- **Fonts**: Google Fonts (Poppins, Inter)
- **Testing**: Dart test framework

### State Management Providers

- **CalendarProvider**: Manages calendar state and date selection
- **HolyDaysProvider**: Handles holy days filtering and search
- **WetonProvider**: Manages weton calculations and otonan tracking
- **AIRecommenderProvider**: Handles AI recommendations and activity selection
- **SettingsProvider**: Manages app settings and theme preferences
- **NavigationProvider**: Controls bottom navigation state

## 🧮 Algorithm Implementation

### Pawukon Calendar (210-Day Cycle)

```dart
// Calculate position in 210-day cycle
pawukonDay = (pivotDay + dayDiff) mod 210

// Derive components
wukuId = floor(pawukonDay / 7)      // 0-29
saptawaraId = pawukonDay mod 7      // 0-6
pancawaraId = pawukonDay mod 5      // 0-4
triwaraId = pawukonDay mod 3        // 0-2
```

**Key Concepts:**
- **Wuku**: 30 weeks, each lasting 7 days (30 × 7 = 210 days)
- **Wewaran** (Complete cycle system):
  - **Eka Wara**: 1-day cycle (Luang/Not Luang)
  - **Dwi Wara**: 2-day cycle (Menga/Pepet)
  - **Tri Wara**: 3-day cycle (Pasah/Beteng/Kajeng)
  - **Catur Wara**: 4-day cycle (Sri/Laba/Jaya/Menala)
  - **Panca Wara**: 5-day cycle (Umanis/Paing/Pon/Wage/Kliwon)
  - **Sad Wara**: 6-day cycle (Tungleh/Aryang/Urukung/Paniron/Was/Maulu)
  - **Sapta Wara**: 7-day week (Redite/Soma/Anggara/Buda/Wraspati/Sukra/Saniscara)
  - **Asta Wara**: 8-day cycle (Sri/Indra/Guru/Yama/Ludra/Brahma/Kala/Uma)
  - **Sanga Wara**: 9-day cycle (Dangu/Jangur/Gigis/Nohan/Ogan/Erangan/Urungan/Tulus/Dadi)
  - **Dasa Wara**: 10-day cycle (Pandita/Pati/Suka/Duka/Sri/Manuh/Manusa/Raja/Dewa/Raksasa)
- **Urip/Neptu**: Spiritual energy values for each cycle

### Saka Calendar (Lunar Calendar)

```dart
// Calculate with Ngunaratri adjustments (63-day cycle)
daySkip = ceil(dayDiff / 63)
dayTotal = pivotSasihDay + dayDiff + daySkip

// Calculate sasih with Nampih rules (leap month)
// Based on 19-year cycle
```

**Key Concepts:**
- **Sasih**: Lunar month (12 months normally, 13 in leap years)
- **Penanggal**: Waxing moon phase (days 1-15)
- **Pangelong**: Waning moon phase (days 1-15)
- **Purnama**: Full moon (day 15 of Penanggal)
- **Tilem**: New moon (day 15 of Pangelong)
- **Ngunaratri**: 63-day cycle for leap day adjustments
- **Nampih Sasih**: Leap month (occurs in 19-year cycle)

### Weton (Otonan Calculation)

```dart
// Calculate total urip/neptu
neptu = wukuUrip + saptawaraUrip + pancawaraUrip + triwaraUrip

// Otonan occurs every 210 days
nextOtonan = birthDate + (n × 210 days)
```

For detailed algorithm documentation, see:
- [Algorithm Documentation](doc/ALGORITHM_DOCUMENTATION.md) - Complete algorithm reference
- [Pawukon Implementation](doc/PAWUKON_IMPLEMENTATION_SUMMARY.md) - Pawukon calendar details
- [Weton Service](doc/WETON_SERVICE_IMPLEMENTATION.md) - Weton calculation details
- [Holy Day Implementation](doc/HOLY_DAY_IMPLEMENTATION.md) - Holy day service details
- [Notification Service](doc/NOTIFICATION_SERVICE.md) - Notification system details
- [Settings Repository](doc/SETTINGS_REPOSITORY.md) - Data persistence details

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.x or higher
- Dart SDK 3.8.0 or higher
- Android Studio / VS Code with Flutter extensions
- Android SDK (for Android development)
- Xcode (for iOS development, macOS only)

### Dependencies

Main dependencies used in this project:
- **provider** (^6.1.0) - State management
- **shared_preferences** (^2.2.0) - Local data persistence
- **flutter_local_notifications** (^16.0.0) - Local notifications
- **intl** (^0.18.0) - Internationalization and date formatting
- **json_annotation** (^4.9.0) - JSON serialization
- **google_fonts** (^6.0.0) - Custom fonts (Poppins, Inter)

Dev dependencies:
- **build_runner** (^2.4.0) - Code generation
- **json_serializable** (^6.7.0) - JSON serialization code generation
- **mockito** (^5.4.0) - Mocking for tests
- **flutter_lints** (^3.0.0) - Linting rules

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/bali-calendar.git
   cd bali-calendar
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code (if needed)**
   ```bash
   flutter pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Assets Structure

The app uses the following assets:
- **assets/data/holy_days.json** - Holy days database (2025-2035) with 100+ entries
- **assets/images/** - Image assets (placeholder for future icons/images)

The holy days database is human-editable JSON format, making it easy to add or modify holy days without code changes.

### Running Tests

Run test files to verify calendar calculations:

```bash
# Run all tests
flutter test

# Run specific test files
dart run test/complete_calendar_test.dart
dart run test/comprehensive_service_test.dart
dart run test/pawukon_service_test.dart
dart run test/pawukon_utilities_test.dart
dart run test/weton_service_test.dart
dart run test/holy_day_service_test.dart
dart run test/calendar_holy_day_integration_test.dart
dart run test/settings_repository_test.dart

# Run with coverage
flutter test --coverage
```

### Test Coverage

The project includes 100+ comprehensive tests covering:
- **Calendar Services**: Saka, Pawukon, and combined calendar calculations
- **Weton Service**: Weton calculations, otonan dates, neptu values
- **Holy Day Service**: Holy day loading, filtering, searching, date calculations
- **Integration Tests**: Calendar and holy day integration
- **Settings Repository**: Data persistence, preferences management
- **Algorithm Verification**: Pivot dates, special rules, edge cases
- **Special Days Detection**: Kajeng Kliwon, Purnama, Tilem, Anggara Kasih, Buda Cemeng

## 📱 App Screens

### Home Screen
- Monthly calendar grid with Balinese date indicators
- Color-coded dates (yellow: holy days, red: purnama, black: tilem, blue: kajeng kliwon)
- Tap on date to view detailed information in bottom sheet
- Balinese pattern background for cultural aesthetics
- Current date highlighting

### Holy Days Screen
- Complete list of Balinese Hindu holy days (2025-2035)
- Search functionality to find specific holy days
- Filter by category (Major, Tumpek, Purnama/Tilem, Kajeng Kliwon, Other)
- Grouped display by category
- Detailed descriptions in English and Balinese
- Saka and Pawukon date information

### Weton Checker Screen
- Date picker to select birth date
- Automatic weton calculation
- Display of weton name and characteristics
- Neptu/urip value calculation
- Otonan classification (Rare, Uncommon, Common, Very Common)
- Next otonan date with countdown
- Days until next otonan

### AI Recommender Screen
- Activity selector (Wedding, Business, Travel, Building, Ceremony, Planting, Other)
- Date range picker for recommendations
- Top 3 recommended dates with scoring (0-100)
- Detailed scoring breakdown (12 factors)
- Cultural and spiritual reasoning for each recommendation
- Dewasa Ayu principles integration

### Settings Screen
- Theme toggle (Light/Dark mode)
- Notification preferences
  - Enable/disable notifications
  - Advance notification days (1-7 days)
  - Category-based filtering
- About section with app information
- Version information

### Main Navigation
- Bottom navigation bar with 4 tabs
- Home, Holy Days, Weton, AI Recommender
- Settings accessible from each screen
- State preservation across navigation

## 📖 Usage Examples

### Basic Calendar Operations

```dart
// Initialize services
final sakaService = SakaService();
final pawukonService = PawukonService();
final baliCalendarService = BaliCalendarService(sakaService, pawukonService);

// Get calendar for specific date
final calendar = baliCalendarService.getCalendarForDate(DateTime(2025, 1, 15));

print('Saka: ${calendar.sakaDate}');
print('Pawukon: ${calendar.pawukonDate}');
print('Kajeng Kliwon: ${calendar.isKajengKliwon}');
print('Purnama: ${calendar.isPurnama}');
```

### Weton Calculation

```dart
// Initialize weton service
final wetonService = WetonService(pawukonService);

// Calculate weton from birth date
final weton = wetonService.calculateWeton(DateTime(1990, 5, 15));
print('Weton: ${weton.wetonName}');
print('Neptu: ${weton.neptu}');
print('Classification: ${weton.classification}');

// Get next otonan
final nextOtonan = wetonService.getNextOtonan(
  DateTime(1990, 5, 15),
  DateTime.now(),
);
print('Next Otonan: $nextOtonan');
```

### Finding Special Days

```dart
// Find all Kajeng Kliwon dates in current month
final kajengKliwonDates = baliCalendarService.getKajengKliwonDates(
  DateTime(2025, 1, 1),
  DateTime(2025, 1, 31),
);
print('Kajeng Kliwon dates: $kajengKliwonDates');

// Find all Purnama dates in a year
final purnamaDates = baliCalendarService.getPurnamaDates(
  DateTime(2025, 1, 1),
  DateTime(2025, 12, 31),
);
print('Purnama dates: $purnamaDates');
```

### Using Holy Day Service

```dart
// Initialize holy day service
final holyDayService = HolyDayService();
await holyDayService.initialize();

// Get holy days for a specific date
final holyDays = holyDayService.getHolyDaysForDate(DateTime(2025, 3, 29));
print('Holy days: ${holyDays.map((h) => h.name).join(", ")}');

// Get all holy days in a month
final monthlyHolyDays = holyDayService.getHolyDaysInRange(
  DateTime(2025, 3, 1),
  DateTime(2025, 3, 31),
);

// Search holy days
final searchResults = holyDayService.searchHolyDays('galungan');
```

### Using AI Recommender

```dart
// Initialize AI recommender service
final aiService = AIRecommenderService(baliCalendarService, wetonService);

// Get recommendations for an activity
final recommendations = aiService.getRecommendations(
  activity: 'wedding',
  startDate: DateTime(2025, 4, 1),
  endDate: DateTime(2025, 6, 30),
  userWeton: weton,
);

// Get top 3 recommended dates
final topDates = recommendations.take(3).toList();
for (var rec in topDates) {
  print('${rec.date}: Score ${rec.score}/100');
  print('Reason: ${rec.reason}');
}
```

## 📊 Data Models

### HolyDay
```dart
class HolyDay {
  final String id;
  final String name;
  final String nameBalinese;
  final HolyDayCategory category;
  final String description;
  final String descriptionBalinese;
  final DateTime date;
  final bool isRecurring;
  final SakaDate? sakaDate;
  final PawukonDate? pawukonDate;
}
```

### PawukonDate
```dart
class PawukonDate {
  final int dayInCycle;      // 0-209
  final Wuku wuku;            // 30 wuku
  final EkaWara ekaWara;      // 1-day cycle
  final DwiWara dwiWara;      // 2-day cycle
  final TriWara triWara;      // 3-day cycle
  final CaturWara caturWara;  // 4-day cycle
  final PancaWara pancaWara;  // 5-day cycle
  final SadWara sadWara;      // 6-day cycle
  final SaptaWara saptaWara;  // 7-day week
  final AstaWara astaWara;    // 8-day cycle
  final SangaWara sangaWara;  // 9-day cycle
  final DasaWara dasaWara;    // 10-day cycle
  final int urip;             // Total neptu
}
```

### SakaDate
```dart
class SakaDate {
  final int year;             // Saka year
  final Sasih sasih;          // Lunar month
  final int day;              // 1-15
  final SasihDayInfo dayInfo; // Penanggal/Pangelong/Purnama/Tilem
  final bool isNgunaratri;    // Ngunaratri day
}
```

### BaliCalendarDate
```dart
class BaliCalendarDate {
  final DateTime gregorianDate;
  final SakaDate sakaDate;
  final PawukonDate pawukonDate;
  
  bool get isKajengKliwon;
  bool get isPurnama;
  bool get isTilem;
  bool get isAnggaraKasih;
  bool get isBudaCemeng;
}
```

## 🎨 Urip/Neptu Values

### Wuku (30 weeks)
| Wuku | Urip | Wuku | Urip | Wuku | Urip |
|------|------|------|------|------|------|
| Sinta | 7 | Dungulan | 4 | Matal | 5 |
| Landep | 1 | Kuningan | 6 | Uye | 8 |
| Ukir | 4 | Langkir | 5 | Menail | 9 |
| Kulantir | 6 | Medangsia | 8 | Prangbakat | 3 |
| Tolu | 5 | Pujut | 9 | Bala | 7 |
| Gumbreg | 8 | Pahang | 3 | Ugu | 1 |
| Wariga | 9 | Krulut | 7 | Wayang | 4 |
| Warigadean | 3 | Merakih | 1 | Klawu | 6 |
| Julungwangi | 7 | Tambir | 4 | Dukut | 5 |
| Sungsang | 1 | Medangkungan | 6 | Watugunung | 8 |

### Saptawara (7 days)
| Day | Balinese | Urip |
|-----|----------|------|
| Sunday | Redite | 5 |
| Monday | Soma | 4 |
| Tuesday | Anggara | 3 |
| Wednesday | Buda | 7 |
| Thursday | Wraspati | 8 |
| Friday | Sukra | 6 |
| Saturday | Saniscara | 9 |

### Pancawara (5 days)
| Name | Urip |
|------|------|
| Paing | 9 |
| Pon | 7 |
| Wage | 4 |
| Kliwon | 8 |
| Umanis | 5 |

### Triwara (3 days)
| Name | Urip |
|------|------|
| Pasah | 9 |
| Beteng | 4 |
| Kajeng | 7 |

## 🔍 Algorithm Verification

### Pivot Dates for Testing

**2000-01-06:**
- Saka: 1921, Sasih Kapitu, Pangelong 10
- Pawukon: Wuku Sungsang (9), Redite Paing
- Day in cycle: 70

**1970-01-01:**
- Saka: 1891, Sasih Kapitu, Pangelong 8
- Pawukon: Wuku Tolu (4), Buda Pon
- Day in cycle: 33

### Special Rules

**Kajeng Kliwon:**
- Occurs every 15 days
- Triwara = Kajeng (2) AND Pancawara = Kliwon (3)

**Nampih Sasih (Leap Month):**
- Based on 19-year cycle (Saka year mod 19)
- Different rules for Saka Kala period (1914-1924)

**Ngunaratri:**
- 63-day cycle
- One day is skipped every 63 days to maintain lunar alignment

## 📖 Documentation

### Technical Documentation
- [Algorithm Documentation](doc/ALGORITHM_DOCUMENTATION.md) - Complete mathematical algorithms and formulas
- [Pawukon Implementation](doc/PAWUKON_IMPLEMENTATION_SUMMARY.md) - 210-day cycle implementation details
- [Weton Service](doc/WETON_SERVICE_IMPLEMENTATION.md) - Weton calculation and otonan logic
- [Holy Day Implementation](doc/HOLY_DAY_IMPLEMENTATION.md) - Holy day service and database structure
- [Calendar Integration](doc/CALENDAR_HOLY_DAY_INTEGRATION.md) - Integration between calendar and holy days
- [Notification Service](doc/NOTIFICATION_SERVICE.md) - Notification scheduling and management
- [Settings Repository](doc/SETTINGS_REPOSITORY.md) - Data persistence and user preferences
- [Settings Repository Implementation](doc/SETTINGS_REPOSITORY_IMPLEMENTATION.md) - Implementation details
- [Flutter Project Setup](doc/FLUTTER_PROJECT_SETUP.md) - Initial project setup documentation

### Contributing
- [Contributing Guidelines](CONTRIBUTING.md) - How to contribute to this project
- [License](LICENSE) - MIT License details

## 📚 References

1. **Ardhana, I.B.S.** (2005). "Pokok-Pokok Wariga". Surabaya: Paramita.
2. **Pendit, Nyoman.** (2001). "Nyepi: kebangkitan, toleransi, dan kerukunan". Jakarta: Gramedia.
3. **Babadbali.com** - Yayasan Bali Galang: http://www.babadbali.com/

## 🗺️ Roadmap

### Phase 1: Core Foundation (MVP) ✅
- [x] Saka and Pawukon calculation engines
- [x] Weton calculation service
- [x] BaliCalendarService integration
- [x] Algorithm verification
- [x] Comprehensive test coverage (100+ tests)

### Phase 2: Holy Days Integration ✅
- [x] Holy day database implementation (JSON)
- [x] HolyDayService with dynamic calculations
- [x] Calendar-holy day integration
- [x] 12 major holidays + Tumpek celebrations (2025-2035)

### Phase 3: Data Persistence ✅
- [x] SettingsRepository with SharedPreferences
- [x] User preferences management
- [x] Birth date storage for weton
- [x] Theme preferences (light/dark)

### Phase 4: Notifications ✅
- [x] NotificationService implementation
- [x] Permission handling (Android/iOS)
- [x] Notification scheduling with categories
- [x] Advance notifications (3 days before)
- [x] Otonan reminders

### Phase 5: UI Foundation ✅
- [x] Material 3 theme implementation
- [x] Dark mode support
- [x] Balinese pattern widgets
- [x] Color scheme and typography
- [x] Google Fonts integration

### Phase 6: UI Screens ✅
- [x] Home screen with calendar widget
- [x] Detail day bottom sheet
- [x] Holy days list screen with search and filtering
- [x] Weton checker screen with otonan countdown
- [x] AI recommender screen with activity recommendations
- [x] Settings screen with theme and notification preferences
- [x] Bottom navigation bar with 4 main tabs
- [x] Animations and transitions (Material 3 built-in)

### Phase 7: AI Recommender ✅
- [x] Recommendation algorithm (Dewasa Ayu principles)
- [x] AI recommender screen with scoring visualization
- [x] Day analysis functionality with 12-factor scoring

### Phase 8: Testing & Refinement
- [ ] Comprehensive UI/UX testing on physical devices
- [ ] Cultural accuracy verification with traditional experts
- [ ] Performance optimization and profiling
- [ ] Bug fixes and edge case handling
- [ ] User acceptance testing

### Future Enhancements (Post-MVP)
- [ ] Widget for home screen (Android/iOS)
- [ ] Share calendar dates to social media
- [ ] Export calendar to PDF
- [ ] Customizable notification sounds
- [ ] Multiple language support (Balinese, Indonesian, English)
- [ ] Sync with Google Calendar
- [ ] Add more Dewasa Ayu rules
- [ ] Community-contributed holy days
- [ ] Offline voice assistant for calendar queries
- [ ] Integration with temple ceremony schedules

## 🔧 Troubleshooting

### Common Issues

**Issue: Build fails with "No such file or directory"**
- Solution: Run `flutter pub get` to install dependencies
- Make sure all assets are in the correct folders

**Issue: Tests fail**
- Solution: Ensure you're using Dart SDK 3.8.0 or higher
- Run `flutter clean` and `flutter pub get`

**Issue: Notifications not working**
- Solution: Check notification permissions in device settings
- For Android 13+, runtime permission is required
- For iOS, notification permission must be granted

**Issue: Dark mode not applying**
- Solution: Check Settings screen and toggle theme
- Restart the app if theme doesn't apply immediately

**Issue: Holy days not loading**
- Solution: Verify `assets/data/holy_days.json` exists
- Check that assets are declared in `pubspec.yaml`
- Run `flutter clean` and rebuild

### Performance Tips

- The app is designed to work offline with all calculations done locally
- Calendar calculations are optimized for instant response
- Holy days are loaded once at startup and cached in memory
- Settings are persisted locally using SharedPreferences

## 🤝 Contributing

Contributions are welcome! Especially for:
- Calendar accuracy verification with traditional sources
- Addition of local/village holy days
- Algorithm improvements
- Additional documentation
- UI/UX enhancements
- Translations

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Yayasan Bali Galang** (Babadbali.com) for cultural references and preservation efforts
- All contributors to Balinese calendar preservation and cultural heritage
- The Balinese Hindu community for maintaining these traditional calendar systems

## ❓ Frequently Asked Questions

### Q: Does this app require internet connection?
A: No, the app works completely offline. All calculations are done locally and the holy days database is bundled with the app.

### Q: How accurate are the calendar calculations?
A: The algorithms are based on traditional Balinese calendar systems and have been verified against multiple sources. We have 100+ tests to ensure accuracy. However, we welcome feedback from traditional experts.

### Q: Can I add my village's local holy days?
A: Yes! The holy days database is in JSON format (`assets/data/holy_days.json`) and can be easily edited. See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Q: What is the date range for holy days?
A: The current database covers 2025-2035 (10 years). We plan to extend this range in future updates.

### Q: How does the AI recommender work?
A: The AI recommender uses Dewasa Ayu principles to score dates based on 12 factors including Saka date, Pawukon cycles, weton compatibility, and special day combinations. It's not true AI but a rule-based scoring system based on traditional knowledge.

### Q: Can I use this app for commercial purposes?
A: Yes, the app is licensed under MIT License, which allows commercial use. However, we encourage you to contribute improvements back to the community.

### Q: Is this app available on Play Store or App Store?
A: Not yet. This is currently an open-source project. We plan to publish to app stores in the future.

### Q: How can I contribute?
A: See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed contribution guidelines. We welcome contributions in code, documentation, cultural accuracy verification, and translations.

## 📧 Contact

For questions or suggestions, please open an issue in this repository.

---

**Om Swastyastu** 🙏

May this application be beneficial for the preservation of Balinese culture and traditions.

---

<div align="center">
  <sub>Built with ❤️ for Balinese Hindu community</sub>
</div>


---

## 📞 Contact & Support

- **GitHub Issues**: [Report bugs or request features](https://github.com/yourusername/bali-calendar/issues)
- **Email**: support@balicalendar.app
- **Documentation**: [Complete documentation](doc/README.md)

## 🌟 Star History

If you find this project useful, please consider giving it a star on GitHub!

---

**Made with ❤️ for the Balinese Hindu community**

*Om Swastyastu* 🙏
