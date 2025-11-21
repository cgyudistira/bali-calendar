# Holy Days Data Structure

## Overview

The Bali Calendar app uses a hybrid approach for holy day data:

1. **Static JSON Data**: Major holidays and Tumpek celebrations with fixed cultural significance
2. **Dynamic Calculation**: Regular occurrences (Purnama, Tilem, Kajeng Kliwon) calculated by services

## JSON Structure

The `holy_days.json` file contains:

### Major Holidays (category: "major")
- **Nyepi**: Balinese New Year (Day of Silence)
- **Galungan**: Victory of dharma over adharma (every 210 days)
- **Kuningan**: End of Galungan (10 days after Galungan)
- **Saraswati**: Day of knowledge and learning
- **Pagerwesi**: Day to strengthen spiritual defenses
- **Siwaratri**: Night of Lord Shiva

### Tumpek Celebrations (category: "tumpek")
- **Tumpek Landep**: Blessing of metal objects and vehicles
- **Tumpek Wariga/Uduh**: Blessing of plants and trees
- **Tumpek Kandang**: Blessing of animals
- **Tumpek Wayang**: Blessing of children and wayang art
- **Tumpek Krulut**: Blessing of musical instruments
- **Tumpek Uduh**: Alternative plant blessing day

## Dynamically Calculated Holy Days

The following holy days are calculated by the app services:

### From Saka Calendar (SakaService)
- **Purnama** (category: "purnama"): Full moon - 15th day of Penanggal phase
- **Tilem** (category: "tilem"): New moon - 15th day of Pangelong phase

### From Pawukon Calendar (PawukonService)
- **Kajeng Kliwon** (category: "kajengKliwon"): Occurs every 15 days when Triwara = Kajeng AND Pancawara = Kliwon

### From Combined Calendars (BaliCalendarService)
- **Anggara Kasih** (category: "other"): Tuesday (Anggara) + specific Pancawara combinations
- **Buda Cemeng** (category: "other"): Wednesday (Buda) + specific Pancawara combinations

## Date Format

All dates in the JSON file use ISO 8601 format: `YYYY-MM-DD`

Example: `"2025-03-29"` for March 29, 2025

## Date Range

The JSON file contains dates from 2025 through 2035 (10+ years of data).

## Why Hybrid Approach?

### Advantages:
1. **Accuracy**: Calculated dates are always correct based on calendar algorithms
2. **Maintainability**: No need to manually update recurring dates
3. **File Size**: JSON file remains manageable
4. **Flexibility**: Easy to extend date range without editing JSON
5. **Cultural Authenticity**: Calculations follow traditional Balinese calendar rules

### Static Data Benefits:
1. **Cultural Context**: Detailed descriptions and significance
2. **Consistency**: Same information across all instances
3. **Editability**: Easy to update descriptions without code changes
4. **Localization**: Can add translations in future

## Usage in App

```dart
// Load static holy days from JSON
final holyDayService = HolyDayService();
await holyDayService.loadHolyDays();

// Get all holy days for a date (includes both static and calculated)
final holyDays = holyDayService.getHolyDaysForDate(DateTime(2025, 3, 29));

// Static holy days come from JSON
// Purnama, Tilem, Kajeng Kliwon are calculated on-the-fly
```

## Future Enhancements

Potential additions to the JSON file:
- Local village temple ceremonies (odalan)
- Regional variations of holy days
- Multi-language descriptions
- Additional cultural context and rituals
- Historical significance
