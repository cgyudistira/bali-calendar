import 'package:flutter_test/flutter_test.dart';
import 'package:bali_calendar/domain/services/saka_service.dart';
import 'package:bali_calendar/domain/services/pawukon_service.dart';
import 'package:bali_calendar/domain/services/bali_calendar_service.dart';

void main() {
  test('Cek Purnama dan Tilem di Desember 2025', () {
    final sakaService = SakaService();
    final pawukonService = PawukonService();
    final baliService = BaliCalendarService(sakaService, pawukonService);
    
    print('\n=== PURNAMA DAN TILEM DESEMBER 2025 ===\n');
    
    final purnamaList = <DateTime>[];
    final tilemList = <DateTime>[];
    
    // Scan semua tanggal di Desember 2025
    for (int day = 1; day <= 31; day++) {
      final date = DateTime(2025, 12, day);
      final calDate = baliService.getCalendarForDate(date);
      
      if (calDate != null) {
        if (calDate.isPurnama) {
          purnamaList.add(date);
        }
        if (calDate.isTilem) {
          tilemList.add(date);
        }
      }
    }
    
    // Display results
    print('🌕 PURNAMA (Full Moon):');
    if (purnamaList.isEmpty) {
      print('   Tidak ada Purnama di Desember 2025');
    } else {
      for (var date in purnamaList) {
        final calDate = baliService.getCalendarForDate(date);
        print('   ${date.day} Desember 2025');
        print('   Saka: ${calDate!.sakaDate}');
      }
    }
    
    print('');
    
    print('🌑 TILEM (New Moon):');
    if (tilemList.isEmpty) {
      print('   Tidak ada Tilem di Desember 2025');
    } else {
      for (var date in tilemList) {
        final calDate = baliService.getCalendarForDate(date);
        print('   ${date.day} Desember 2025');
        print('   Saka: ${calDate!.sakaDate}');
      }
    }
    
    print('');
    print('Total: ${purnamaList.length} Purnama, ${tilemList.length} Tilem');
    
    // Assertions
    expect(purnamaList.length, greaterThan(0), reason: 'Should have at least 1 Purnama');
    expect(tilemList.length, greaterThan(0), reason: 'Should have at least 1 Tilem');
  });
}
