import 'package:flutter_test/flutter_test.dart';
import 'package:bali_calendar/domain/services/saka_service.dart';
import 'package:bali_calendar/domain/services/pawukon_service.dart';
import 'package:bali_calendar/domain/services/bali_calendar_service.dart';

void main() {
  test('Cek tanggal 5 November 2025 adalah Purnama', () {
    final sakaService = SakaService();
    final pawukonService = PawukonService();
    final baliService = BaliCalendarService(sakaService, pawukonService);
    
    // Test tanggal 5 November 2025
    final testDate = DateTime(2025, 11, 5);
    
    print('\n=== CEK TANGGAL: 5 November 2025 ===');
    
    final calDate = baliService.getCalendarForDate(testDate);
    
    expect(calDate, isNotNull);
    
    print('Gregorian: ${calDate!.gregorianDate}');
    print('Saka: ${calDate.sakaDate}');
    print('');
    print('Is Purnama? ${calDate.isPurnama ? "✓ YA" : "✗ TIDAK"}');
    print('Is Tilem? ${calDate.isTilem ? "✓ YA" : "✗ TIDAK"}');
    print('');
    
    if (calDate.isPurnama) {
      print('🌕 KONFIRMASI: 5 November 2025 adalah PURNAMA (Full Moon)');
    } else if (calDate.isTilem) {
      print('🌑 5 November 2025 adalah TILEM (New Moon)');
    } else {
      print('📅 5 November 2025 adalah hari biasa');
      print('   Day Info: ${calDate.sakaDate.dayInfo}');
    }
    
    // Assert that it's Purnama
    expect(calDate.isPurnama, isTrue, 
      reason: '5 November 2025 should be Purnama according to lookup table');
  });
}
