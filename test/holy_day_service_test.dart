import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import '../lib/domain/services/holy_day_service.dart';
import '../lib/domain/services/bali_calendar_service.dart';
import '../lib/domain/services/saka_service.dart';
import '../lib/domain/services/pawukon_service.dart';
import '../lib/data/models/holy_day.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  late HolyDayService holyDayService;
  late BaliCalendarService calendarService;
  
  setUp(() async {
    // Initialize services
    final sakaService = SakaService();
    final pawukonService = PawukonService();
    calendarService = BaliCalendarService(sakaService, pawukonService);
    holyDayService = HolyDayService();
    
    // Set up the integration
    calendarService.setHolyDayService(holyDayService);
    
    // Load holy days
    await holyDayService.loadHolyDays();
  });
  
  group('HolyDayService - Loading', () {
    test('should load holy days from JSON', () {
      final staticHolyDays = holyDayService.getAllStaticHolyDays();
      expect(staticHolyDays.isNotEmpty, true);
      print('Loaded ${staticHolyDays.length} static holy days');
    });
    
    test('should have major holidays', () {
      final majorHolyDays = holyDayService.getHolyDaysByCategory(HolyDayCategory.major);
      expect(majorHolyDays.isNotEmpty, true);
      
      // Check for specific major holidays
      final names = majorHolyDays.map((hd) => hd.name).toList();
      expect(names.any((name) => name.contains('Nyepi')), true);
      expect(names.any((name) => name.contains('Galungan')), true);
      expect(names.any((name) => name.contains('Kuningan')), true);
      
      print('Major holidays: $names');
    });
    
    test('should have Tumpek celebrations', () {
      final tumpeks = holyDayService.getHolyDaysByCategory(HolyDayCategory.tumpek);
      expect(tumpeks.length, greaterThanOrEqualTo(6));
      
      final names = tumpeks.map((hd) => hd.name).toList();
      print('Tumpek celebrations: $names');
    });
  });
  
  group('HolyDayService - Querying', () {
    test('should get holy days for Nyepi 2025', () {
      final nyepiDate = DateTime(2025, 3, 29);
      final holyDays = holyDayService.getHolyDaysForDate(nyepiDate);
      
      expect(holyDays.isNotEmpty, true);
      expect(holyDays.any((hd) => hd.name.contains('Nyepi')), true);
      
      print('Holy days on Nyepi 2025:');
      for (final hd in holyDays) {
        print('  - ${hd.name} (${hd.category.displayName})');
      }
    });
    
    test('should detect Purnama dynamically', () {
      // Find a Purnama date
      final testDate = DateTime(2025, 1, 13); // Should be around Purnama
      final holyDays = holyDayService.getHolyDaysForDate(testDate);
      
      print('Holy days on ${testDate.toIso8601String().split('T')[0]}:');
      for (final hd in holyDays) {
        print('  - ${hd.name} (${hd.category.displayName})');
      }
    });
    
    test('should get upcoming holy days', () {
      final upcoming = holyDayService.getUpcomingHolyDays(30);
      expect(upcoming.isNotEmpty, true);
      
      print('Upcoming holy days (next 30 days): ${upcoming.length}');
      for (final hd in upcoming.take(5)) {
        final nextDate = hd.dateTimeList.first;
        print('  - ${hd.name} on ${nextDate.toIso8601String().split('T')[0]}');
      }
    });
    
    test('should search holy days by name', () {
      final results = holyDayService.searchHolyDays('Galungan');
      expect(results.isNotEmpty, true);
      expect(results.first.name.contains('Galungan'), true);
      
      print('Search results for "Galungan": ${results.length}');
    });
    
    test('should check if date is holy day', () {
      final nyepiDate = DateTime(2025, 3, 29);
      final isHoly = holyDayService.isHolyDay(nyepiDate);
      expect(isHoly, true);
      
      print('Is Nyepi 2025 a holy day? $isHoly');
    });
  });
  
  group('HolyDayService - Date Ranges', () {
    test('should get holy days in range', () {
      final start = DateTime(2025, 1, 1);
      final end = DateTime(2025, 12, 31);
      final holyDays = holyDayService.getHolyDaysInRange(start, end);
      
      expect(holyDays.isNotEmpty, true);
      print('Holy days in 2025: ${holyDays.length}');
    });
    
    test('should count holy days in month', () {
      final count = holyDayService.getHolyDayCountForMonth(2025, 3);
      expect(count, greaterThan(0));
      
      print('Holy days in March 2025: $count');
    });
  });
  
  group('HolyDayService - Categories', () {
    test('should filter by category', () {
      final start = DateTime(2025, 1, 1);
      final end = DateTime(2025, 12, 31);
      
      final tumpeks = holyDayService.getHolyDaysByCategory(
        HolyDayCategory.tumpek,
        startDate: start,
        endDate: end,
      );
      
      expect(tumpeks.isNotEmpty, true);
      print('Tumpek celebrations in 2025: ${tumpeks.length}');
    });
  });
}
