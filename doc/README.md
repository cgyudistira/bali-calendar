# Documentation

This folder contains implementation documentation for the Bali Calendar App.

## Documentation Files

### ALGORITHM_DOCUMENTATION.md
Dokumentasi lengkap algoritma kalender Bali:
- Pawukon Calendar (210-day cycle) dengan semua wewaran
- Saka Calendar (lunar calendar) dengan Ngunaratri dan Nampih Sasih
- Weton calculation dan Otonan
- Complete Urip/Neptu values
- Special rules (Jaya Tiga, Kala Tiga, Dangu Pat)
- Implementation notes dan testing guidelines

### PAWUKON_IMPLEMENTATION_SUMMARY.md
Complete documentation of Pawukon Calendar Engine implementation (Task 3):
- PawukonService implementation with all 10 wewaran
- Utility methods (Kajeng Kliwon, Otonan calculations)
- Special rules (Jaya Tiga, Kala Tiga, Dangu Pat)
- Test results dan verifikasi

### WETON_SERVICE_IMPLEMENTATION.md
Complete documentation of WetonService implementation (Task 4.1):
- calculateWeton implementation with neptu calculation
- Otonan date calculations
- Weton characteristics dan guidance
- Test results dan verifikasi

### FLUTTER_PROJECT_SETUP.md
Dokumentasi setup Flutter project (Task 6)

### HOLY_DAY_IMPLEMENTATION.md
Documentation of holy days system implementation (Tasks 7-8)

### SETTINGS_REPOSITORY.md
Documentation of settings repository implementation (Task 9)

### NOTIFICATION_SERVICE.md
Documentation of notification service implementation (Task 10)

### CALENDAR_HOLY_DAY_INTEGRATION.md
Documentation of calendar integration with holy days (Task 8)

## Project Structure

```
bali-calendar-app/
├── lib/                    # Source code
│   ├── data/              # Data models
│   └── domain/            # Business logic (services)
├── test/                  # Test files
│   ├── complete_calendar_test.dart
│   ├── comprehensive_service_test.dart
│   ├── pawukon_service_test.dart
│   ├── pawukon_utilities_test.dart
│   └── weton_service_test.dart
├── doc/                   # Documentation
│   ├── ALGORITHM_DOCUMENTATION.md
│   ├── PAWUKON_IMPLEMENTATION_SUMMARY.md
│   ├── WETON_SERVICE_IMPLEMENTATION.md
│   ├── FLUTTER_PROJECT_SETUP.md
│   ├── HOLY_DAY_IMPLEMENTATION.md
│   ├── SETTINGS_REPOSITORY.md
│   ├── NOTIFICATION_SERVICE.md
│   ├── CALENDAR_HOLY_DAY_INTEGRATION.md
│   └── README.md
└── README.md             # Project README
```

## Menjalankan Tests

Untuk menjalankan test files:

```bash
# Test lengkap kalender Bali
dart run test/complete_calendar_test.dart

# Test comprehensive BaliCalendarService
dart run test/comprehensive_service_test.dart

# Test PawukonService
dart run test/pawukon_service_test.dart

# Test Pawukon utilities
dart run test/pawukon_utilities_test.dart

# Test WetonService
dart run test/weton_service_test.dart
```

## Implementation Status

✅ Task 1: Saka Calendar Service - COMPLETE
✅ Task 2: Saka Date Models - COMPLETE
✅ Task 3: Pawukon Calendar Engine - COMPLETE
✅ Task 4.1: WetonService - COMPLETE
✅ Task 5.1: BaliCalendarService - COMPLETE

## Notes

All implementations have been verified and tested. This documentation will be continuously updated as new features are implemented.
