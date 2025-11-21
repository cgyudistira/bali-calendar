import '../../data/models/bali_calendar_date.dart';
import '../../data/models/holy_day.dart';
import 'saka_service.dart';
import 'pawukon_service.dart';
import 'holy_day_service.dart';

/// Main service for Balinese calendar calculations
/// Combines Saka (lunar) and Pawukon (210-day cycle) calendars with holy days
class BaliCalendarService {
  final SakaService _sakaService;
  final PawukonService _pawukonService;
  HolyDayService? _holyDayService;
  
  // Cache for frequently accessed dates
  final Map<String, BaliCalendarDate> _cache = {};
  static const int _maxCacheSize = 100;

  BaliCalendarService(this._sakaService, this._pawukonService);
  
  /// Set the holy day service (optional, for integration with holy days)
  void setHolyDayService(HolyDayService holyDayService) {
    _holyDayService = holyDayService;
    // Set up the calendar date getter to avoid circular dependency
    _holyDayService!.setCalendarDateGetter(_getCalendarWithoutHolyDays);
    _cache.clear(); // Clear cache when holy day service changes
  }
  
  /// Get calendar date without holy days (used internally to avoid circular dependency)
  BaliCalendarDate _getCalendarWithoutHolyDays(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final sakaDate = _sakaService.gregorianToSaka(normalizedDate);
    final pawukonDate = _pawukonService.gregorianToPawukon(normalizedDate);
    
    // If calculations failed due to out-of-range date, throw error
    if (sakaDate == null || pawukonDate == null) {
      throw CalendarCalculationException(
        'Date out of supported range (1900-2100): ${normalizedDate.year}',
      );
    }
    
    return BaliCalendarDate(
      gregorianDate: normalizedDate,
      sakaDate: sakaDate,
      pawukonDate: pawukonDate,
      holyDays: const [], // No holy days in this internal method
    );
  }

  /// Get complete Balinese calendar information for a specific date
  /// Returns null if date is out of supported range (1900-2100)
  BaliCalendarDate? getCalendarForDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    
    // Validate date range
    if (!_sakaService.isDateInRange(normalizedDate)) {
      return null;
    }
    
    final cacheKey = _getCacheKey(normalizedDate);
    
    // Check cache first
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }
    
    final sakaDate = _sakaService.gregorianToSaka(normalizedDate);
    final pawukonDate = _pawukonService.gregorianToPawukon(normalizedDate);
    
    // Double-check calculations succeeded
    if (sakaDate == null || pawukonDate == null) {
      return null;
    }
    
    // Get holy days if service is available
    List<HolyDay> holyDays = [];
    try {
      holyDays = _holyDayService?.getHolyDaysForDate(normalizedDate) ?? [];
    } catch (e) {
      // Log error but continue without holy days
      print('Warning: Failed to load holy days for $normalizedDate: $e');
    }

    final calendarDate = BaliCalendarDate(
      gregorianDate: normalizedDate,
      sakaDate: sakaDate,
      pawukonDate: pawukonDate,
      holyDays: holyDays,
    );
    
    // Add to cache
    _addToCache(cacheKey, calendarDate);
    
    return calendarDate;
  }
  
  /// Generate cache key for a date
  String _getCacheKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
  
  /// Add calendar date to cache with size limit
  void _addToCache(String key, BaliCalendarDate calendarDate) {
    if (_cache.length >= _maxCacheSize) {
      // Remove oldest entry (first key)
      final firstKey = _cache.keys.first;
      _cache.remove(firstKey);
    }
    _cache[key] = calendarDate;
  }
  
  /// Clear the cache
  void clearCache() {
    _cache.clear();
  }

  /// Get calendar information for current date
  /// Returns null if current date is out of supported range
  BaliCalendarDate? getCurrentCalendar() {
    return getCalendarForDate(DateTime.now());
  }
  
  /// Validate if a date is within supported range
  bool isDateInRange(DateTime date) {
    return _sakaService.isDateInRange(date);
  }

  /// Get calendar information for a month (with holy days if service is available)
  /// Skips dates that are out of supported range
  List<BaliCalendarDate> getCalendarForMonth(int year, int month) {
    final dates = <BaliCalendarDate>[];
    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);

    for (int day = 1; day <= lastDay.day; day++) {
      final date = DateTime(year, month, day);
      final calendarDate = getCalendarForDate(date);
      if (calendarDate != null) {
        dates.add(calendarDate);
      }
    }

    return dates;
  }
  
  /// Get all holy days for a month
  List<HolyDay> getHolyDaysForMonth(int year, int month) {
    if (_holyDayService == null) return [];
    
    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);
    
    return _holyDayService!.getHolyDaysInRange(firstDay, lastDay);
  }

  /// Get all Purnama (full moon) dates in a date range
  List<DateTime> getPurnamaDates(DateTime start, DateTime end) {
    final dates = <DateTime>[];
    DateTime current = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);

    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      final calendar = getCalendarForDate(current);
      if (calendar.isPurnama) {
        dates.add(current);
      }
      current = current.add(const Duration(days: 1));
    }

    return dates;
  }

  /// Get all Tilem (new moon) dates in a date range
  List<DateTime> getTilemDates(DateTime start, DateTime end) {
    final dates = <DateTime>[];
    DateTime current = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);

    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      final calendar = getCalendarForDate(current);
      if (calendar.isTilem) {
        dates.add(current);
      }
      current = current.add(const Duration(days: 1));
    }

    return dates;
  }

  /// Get all Kajeng Kliwon dates in a date range
  List<DateTime> getKajengKliwonDates(DateTime start, DateTime end) {
    return _pawukonService.getKajengKliwonDates(start, end);
  }

  /// Get all Anggara Kasih (Tuesday Kliwon) dates in a date range
  List<DateTime> getAnggaraKasihDates(DateTime start, DateTime end) {
    final dates = <DateTime>[];
    DateTime current = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);

    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      final calendar = getCalendarForDate(current);
      if (calendar.isAnggaraKasih) {
        dates.add(current);
      }
      current = current.add(const Duration(days: 1));
    }

    return dates;
  }

  /// Get all Buda Cemeng (Wednesday Kliwon) dates in a date range
  List<DateTime> getBudaCemengDates(DateTime start, DateTime end) {
    final dates = <DateTime>[];
    DateTime current = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);

    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      final calendar = getCalendarForDate(current);
      if (calendar.isBudaCemeng) {
        dates.add(current);
      }
      current = current.add(const Duration(days: 1));
    }

    return dates;
  }

  /// Check if a date has any special significance
  Map<String, bool> getSpecialDayFlags(DateTime date) {
    final calendar = getCalendarForDate(date);

    return {
      'isPurnama': calendar.isPurnama,
      'isTilem': calendar.isTilem,
      'isKajengKliwon': calendar.isKajengKliwon,
      'isAnggaraKasih': calendar.isAnggaraKasih,
      'isBudaCemeng': calendar.isBudaCemeng,
    };
  }
}

/// Exception thrown when calendar calculations fail
class CalendarCalculationException implements Exception {
  final String message;
  
  CalendarCalculationException(this.message);
  
  @override
  String toString() => 'CalendarCalculationException: $message';
}
