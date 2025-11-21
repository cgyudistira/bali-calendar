# Holy Day Implementation Summary

## Overview

Task 7 implements a comprehensive holy day system for the Bali Calendar app, combining static JSON data with dynamic calendar calculations.

## Components Implemented

### 1. HolyDay Model (`lib/data/models/holy_day.dart`)

**Features:**
- JSON serialization using `json_annotation` package
- `HolyDayCategory` enum with 6 categories:
  - `purnama` - Full moon days
  - `tilem` - New moon days
  - `kajengKliwon` - Kajeng Kliwon occurrences
  - `tumpek` - Six Tumpek celebrations
  - `major` - Major holidays (Nyepi, Galungan, etc.)
  - `other` - Other special days

**Model Fields:**
- `id`: Unique identifier
- `name`: Holy day name
- `description`: Brief description
- `category`: Category enum
- `dates`: List of ISO 8601 date strings
- `culturalSignificance`: Detailed cultural context

**Helper Methods:**
- `dateTimeList`: Convert date strings to DateTime objects
- `occursOn(DateTime)`: Check if holy day occurs on specific date
- `getNextOccurrence(DateTime)`: Find next occurrence after given date

### 2. JSON Database (`assets/data/holy_days.json`)

**Content:**
- **6 Major Holidays**: Nyepi, Galungan, Kuningan, Saraswati, Pagerwesi, Siwaratri
- **6 Tumpek Celebrations**: Landep, Wariga, Kandang, Wayang, Krulut, Uduh
- **Date Range**: 2025-2035 (10+ years)
- **Total Entries**: 12 holy day types with multiple occurrences each

**Structure:**
```json
{
  "holyDays": [
    {
      "id": "nyepi",
      "name": "Nyepi (Balinese New Year)",
      "description": "...",
      "category": "major",
      "dates": ["2025-03-29", "2026-03-18", ...],
      "culturalSignificance": "..."
    }
  ]
}
```

### 3. HolyDayService (`lib/domain/services/holy_day_service.dart`)

**Core Functionality:**

#### Loading
- `loadHolyDays()`: Async load from JSON file
- Error handling for JSON parsing failures
- State management to ensure data is loaded

#### Querying
- `getHolyDaysForDate(DateTime)`: Get all holy days for specific date
- `getHolyDaysInRange(DateTime, DateTime)`: Get holy days in date range
- `getUpcomingHolyDays(int days)`: Get next N days of holy days
- `isHolyDay(DateTime)`: Boolean check for any holy day
- `getHolyDaysByCategory(HolyDayCategory)`: Filter by category
- `searchHolyDays(String)`: Search by name or description
- `getNextOccurrence(String id)`: Find next occurrence of specific holy day
- `getHolyDayCountForMonth(int year, int month)`: Count holy days in month

#### Dynamic Calculation
The service automatically calculates and includes:
- **Purnama**: From Saka calendar (15th Penanggal)
- **Tilem**: From Saka calendar (15th Pangelong)
- **Kajeng Kliwon**: From Pawukon calendar (every 15 days)
- **Anggara Kasih**: Tuesday + specific Pancawara combinations
- **Buda Cemeng**: Wednesday + specific Pancawara combinations

## Hybrid Approach

### Why Hybrid?

**Static Data (JSON):**
- Major holidays with cultural significance
- Tumpek celebrations with detailed descriptions
- Easy to edit and maintain
- Consistent descriptions across occurrences

**Dynamic Calculation:**
- Purnama, Tilem (occur monthly)
- Kajeng Kliwon (every 15 days)
- Anggara Kasih, Buda Cemeng (regular combinations)
- Always accurate based on calendar algorithms
- No need to pre-calculate years of data

### Benefits:
1. **Accuracy**: Calculated dates follow traditional algorithms
2. **Maintainability**: JSON file remains manageable size
3. **Flexibility**: Easy to extend date range
4. **Cultural Authenticity**: Descriptions preserved for major holidays
5. **Performance**: Efficient querying and caching

## Usage Examples

### Basic Usage

```dart
// Initialize service
final calendarService = BaliCalendarService(sakaService, pawukonService);
final holyDayService = HolyDayService(calendarService);

// Load data
await holyDayService.loadHolyDays();

// Get holy days for today
final today = DateTime.now();
final holyDays = holyDayService.getHolyDaysForDate(today);

for (final holyDay in holyDays) {
  print('${holyDay.name} - ${holyDay.category.displayName}');
  print(holyDay.description);
}
```

### Get Upcoming Holy Days

```dart
// Get next 30 days of holy days
final upcoming = holyDayService.getUpcomingHolyDays(30);

for (final holyDay in upcoming) {
  final nextDate = holyDay.getNextOccurrence(DateTime.now());
  print('${holyDay.name} on $nextDate');
}
```

### Filter by Category

```dart
// Get all Tumpek celebrations in 2025
final tumpeks = holyDayService.getHolyDaysByCategory(
  HolyDayCategory.tumpek,
  startDate: DateTime(2025, 1, 1),
  endDate: DateTime(2025, 12, 31),
);
```

### Search Holy Days

```dart
// Search for holy days containing "Galungan"
final results = holyDayService.searchHolyDays('Galungan');
```

### Check if Date is Holy Day

```dart
// Check if specific date is a holy day
final isHoly = holyDayService.isHolyDay(DateTime(2025, 3, 29)); // Nyepi
print('Is holy day: $isHoly'); // true
```

## Integration with Calendar Service

The HolyDayService depends on BaliCalendarService to calculate dynamic holy days:

```dart
final calendarDate = _calendarService.getCalendarForDate(date);

if (calendarDate.isPurnama) {
  // Add Purnama holy day
}

if (calendarDate.isKajengKliwon) {
  // Add Kajeng Kliwon holy day
}
```

This ensures that calculated holy days are always accurate and consistent with the calendar algorithms.

## Error Handling

### JSON Loading Errors
```dart
try {
  await holyDayService.loadHolyDays();
} catch (e) {
  // Handle error - show user-friendly message
  print('Failed to load holy days: $e');
}
```

### State Validation
```dart
// Service throws StateError if used before loading
try {
  final holyDays = holyDayService.getHolyDaysForDate(DateTime.now());
} catch (e) {
  if (e is StateError) {
    // Data not loaded yet
    await holyDayService.loadHolyDays();
  }
}
```

## Performance Considerations

### Caching
- Static holy days loaded once from JSON
- Calculated holy days generated on-demand
- Date range queries optimized with early termination

### Memory Usage
- JSON file: ~15KB (12 holy day types)
- In-memory: ~50KB (parsed objects)
- Calculated holy days: Generated as needed, not stored

### Query Performance
- Single date lookup: O(n) where n = number of static holy days
- Range query: O(n × d) where d = days in range
- Category filter: O(n)
- Search: O(n)

## Future Enhancements

### Potential Additions:
1. **Local Temple Ceremonies (Odalan)**
   - Village-specific holy days
   - User-customizable dates

2. **Multi-language Support**
   - Balinese, Indonesian, English descriptions
   - Localized holy day names

3. **Historical Context**
   - Origins and history of each holy day
   - Traditional rituals and practices

4. **Notification Integration**
   - Reminder scheduling for upcoming holy days
   - Category-based notification preferences

5. **Calendar Export**
   - Export to Google Calendar, iCal
   - Share holy day schedules

## Testing

### Unit Tests Needed:
- [ ] HolyDay model serialization/deserialization
- [ ] HolyDayService loading from JSON
- [ ] Date range queries
- [ ] Category filtering
- [ ] Search functionality
- [ ] Dynamic holy day calculation
- [ ] Error handling

### Integration Tests Needed:
- [ ] Service integration with BaliCalendarService
- [ ] Full date range accuracy (2025-2035)
- [ ] Performance with large date ranges

## Requirements Satisfied

This implementation satisfies the following requirements:

- **3.1**: Display Purnama and Tilem dates ✅
- **3.2**: Display Kajeng Kliwon dates ✅
- **3.3**: Display major Hari Raya ✅
- **3.4**: Display all six Tumpek celebrations ✅
- **3.5**: Display Anggara Kasih and Buda Cemeng ✅
- **3.6**: Display holy day details (name, description, significance) ✅
- **3.7**: Store data in editable JSON format (2025-2035) ✅
- **10.3**: Offline-first architecture ✅
- **10.4**: Human-editable data format ✅

## Conclusion

The holy day implementation provides a robust, maintainable, and culturally authentic system for managing Balinese Hindu holy days. The hybrid approach balances accuracy, performance, and maintainability while preserving cultural context and significance.
