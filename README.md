# Bali Calendar - Complete Balinese Hindu Calendar App

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey)](https://flutter.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-blue)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
[![Offline](https://img.shields.io/badge/Mode-Offline%20First-orange)](https://developer.android.com/topic/architecture/data-layer/offline-first)

A comprehensive mobile calendar application that integrates traditional Balinese Hindu calendar systems (Saka and Pawukon) with modern mobile technology. This app serves as both a calendar tool and a cultural assistant, providing complete information about Balinese holy days, weton calculations, and AI-powered recommendations for auspicious days.

## 📊 Development Progress

**Current Status**: UI Screens Implementation (Tasks 1-15 / 22) - **68% Complete**

✅ **Completed:**
- Calendar calculation engines (Saka, Pawukon, Weton)
- Holy day database and service (2025-2035)
- Settings and data persistence
- Notification system with local notifications
- Material 3 theme and styling
- Home screen with calendar widget
- Detail day bottom sheet
- Holy days list screen with filtering
- Weton checker screen
- 100+ comprehensive tests

🚧 **In Progress:**
- Navigation and bottom navigation bar
- AI recommender service

📋 **Upcoming:**
- Settings screen
- Final polish and optimization

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
- Smooth animations (60fps)
- Intuitive navigation

### 🔌 Offline-First Architecture
- All calculations performed locally
- No internet connection required
- Human-editable JSON datasets
- Instant app functionality

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
bali-calendar-app/
├── lib/                               # Source code
│   ├── data/
│   │   └── models/
│   │       ├── pawukon_date.dart      # Pawukon calendar model
│   │       ├── saka_date.dart         # Saka calendar model
│   │       ├── bali_calendar_date.dart # Combined calendar model
│   │       └── weton.dart             # Weton model
│   ├── domain/
│   │   └── services/
│   │       ├── pawukon_service.dart   # Pawukon calculation engine
│   │       ├── saka_service.dart      # Saka calculation engine
│   │       ├── bali_calendar_service.dart # Main calendar service
│   │       └── weton_service.dart     # Weton calculator
│   ├── presentation/
│   │   ├── screens/                   # UI screens
│   │   ├── widgets/                   # Reusable widgets
│   │   └── providers/                 # State management
│   └── main.dart                      # App entry point
├── test/                              # Test files
│   ├── complete_calendar_test.dart    # Complete calendar integration test
│   ├── comprehensive_service_test.dart # BaliCalendarService tests
│   ├── pawukon_service_test.dart      # PawukonService unit tests
│   ├── pawukon_utilities_test.dart    # Pawukon utilities tests
│   └── weton_service_test.dart        # WetonService tests
├── doc/                               # Documentation
│   ├── PAWUKON_IMPLEMENTATION_SUMMARY.md
│   ├── WETON_SERVICE_IMPLEMENTATION.md
│   └── README.md                      # Documentation index
├── alg/                               # Algorithm documentation
│   └── algdoc.md
└── README.md                          # This file
```

### Technology Stack

- **Framework**: Flutter 3.x
- **Language**: Dart 3.x
- **State Management**: Provider / Riverpod
- **Local Storage**: SharedPreferences
- **Notifications**: flutter_local_notifications
- **Architecture**: Clean Architecture
- **Design**: Material 3

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

For detailed algorithm documentation, see [Algorithm Documentation](alg/algdoc.md).

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.x or higher
- Dart SDK 3.x or higher
- Android Studio / VS Code with Flutter extensions
- Android SDK (for Android development)
- Xcode (for iOS development, macOS only)

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

3. **Run the app**
   ```bash
   flutter run
   ```

### Running Tests

Run test files to verify calendar calculations:

```bash
# Complete calendar integration test
dart run test/complete_calendar_test.dart

# Comprehensive BaliCalendarService tests
dart run test/comprehensive_service_test.dart

# PawukonService tests
dart run test/pawukon_service_test.dart

# Pawukon utilities tests
dart run test/pawukon_utilities_test.dart

# WetonService tests
dart run test/weton_service_test.dart
```

These tests will verify:
- Current date in Balinese calendar
- All calendar service methods
- Weton calculations
- Special days detection
- Otonan calculations
- Algorithm accuracy

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

## 📊 Data Models

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
- [ ] Settings screen
- [ ] Bottom navigation bar
- [ ] Animations and transitions

### Phase 7: AI Recommender
- [ ] Recommendation algorithm
- [ ] AI recommender screen
- [ ] Day analysis functionality

### Phase 8: Testing & Refinement
- [ ] Comprehensive testing
- [ ] Cultural accuracy verification
- [ ] Performance optimization
- [ ] Bug fixes

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

## 📧 Contact

For questions or suggestions, please open an issue in this repository.

---

**Om Swastyastu** 🙏

May this application be beneficial for the preservation of Balinese culture and traditions.

---

<div align="center">
  <sub>Built with ❤️ for Balinese Hindu community</sub>
</div>
