import 'dart:convert';
import 'package:flutter/services.dart';
import '../../data/models/holy_day.dart';
import '../../data/models/bali_calendar_date.dart';

/// Service for managing Balinese Hindu holy days
class HolyDayService {
  // Function to get calendar date (injected to avoid circular dependency)
  BaliCalendarDate Function(DateTime)? _getCalendarForDate;
  List<HolyDay> _holyDays = [];
  bool _isLoaded = false;
  
  HolyDayService();
  
  /// Set the calendar date getter function
  void setCalendarDateGetter(BaliCalendarDate Function(DateTime) getter) {
    _getCalendarForDate = getter;
  }
  
  /// Load holy days from JSON file
  Future<void> loadHolyDays() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/holy_days.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      final List<dynamic> holyDaysList = jsonData['holyDays'] as List<dynamic>;
      _holyDays = holyDaysList
          .map((json) => HolyDay.fromJson(json as Map<String, dynamic>))
          .toList();
      
      _isLoaded = true;
    } catch (e) {
      throw Exception('Failed to load holy days: $e');
    }
  }
  
  /// Ensure holy days are loaded
  void _ensureLoaded() {
    if (!_isLoaded) {
      throw StateError('Holy days not loaded. Call loadHolyDays() first.');
    }
  }
  
  /// Get all holy days for a specific date (includes static and calculated)
  List<HolyDay> getHolyDaysForDate(DateTime date) {
    _ensureLoaded();
    
    final List<HolyDay> result = [];
    
    // Add static holy days from JSON
    for (final holyDay in _holyDays) {
      if (holyDay.occursOn(date)) {
        result.add(holyDay);
      }
    }
    
    // Add dynamically calculated holy days
    result.addAll(_getCalculatedHolyDays(date));
    
    return result;
  }
  
  /// Get calculated holy days (Purnama, Tilem, Kajeng Kliwon, etc.)
  List<HolyDay> _getCalculatedHolyDays(DateTime date) {
    final List<HolyDay> calculated = [];
    
    // If no calendar getter is set, return empty list
    if (_getCalendarForDate == null) {
      return calculated;
    }
    
    final BaliCalendarDate calendarDate = _getCalendarForDate!(date);
    
    // Check for Purnama
    if (calendarDate.isPurnama) {
      calculated.add(HolyDay(
        id: 'purnama_${date.toIso8601String().split('T')[0]}',
        name: 'Purnama',
        description: 'Full moon day - an auspicious day for prayers and offerings.',
        category: HolyDayCategory.purnama,
        dates: [date.toIso8601String().split('T')[0]],
        culturalSignificance: 'Purnama (full moon) is considered a highly auspicious day in Balinese Hinduism. It is a time for special prayers, temple visits, and offerings. The full moon represents spiritual illumination and divine blessings.',
      ));
    }
    
    // Check for Tilem
    if (calendarDate.isTilem) {
      calculated.add(HolyDay(
        id: 'tilem_${date.toIso8601String().split('T')[0]}',
        name: 'Tilem',
        description: 'New moon day - a day for meditation and spiritual cleansing.',
        category: HolyDayCategory.tilem,
        dates: [date.toIso8601String().split('T')[0]],
        culturalSignificance: 'Tilem (new moon) is a sacred day for meditation, fasting, and spiritual purification. It represents the dark phase before renewal and is a time for introspection and releasing negative energies.',
      ));
    }
    
    // Check for Kajeng Kliwon
    if (calendarDate.isKajengKliwon) {
      calculated.add(HolyDay(
        id: 'kajeng_kliwon_${date.toIso8601String().split('T')[0]}',
        name: 'Kajeng Kliwon',
        description: 'Sacred day occurring every 15 days when Kajeng and Kliwon coincide.',
        category: HolyDayCategory.kajengKliwon,
        dates: [date.toIso8601String().split('T')[0]],
        culturalSignificance: 'Kajeng Kliwon is a powerful day that occurs every 15 days when the Triwara day Kajeng coincides with the Pancawara day Kliwon. It is believed to be a day when negative forces are strong, so special offerings and prayers are made for protection.',
      ));
    }
    
    // Check for Anggara Kasih (Tuesday + specific Pancawara)
    if (calendarDate.isAnggaraKasih) {
      calculated.add(HolyDay(
        id: 'anggara_kasih_${date.toIso8601String().split('T')[0]}',
        name: 'Anggara Kasih',
        description: 'Tuesday combined with specific Pancawara days - a day requiring special attention.',
        category: HolyDayCategory.other,
        dates: [date.toIso8601String().split('T')[0]],
        culturalSignificance: 'Anggara Kasih occurs when Tuesday (Anggara) coincides with certain Pancawara days. It is considered a day that requires extra caution and spiritual protection through prayers and offerings.',
      ));
    }
    
    // Check for Buda Cemeng (Wednesday + specific Pancawara)
    if (calendarDate.isBudaCemeng) {
      calculated.add(HolyDay(
        id: 'buda_cemeng_${date.toIso8601String().split('T')[0]}',
        name: 'Buda Cemeng',
        description: 'Wednesday combined with specific Pancawara days - a spiritually significant day.',
        category: HolyDayCategory.other,
        dates: [date.toIso8601String().split('T')[0]],
        culturalSignificance: 'Buda Cemeng occurs when Wednesday (Buda) coincides with certain Pancawara days. It is a day of spiritual significance requiring special observances and offerings for balance and harmony.',
      ));
    }
    
    return calculated;
  }
  
  /// Get holy days within a date range
  List<HolyDay> getHolyDaysInRange(DateTime startDate, DateTime endDate) {
    _ensureLoaded();
    
    final Set<HolyDay> result = {};
    
    // Add static holy days that fall within range
    for (final holyDay in _holyDays) {
      for (final dateTime in holyDay.dateTimeList) {
        if ((dateTime.isAfter(startDate) || dateTime.isAtSameMomentAs(startDate)) &&
            (dateTime.isBefore(endDate) || dateTime.isAtSameMomentAs(endDate))) {
          result.add(holyDay);
          break;
        }
      }
    }
    
    // Add calculated holy days for each day in range
    DateTime currentDate = DateTime(startDate.year, startDate.month, startDate.day);
    final DateTime end = DateTime(endDate.year, endDate.month, endDate.day);
    
    while (currentDate.isBefore(end) || currentDate.isAtSameMomentAs(end)) {
      result.addAll(_getCalculatedHolyDays(currentDate));
      currentDate = currentDate.add(const Duration(days: 1));
    }
    
    return result.toList()..sort((a, b) {
      final aDate = a.dateTimeList.first;
      final bDate = b.dateTimeList.first;
      return aDate.compareTo(bDate);
    });
  }
  
  /// Get upcoming holy days for the next N days
  List<HolyDay> getUpcomingHolyDays(int days, {DateTime? fromDate}) {
    _ensureLoaded();
    
    final DateTime start = fromDate ?? DateTime.now();
    final DateTime end = start.add(Duration(days: days));
    
    return getHolyDaysInRange(start, end);
  }
  
  /// Check if a specific date is a holy day
  bool isHolyDay(DateTime date) {
    _ensureLoaded();
    return getHolyDaysForDate(date).isNotEmpty;
  }
  
  /// Get holy days filtered by category
  List<HolyDay> getHolyDaysByCategory(HolyDayCategory category, {DateTime? startDate, DateTime? endDate}) {
    _ensureLoaded();
    
    if (startDate != null && endDate != null) {
      return getHolyDaysInRange(startDate, endDate)
          .where((holyDay) => holyDay.category == category)
          .toList();
    }
    
    // Return all static holy days of this category
    return _holyDays.where((holyDay) => holyDay.category == category).toList();
  }
  
  /// Get all loaded static holy days
  List<HolyDay> getAllStaticHolyDays() {
    _ensureLoaded();
    return List.unmodifiable(_holyDays);
  }
  
  /// Search holy days by name
  List<HolyDay> searchHolyDays(String query) {
    _ensureLoaded();
    
    if (query.isEmpty) {
      return getAllStaticHolyDays();
    }
    
    final lowerQuery = query.toLowerCase();
    return _holyDays.where((holyDay) {
      return holyDay.name.toLowerCase().contains(lowerQuery) ||
             holyDay.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }
  
  /// Get the next occurrence of a specific holy day
  DateTime? getNextOccurrence(String holyDayId, {DateTime? afterDate}) {
    _ensureLoaded();
    
    final holyDay = _holyDays.firstWhere(
      (hd) => hd.id == holyDayId,
      orElse: () => throw ArgumentError('Holy day with id "$holyDayId" not found'),
    );
    
    return holyDay.getNextOccurrence(afterDate ?? DateTime.now());
  }
  
  /// Get count of holy days in a month
  int getHolyDayCountForMonth(int year, int month) {
    _ensureLoaded();
    
    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);
    
    return getHolyDaysInRange(firstDay, lastDay).length;
  }
}
