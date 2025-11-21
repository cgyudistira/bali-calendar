import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import '../lib/domain/services/bali_calendar_service.dart';
import '../lib/domain/services/holy_day_service.dart';
import '../lib/domain/services/saka_service.dart';
import '../lib/domain/services/pawukon_service.dart';
import '../lib/data/models/holy_day.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  late BaliCalendarService calendarService;
  late HolyDayService holyDayService;
  
  setUp(() async {
    // Initialize services
    final sakaService = SakaService();
    final pawukonService = PawukonService();
    calendarService = BaliCalendarService(sakaService, pawukonService);
    holyDayService = HolyDayService();
    
    // Set up integration
    calendarService.setHolyDayService(holyDayService);
    
    // Load holy days
    await holyDayService.loadHolyDays();
  });
  
  group('Calendar and Holy Day Integration', () {
    test('should include holy days in calendar date', () {
      // Nyepi 2025
      final nyepiDate = DateTime(2025, 3, 29);
      final calendar = calendarService.getCalendarForDate(nyepiDate);
      
      expect(calendar.holyDays.isNotEmpty, true);
      expect(calendar.hasHolyDays, true);
      expect(calendar.hasMajorHoliday, true);
      
      final holyDayNames = calendar.holyDayNames;
      expect(holyDayNames.any((name) => name.contains('Nyepi')), true);
      
      print('Nyepi 2025 calendar:');
      print(calendar.toString());
    });
    
    test('should include calculated holy days (Purnama)', () {
      // Find a Purnama date
      final dates = calendarService.getPurnamaDates(
        DateTime(2025, 1, 1),
        DateTime(2025, 1, 31),
      );
      
      if (dates.isNotEmpty) {
        final purnama = calendarService.getCalendarForDate(dates.first);
        expect(purnama.isPurnama, true);
        expect(purnama.hasHolyDays, true);
        
        final purnamaHolyDays = purnama.getHolyDaysByCategory(HolyDayCategory.purnama);
        expect(purnamaHolyDays.isNotEmpty, true);
        
        print('Purnama date: ${dates.first}');
        print('Holy days: ${purnama.holyDayNames}');
      }
    });
    
    test('should include calculated holy days (Kajeng Kliwon)', () {
      // Find a Kajeng Kliwon date
      final dates = calendarService.getKajengKliwonDates(
        DateTime(2025, 1, 1),
        DateTime(2025, 1, 31),
      );
      
      if (dates.isNotEmpty) {
        final kajengKliwon = calendarService.getCalendarForDate(dates.first);
        expect(kajengKliwon.isKajengKliwon, true);
        expect(kajengKliwon.hasHolyDays, true);
        
        final kajengKliwonHolyDays = kajengKliwon.getHolyDaysByCategory(
          HolyDayCategory.kajengKliwon,
        );
        expect(kajengKliwonHolyDays.isNotEmpty, true);
        
        print('Kajeng Kliwon date: ${dates.first}');
        print('Holy days: ${kajengKliwon.holyDayNames}');
      }
    });
    
    test('should get all holy days for a month', () {
      final holyDays = calendarService.getHolyDaysForMonth(2025, 3);
      expect(holyDays.isNotEmpty, true);
      
      print('Holy days in March 2025: ${holyDays.length}');
      for (final hd in holyDays.take(5)) {
        print('  - ${hd.name}');
      }
    });
    
    test('should cache calendar dates', () {
      final date = DateTime(2025, 3, 29);
      
      // First call
      final calendar1 = calendarService.getCalendarForDate(date);
      
      // Second call (should use cache)
      final calendar2 = calendarService.getCalendarForDate(date);
      
      // Should be the same instance from cache
      expect(identical(calendar1, calendar2), true);
      
      print('Cache working: ${identical(calendar1, calendar2)}');
    });
    
    test('should clear cache', () {
      final date = DateTime(2025, 3, 29);
      
      // First call
      final calendar1 = calendarService.getCalendarForDate(date);
      
      // Clear cache
      calendarService.clearCache();
      
      // Second call (should create new instance)
      final calendar2 = calendarService.getCalendarForDate(date);
      
      // Should be different instances
      expect(identical(calendar1, calendar2), false);
      
      print('Cache cleared: ${!identical(calendar1, calendar2)}');
    });
    
    test('should get calendar for month with holy days', () {
      final monthCalendar = calendarService.getCalendarForMonth(2025, 3);
      
      expect(monthCalendar.length, greaterThan(0));
      
      // Check if Nyepi is included
      final nyepiDay = monthCalendar.firstWhere(
        (cal) => cal.gregorianDate.day == 29,
      );
      
      expect(nyepiDay.hasHolyDays, true);
      expect(nyepiDay.hasMajorHoliday, true);
      
      print('March 2025 has ${monthCalendar.length} days');
      print('Nyepi (29th) has ${nyepiDay.holyDays.length} holy days');
    });
    
    test('should work without holy day service', () {
      // Create new service without holy day integration
      final sakaService = SakaService();
      final pawukonService = PawukonService();
      final standaloneService = BaliCalendarService(sakaService, pawukonService);
      
      final calendar = standaloneService.getCalendarForDate(DateTime(2025, 3, 29));
      
      // Should work but have no holy days
      expect(calendar.holyDays.isEmpty, true);
      expect(calendar.hasHolyDays, false);
      
      print('Standalone service works without holy days');
    });
  });
  
  group('Performance Tests', () {
    test('should handle large date ranges efficiently', () {
      final start = DateTime(2025, 1, 1);
      final end = DateTime(2025, 12, 31);
      
      final stopwatch = Stopwatch()..start();
      
      final monthCalendars = <int, List<dynamic>>{};
      for (int month = 1; month <= 12; month++) {
        monthCalendars[month] = calendarService.getCalendarForMonth(2025, month);
      }
      
      stopwatch.stop();
      
      print('Generated 12 months of calendar data in ${stopwatch.elapsedMilliseconds}ms');
      expect(stopwatch.elapsedMilliseconds, lessThan(10000)); // Should be under 10 seconds
    });
  });
}
