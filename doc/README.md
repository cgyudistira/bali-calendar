# Documentation

Folder ini berisi dokumentasi implementasi untuk Bali Calendar App.

## File Dokumentasi

### PAWUKON_IMPLEMENTATION_SUMMARY.md
Dokumentasi lengkap implementasi Pawukon Calendar Engine (Task 3):
- Implementasi PawukonService dengan semua 10 wewaran
- Utility methods (Kajeng Kliwon, Otonan calculations)
- Special rules (Jaya Tiga, Kala Tiga, Dangu Pat)
- Test results dan verifikasi

### WETON_SERVICE_IMPLEMENTATION.md
Dokumentasi lengkap implementasi WetonService (Task 4.1):
- Implementasi calculateWeton dengan neptu calculation
- Otonan date calculations
- Weton characteristics dan guidance
- Test results dan verifikasi

## Struktur Proyek

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
│   ├── PAWUKON_IMPLEMENTATION_SUMMARY.md
│   └── WETON_SERVICE_IMPLEMENTATION.md
├── alg/                   # Algorithm documentation
│   └── algdoc.md
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

## Status Implementasi

✅ Task 1: Saka Calendar Service - COMPLETE
✅ Task 2: Saka Date Models - COMPLETE
✅ Task 3: Pawukon Calendar Engine - COMPLETE
✅ Task 4.1: WetonService - COMPLETE
✅ Task 5.1: BaliCalendarService - COMPLETE

## Catatan

Semua implementasi telah diverifikasi dan ditest. Dokumentasi ini akan terus diupdate seiring dengan progress implementasi fitur-fitur baru.
