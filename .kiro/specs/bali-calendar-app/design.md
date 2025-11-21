# Design Document

## Overview

The Bali Calendar application is built using Flutter for cross-platform mobile development, with a clean architecture approach that separates business logic from UI. The app operates entirely offline-first, with all calendar calculations performed locally using algorithmic engines for Saka and Pawukon systems. The design emphasizes modularity, testability, and cultural authenticity while maintaining modern mobile UX standards.

### Key Design Principles

1. **Offline-First**: All data and calculations available locally
2. **Clean Architecture**: Separation of concerns with clear boundaries
3. **Cultural Authenticity**: Accurate implementation of Balinese calendar systems
4. **Performance**: Smooth 60fps animations and instant calculations
5. **Maintainability**: Human-editable data files and modular code structure

## Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────┐
│                     Presentation Layer                   │
│  (Screens, Widgets, State Management)                   │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                     Business Logic Layer                 │
│  (Services, Calendar Engines, AI Recommender)           │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                        Data Layer                        │
│  (Models, JSON Data, Local Storage)                     │
└─────────────────────────────────────────────────────────┘
```

### Technology Stack

- **Framework**: Flutter 3.x (Dart)
- **State Management**: Provider or Riverpod
- **Local Storage**: SharedPreferences (user settings), JSON files (calendar data)
- **Notifications**: flutter_local_notifications
- **Date Handling**: Dart DateTime + custom calendar engines
- **UI**: Material 3 design system

### Folder Structure

```
/lib
  ├─ main.dart                          # App entry point
  ├─ /core
  │   ├─ /constants
  │   │   ├─ colors.dart                # App color scheme
  │   │   └─ strings.dart               # Static text strings
  │   ├─ /utils
  │   │   ├─ date_utils.dart            # Date helper functions
  │   │   └─ validators.dart            # Input validation
  │   └─ /theme
  │       └─ app_theme.dart             # Material 3 theme config
  ├─ /data
  │   ├─ /models
  │   │   ├─ saka_date.dart             # Saka date model
  │   │   ├─ pawukon_date.dart          # Pawukon date model
  │   │   ├─ holy_day.dart              # Holy day model
  │   │   └─ weton.dart                 # Weton model
  │   ├─ /repositories
  │   │   ├─ calendar_repository.dart   # Calendar data access
  │   │   └─ settings_repository.dart   # User settings access
  │   └─ /assets
  │       ├─ saka.json                  # Saka calendar data
  │       ├─ pawukon.json               # Pawukon cycle data
  │       └─ holy_days.json             # Holy days database
  ├─ /domain
  │   ├─ /services
  │   │   ├─ saka_service.dart          # Saka calculation engine
  │   │   ├─ pawukon_service.dart       # Pawukon calculation engine
  │   │   ├─ holy_day_service.dart      # Holy day lookup service
  │   │   ├─ weton_service.dart         # Weton calculator
  │   │   ├─ notification_service.dart  # Notification manager
  │   │   └─ ai_recommender_service.dart # AI day recommender
  │   └─ /usecases
  │       ├─ get_calendar_for_date.dart
  │       ├─ calculate_weton.dart
  │       └─ recommend_auspicious_days.dart
  ├─ /presentation
  │   ├─ /screens
  │   │   ├─ home_screen.dart           # Main calendar view
  │   │   ├─ detail_day_screen.dart     # Day detail bottom sheet
  │   │   ├─ holy_days_screen.dart      # Holy days list
  │   │   ├─ weton_checker_screen.dart  # Weton calculator
  │   │   ├─ ai_recommender_screen.dart # AI day recommender
  │   │   └─ settings_screen.dart       # App settings
  │   ├─ /widgets
  │   │   ├─ calendar_widget.dart       # Monthly calendar grid
  │   │   ├─ event_chip.dart            # Holy day indicator
  │   │   ├─ date_indicator.dart        # Colored dots for events
  │   │   ├─ saka_display.dart          # Saka date display
  │   │   ├─ pawukon_display.dart       # Pawukon date display
  │   │   └─ balinese_pattern.dart      # Background pattern
  │   └─ /providers
  │       ├─ calendar_provider.dart     # Calendar state
  │       ├─ theme_provider.dart        # Theme state
  │       └─ settings_provider.dart     # Settings state
  └─ /assets
      ├─ /images
      │   └─ balinese_patterns.png
      └─ /icons
          └─ custom_icons.dart
```

## Components and Interfaces

### 1. Calendar Engines

#### Saka Service

The Saka Service calculates lunar-based Balinese calendar dates using astronomical principles.

**Interface:**
```dart
class SakaService {
  /// Converts Gregorian date to Saka date
  SakaDate gregorianToSaka(DateTime gregorianDate);
  
  /// Converts Saka date to Gregorian date
  DateTime sakaToGregorian(SakaDate sakaDate);
  
  /// Gets the current Saka date
  SakaDate getCurrentSakaDate();
  
  /// Determines if date is in penanggal (waxing) or panglong (waning) phase
  MoonPhase getMoonPhase(DateTime date);
}
```

**Calculation Algorithm:**
- Base reference: Saka year 1 = 78 CE (Gregorian)
- Lunar month calculation based on synodic month (29.53 days average)
- Penanggal days 1-15 (waxing moon)
- Panglong days 1-15 (waning moon)
- Simplified astronomical calculation without external API

**Data Model:**
```dart
class SakaDate {
  final int year;           // Saka year (e.g., 1946)
  final String sasih;       // Month name (Kasa, Karo, etc.)
  final int day;            // Day number (1-15)
  final MoonPhase phase;    // penanggal or panglong
}

enum MoonPhase { penanggal, panglong }
```

#### Pawukon Service

The Pawukon Service manages the 210-day cyclical calendar system with complete wewaran calculations.

**Interface:**
```dart
class PawukonService {
  /// Converts Gregorian date to Pawukon date with all wewaran
  PawukonDate gregorianToPawukon(DateTime gregorianDate);
  
  /// Gets the current Pawukon date
  PawukonDate getCurrentPawukonDate();
  
  /// Calculates days until next otonan from birth date
  int daysUntilNextOtonan(DateTime birthDate, DateTime currentDate);
  
  /// Checks if a date is Kajeng Kliwon
  bool isKajengKliwon(DateTime date);
  
  /// Gets all Kajeng Kliwon dates in a range
  List<DateTime> getKajengKliwonDates(DateTime start, DateTime end);
}
```

**Calculation Algorithm:**
- 210-day cycle (30 wuku × 7 days)
- Reference point: 2000-01-01 (angkaWuku 70) or 1970-01-01 (angkaWuku 33)
- Calculate day offset from reference
- Calculate angkaWuku position in cycle (1-210)
- Derive wuku: ceil(angkaWuku / 7)
- Derive all 10 wewaran cycles:
  - Eka Wara: Based on urip sum (odd = Luang)
  - Dwi Wara: Based on urip sum (even = Menga)
  - Tri Wara: angkaWuku mod 3
  - Catur Wara: With Jaya Tiga special rule (angkaWuku 71-73)
  - Panca Wara: (angkaWuku mod 5) + 1
  - Sad Wara: angkaWuku mod 6
  - Sapta Wara: Based on weekday
  - Asta Wara: With Kala Tiga special rule (angkaWuku 71-73)
  - Sanga Wara: With Dangu Pat special rule (angkaWuku 1-4)
  - Dasa Wara: ((urip sum) mod 10) + 1

**Data Model:**
```dart
class PawukonDate {
  final int dayInCycle;      // Position in 210-day cycle (0-209)
  final Wuku wuku;            // 1 of 30 wuku
  final EkaWara ekaWara;      // 1-day cycle
  final DwiWara dwiWara;      // 2-day cycle
  final TriWara triWara;      // 3-day cycle
  final CaturWara caturWara;  // 4-day cycle
  final PancaWara pancaWara;  // 5-day cycle
  final SadWara sadWara;      // 6-day cycle
  final SaptaWara saptaWara;  // 7-day cycle
  final AstaWara astaWara;    // 8-day cycle
  final SangaWara sangaWara;  // 9-day cycle
  final DasaWara dasaWara;    // 10-day cycle
  final int urip;             // Total urip/neptu value
}

// Each wewaran has its own class with id, name, and urip
class EkaWara {
  final int id;
  final String name;
  final int urip;
}
// Similar classes for DwiWara through DasaWara
```

#### Holy Day Service

Manages the database of Hindu Balinese holy days.

**Interface:**
```dart
class HolyDayService {
  /// Loads holy days from JSON
  Future<void> loadHolyDays();
  
  /// Gets all holy days for a specific date
  List<HolyDay> getHolyDaysForDate(DateTime date);
  
  /// Gets all holy days in a date range
  List<HolyDay> getHolyDaysInRange(DateTime start, DateTime end);
  
  /// Gets upcoming holy days (next N days)
  List<HolyDay> getUpcomingHolyDays(int days);
  
  /// Checks if a date is a holy day
  bool isHolyDay(DateTime date);
  
  /// Gets holy days by category
  List<HolyDay> getHolyDaysByCategory(HolyDayCategory category);
}
```

**Data Model:**
```dart
class HolyDay {
  final String id;
  final String name;
  final String description;
  final HolyDayCategory category;
  final List<DateTime> dates;  // Pre-calculated dates 2025-2035
  final String culturalSignificance;
}

enum HolyDayCategory {
  purnama,      // Full moon
  tilem,        // New moon
  kajengKliwon, // Kajeng Kliwon
  tumpek,       // Tumpek series
  major,        // Galungan, Kuningan, Nyepi, etc.
  other         // Other observances
}
```

**JSON Structure:**
```json
{
  "holyDays": [
    {
      "id": "galungan",
      "name": "Galungan",
      "description": "Victory of dharma over adharma",
      "category": "major",
      "culturalSignificance": "Celebrates the victory of good over evil...",
      "dates": [
        "2025-03-05",
        "2025-09-24",
        "2026-04-15"
      ]
    }
  ]
}
```

### 2. Weton Calculator

**Interface:**
```dart
class WetonService {
  /// Calculates weton from birth date
  Weton calculateWeton(DateTime birthDate);
  
  /// Gets next otonan date
  DateTime getNextOtonan(DateTime birthDate, DateTime currentDate);
  
  /// Gets all future otonan dates up to a year
  List<DateTime> getFutureOtonans(DateTime birthDate, int count);
  
  /// Gets weton characteristics and meaning
  WetonCharacteristics getCharacteristics(Weton weton);
}
```

**Data Model:**
```dart
class Weton {
  final PawukonDate pawukonDate;
  final DateTime birthDate;
  final String classification;  // Based on wuku + day combination
  final int neptu;              // Numerical value for compatibility
}

class WetonCharacteristics {
  final String personality;
  final String strengths;
  final String guidance;
  final List<String> auspiciousDays;
}
```

### 3. AI Recommender Service

**Interface:**
```dart
class AIRecommenderService {
  /// Recommends auspicious days for an activity
  Future<List<DayRecommendation>> recommendDays({
    required String activityType,
    DateTime? userWeton,
    DateTime startDate,
    int searchDays = 90,
  });
  
  /// Analyzes if a specific date is auspicious
  DayAnalysis analyzeDate(DateTime date, String activityType);
}
```

**Recommendation Algorithm:**
1. Filter out major holy days (not suitable for personal activities)
2. Calculate Dewasa Ayu score based on:
   - Saka phase (penanggal generally more auspicious)
   - Pawukon combinations (certain wuku + day combinations)
   - User weton compatibility (if provided)
   - Activity type requirements
3. Rank dates by score
4. Return top 3 with explanations

**Data Model:**
```dart
class DayRecommendation {
  final DateTime date;
  final double score;  // 0-100
  final String reasoning;
  final SakaDate sakaDate;
  final PawukonDate pawukonDate;
  final List<String> positiveFactors;
  final List<String> considerations;
}

class DayAnalysis {
  final bool isAuspicious;
  final String explanation;
  final List<String> factors;
}
```

### 4. Notification Service

**Interface:**
```dart
class NotificationService {
  /// Initializes notification system
  Future<void> initialize();
  
  /// Schedules notifications for upcoming holy days
  Future<void> scheduleHolyDayNotifications();
  
  /// Schedules otonan reminder
  Future<void> scheduleOtonanReminder(DateTime otonanDate);
  
  /// Cancels all notifications
  Future<void> cancelAllNotifications();
  
  /// Updates notification preferences
  Future<void> updatePreferences(NotificationPreferences prefs);
}
```

**Data Model:**
```dart
class NotificationPreferences {
  final bool enablePurnama;
  final bool enableTilem;
  final bool enableKajengKliwon;
  final bool enableTumpek;
  final bool enableMajorHolidays;
  final bool enableOtonan;
  final int advanceDays;  // 0, 1, 3, 7 days before
  final TimeOfDay notificationTime;
}
```

## Data Models

### Core Models Summary

```dart
// Saka Calendar
class SakaDate {
  final int year;
  final String sasih;
  final int day;
  final MoonPhase phase;
}

// Pawukon Calendar
class PawukonDate {
  final String wuku;
  final String saptawara;
  final String pancawara;
  final String triwara;
  final int dayInCycle;
}

// Combined Calendar Info
class BaliCalendarDate {
  final DateTime gregorianDate;
  final SakaDate sakaDate;
  final PawukonDate pawukonDate;
  final List<HolyDay> holyDays;
}

// Holy Day
class HolyDay {
  final String id;
  final String name;
  final String description;
  final HolyDayCategory category;
  final List<DateTime> dates;
  final String culturalSignificance;
}

// Weton
class Weton {
  final PawukonDate pawukonDate;
  final DateTime birthDate;
  final String classification;
  final int neptu;
}
```

## User Interface Design

### Screen Specifications

#### 1. Home Screen

**Layout:**
- Top App Bar: Current Saka date, settings icon
- Calendar Grid: Monthly view with event indicators
- Bottom Navigation: Home, Holy Days, Weton, AI Recommender

**Visual Elements:**
- Subtle Balinese pattern background (10% opacity)
- Gold accent for current date
- Event dots: 🟡 Holy days, 🔵 Purnama/Tilem, 🔴 Kajeng Kliwon
- Smooth scroll between months

**Interactions:**
- Tap date → Opens detail bottom sheet
- Swipe left/right → Navigate months
- Pull to refresh → Update calculations

#### 2. Detail Day Bottom Sheet

**Layout:**
- Rounded top corners (24px radius)
- Gradient header (sunrise colors)
- Sections: Gregorian, Saka, Pawukon, Holy Days

**Content:**
```
┌─────────────────────────────────┐
│  [Drag Handle]                  │
│                                 │
│  Wednesday, January 24, 2025    │
│                                 │
│  📅 Saka Calendar               │
│  Year 1946, Sasih Kasa          │
│  Penanggal 5                    │
│                                 │
│  🔄 Pawukon Calendar            │
│  Wuku: Sinta                    │
│  Redite (Sunday)                │
│  Umanis, Kajeng                 │
│                                 │
│  ✨ Holy Days                   │
│  • Kajeng Kliwon                │
│    [Description...]             │
│                                 │
└─────────────────────────────────┘
```

#### 3. Holy Days Screen

**Layout:**
- Categorized list with expandable sections
- Search bar at top
- Filter chips (Purnama, Tumpek, Major, etc.)

**List Items:**
```
┌─────────────────────────────────┐
│  🟡 Galungan                    │
│  March 5, 2025                  │
│  Victory of dharma...           │
│  [View Details →]               │
└─────────────────────────────────┘
```

#### 4. Weton Checker Screen

**Layout:**
- Date picker for birth date
- Calculate button
- Results card with weton details
- Next otonan countdown

**Results Display:**
```
┌─────────────────────────────────┐
│  Your Weton                     │
│                                 │
│  🌟 Wuku Sinta                  │
│  📅 Redite Umanis               │
│                                 │
│  Characteristics:               │
│  [Personality traits...]        │
│                                 │
│  Next Otonan:                   │
│  March 15, 2025 (45 days)       │
│                                 │
│  [Set Reminder]                 │
└─────────────────────────────────┘
```

#### 5. AI Recommender Screen

**Layout:**
- Activity type selector (dropdown or chips)
- Optional: User weton input
- Search period selector
- Generate button
- Results list with explanations

**Recommendation Card:**
```
┌─────────────────────────────────┐
│  ⭐ Highly Auspicious            │
│  Score: 92/100                  │
│                                 │
│  March 12, 2025                 │
│  Saka: Penanggal 8, Kasa        │
│  Pawukon: Wuku Landep, Buda     │
│                                 │
│  Why this day:                  │
│  ✓ Penanggal phase (waxing)    │
│  ✓ Compatible with your weton  │
│  ✓ Auspicious wuku combination │
│                                 │
│  [Add to Calendar]              │
└─────────────────────────────────┘
```

### Theme Configuration

**Colors:**
```dart
// Light Theme
primary: Color(0xFFFFD700),        // Gold
secondary: Color(0xFFFF6B35),      // Sunset orange
background: Color(0xFFFAFAFA),     // Off-white
surface: Color(0xFFFFFFFF),        // White
onPrimary: Color(0xFF1A1A1A),      // Dark text

// Dark Theme
primary: Color(0xFFFFD700),        // Gold
secondary: Color(0xFFFF8C42),      // Lighter orange
background: Color(0xFF121212),     // Dark gray
surface: Color(0xFF1E1E1E),        // Slightly lighter
onPrimary: Color(0xFF1A1A1A),      // Dark text

// Event Colors
holyDayColor: Color(0xFFFFD700),   // Gold
purnamaColor: Color(0xFF2196F3),   // Blue
kajengKliwonColor: Color(0xFFF44336), // Red
```

**Typography:**
```dart
headline1: Poppins, 32sp, Bold
headline2: Poppins, 24sp, SemiBold
body1: Inter, 16sp, Regular
body2: Inter, 14sp, Regular
caption: Inter, 12sp, Regular
```

## Error Handling

### Error Categories

1. **Data Loading Errors**
   - JSON file not found or corrupted
   - Invalid JSON structure
   - Missing required fields

**Handling:**
```dart
try {
  await holyDayService.loadHolyDays();
} catch (e) {
  // Show user-friendly error message
  // Fall back to minimal functionality
  // Log error for debugging
  showErrorDialog(
    title: "Data Loading Error",
    message: "Unable to load holy day data. Some features may be limited.",
  );
}
```

2. **Calculation Errors**
   - Invalid date input
   - Date out of supported range
   - Calculation overflow

**Handling:**
```dart
SakaDate? gregorianToSaka(DateTime date) {
  if (date.year < 1900 || date.year > 2100) {
    return null; // Return null for out-of-range dates
  }
  try {
    // Perform calculation
  } catch (e) {
    logError('Saka calculation failed', e);
    return null;
  }
}
```

3. **Notification Errors**
   - Permission denied
   - Scheduling failure
   - Platform-specific issues

**Handling:**
```dart
Future<bool> scheduleNotification() async {
  try {
    final permission = await requestPermission();
    if (!permission) {
      showPermissionDialog();
      return false;
    }
    await _scheduleNotification();
    return true;
  } catch (e) {
    logError('Notification scheduling failed', e);
    return false;
  }
}
```

4. **Storage Errors**
   - SharedPreferences write failure
   - Insufficient storage space

**Handling:**
```dart
Future<void> saveSettings(Settings settings) async {
  try {
    await _prefs.setString('settings', jsonEncode(settings));
  } catch (e) {
    // Notify user but don't crash
    showSnackBar('Unable to save settings');
  }
}
```

### Error Recovery Strategies

- **Graceful Degradation**: App continues with limited functionality
- **Default Values**: Use sensible defaults when data is missing
- **User Notification**: Clear, non-technical error messages
- **Retry Mechanisms**: For transient failures
- **Logging**: Comprehensive error logging for debugging

## Testing Strategy

### Unit Tests

**Coverage Areas:**
1. Calendar calculation engines (Saka, Pawukon)
2. Date conversion functions
3. Weton calculator
4. AI recommender scoring algorithm
5. Data model serialization/deserialization

**Example Test Cases:**
```dart
test('Saka calculation for known date', () {
  final date = DateTime(2025, 1, 1);
  final saka = sakaService.gregorianToSaka(date);
  expect(saka.year, 1946);
  expect(saka.sasih, 'Kapitu');
});

test('Pawukon cycle wraps correctly', () {
  final date1 = DateTime(2025, 1, 1);
  final date2 = date1.add(Duration(days: 210));
  final pawukon1 = pawukonService.gregorianToPawukon(date1);
  final pawukon2 = pawukonService.gregorianToPawukon(date2);
  expect(pawukon1.wuku, pawukon2.wuku);
});

test('Otonan calculation', () {
  final birthDate = DateTime(2000, 1, 1);
  final currentDate = DateTime(2025, 1, 1);
  final nextOtonan = wetonService.getNextOtonan(birthDate, currentDate);
  final daysDiff = nextOtonan.difference(birthDate).inDays;
  expect(daysDiff % 210, 0);
});
```

### Widget Tests

**Coverage Areas:**
1. Calendar widget rendering
2. Event indicator display
3. Bottom sheet interactions
4. Theme switching
5. Navigation flows

**Example Test Cases:**
```dart
testWidgets('Calendar displays current month', (tester) async {
  await tester.pumpWidget(MyApp());
  expect(find.text('January 2025'), findsOneWidget);
});

testWidgets('Tapping date opens detail sheet', (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.tap(find.text('15'));
  await tester.pumpAndSettle();
  expect(find.byType(DetailDaySheet), findsOneWidget);
});
```

### Integration Tests

**Coverage Areas:**
1. End-to-end user flows
2. Data persistence
3. Notification scheduling
4. Cross-screen navigation

**Example Test Cases:**
```dart
testWidgets('Complete weton calculation flow', (tester) async {
  // Navigate to weton checker
  // Enter birth date
  // Tap calculate
  // Verify results displayed
  // Verify otonan date calculated
});
```

### Manual Testing Checklist

- [ ] Verify calendar accuracy against known Balinese calendar sources
- [ ] Test on multiple device sizes (phone, tablet)
- [ ] Test on both Android and iOS
- [ ] Verify dark mode appearance
- [ ] Test notification delivery at scheduled times
- [ ] Verify offline functionality (airplane mode)
- [ ] Test with dates across multiple years
- [ ] Verify cultural accuracy with Balinese cultural experts

### Performance Testing

**Metrics:**
- Calendar rendering: < 16ms per frame (60fps)
- Date calculation: < 10ms per operation
- JSON loading: < 500ms on first launch
- Screen transitions: 200-400ms
- App launch time: < 2 seconds

**Tools:**
- Flutter DevTools for performance profiling
- Frame rendering metrics
- Memory usage monitoring

## Implementation Phases

### Phase 1: Core Foundation (MVP)
- Basic Flutter project setup
- Saka and Pawukon calculation engines
- Simple calendar UI with date display
- JSON data loading

### Phase 2: Holy Days Integration
- Holy day database implementation
- Event indicators on calendar
- Detail day bottom sheet
- Holy days list screen

### Phase 3: Weton Calculator
- Weton calculation service
- Weton checker screen
- Otonan date calculation

### Phase 4: Notifications
- Notification service implementation
- Permission handling
- Notification scheduling
- Settings screen

### Phase 5: UI Polish
- Material 3 theme implementation
- Dark mode support
- Balinese pattern backgrounds
- Animations and transitions

### Phase 6: AI Recommender
- Recommendation algorithm
- AI recommender screen
- Day analysis functionality

### Phase 7: Testing & Refinement
- Comprehensive testing
- Cultural accuracy verification
- Performance optimization
- Bug fixes

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.1.0
  
  # Local Storage
  shared_preferences: ^2.2.0
  
  # Notifications
  flutter_local_notifications: ^16.0.0
  
  # Date/Time
  intl: ^0.18.0
  
  # JSON
  json_annotation: ^4.8.0
  
  # UI
  google_fonts: ^6.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Code Generation
  build_runner: ^2.4.0
  json_serializable: ^6.7.0
  
  # Testing
  mockito: ^5.4.0
  
  # Linting
  flutter_lints: ^3.0.0
```

## Security Considerations

1. **Data Privacy**: No personal data sent to external servers
2. **Local Storage**: User settings encrypted using platform secure storage
3. **Permissions**: Minimal permissions (notifications only)
4. **Input Validation**: All user inputs validated before processing
5. **Error Messages**: No sensitive information in error messages

## Accessibility

1. **Screen Reader Support**: All UI elements properly labeled
2. **Color Contrast**: WCAG AA compliance for text readability
3. **Touch Targets**: Minimum 48x48dp for all interactive elements
4. **Font Scaling**: Support for system font size preferences
5. **Semantic Labels**: Proper semantics for navigation

## Future Enhancements

1. **Widget Support**: Home screen widget showing today's calendar
2. **Sharing**: Share holy day information via social media
3. **Customization**: User-defined local holy days (village-specific)
4. **Multi-language**: Support for Balinese and English languages
5. **Cloud Sync**: Optional cloud backup of user settings
6. **Community Features**: Share auspicious day recommendations
7. **Extended Calendar**: Support for Javanese calendar systems
