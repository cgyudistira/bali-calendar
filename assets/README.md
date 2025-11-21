# Assets Directory

This directory contains static assets for the Bali Calendar application.

## Structure

- **images/**: Image assets including Balinese patterns and icons
- **data/**: JSON data files for holy days and calendar information

## Data Files (to be added)

The following JSON files will be stored in the `data/` directory:

- `holy_days.json`: Database of Hindu Balinese holy days (2025-2035)
  - Purnama (full moon) dates
  - Tilem (new moon) dates
  - Kajeng Kliwon dates
  - Major holidays (Galungan, Kuningan, Nyepi, etc.)
  - Tumpek celebrations
  - Anggara Kasih and Buda Cemeng dates

## Usage

Assets are configured in `pubspec.yaml` and can be loaded using:

```dart
// For images
Image.asset('assets/images/pattern.png')

// For JSON data
rootBundle.loadString('assets/data/holy_days.json')
```
