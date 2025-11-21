import 'package:flutter_test/flutter_test.dart';
import 'package:bali_calendar/domain/services/lunar_phase_service.dart';

void main() {
  group('Lunar Phase Service - Babadbali Algorithm', () {
    test('Verifikasi contoh dari Babadbali.com', () {
      // Example 1: 4 September 2005 (should be Tilem)
      final date1 = DateTime(2005, 9, 4);
      final phase1 = LunarPhaseService.calculateLunarPhase(date1);
      
      expect(phase1, equals(0), reason: '4 September 2005 should be phase 0 (Tilem)');
      expect(LunarPhaseService.isTilem(date1), isTrue);
      expect(LunarPhaseService.isPurnama(date1), isFalse);
      
      // Example 2: 29 February 2008 (should be Bulan Paruh Terakhir, phase 22)
      final date2 = DateTime(2008, 2, 29);
      final phase2 = LunarPhaseService.calculateLunarPhase(date2);
      
      expect(phase2, equals(22), reason: '29 February 2008 should be phase 22');
      expect(LunarPhaseService.isTilem(date2), isFalse);
      expect(LunarPhaseService.isPurnama(date2), isFalse);
    });
    
    test('Verifikasi Desember 2025', () {
      // 4 December 2025 should be Purnama
      final purnama = DateTime(2025, 12, 4);
      final phaseP = LunarPhaseService.calculateLunarPhase(purnama);
      
      print('4 December 2025: phase $phaseP');
      expect(LunarPhaseService.isPurnama(purnama), isTrue, 
        reason: '4 December 2025 should be Purnama');
      expect(LunarPhaseService.isTilem(purnama), isFalse);
      
      // 19 December 2025 should be Tilem
      final tilem = DateTime(2025, 12, 19);
      final phaseT = LunarPhaseService.calculateLunarPhase(tilem);
      
      print('19 December 2025: phase $phaseT');
      expect(LunarPhaseService.isTilem(tilem), isTrue,
        reason: '19 December 2025 should be Tilem');
      expect(LunarPhaseService.isPurnama(tilem), isFalse);
    });
    
    test('Verifikasi 2024 - Purnama', () {
      final expectedPurnama = [
        DateTime(2024, 1, 25),
        DateTime(2024, 2, 24),
        DateTime(2024, 3, 25),
        DateTime(2024, 4, 24),
        DateTime(2024, 5, 23),
        DateTime(2024, 6, 22),
        DateTime(2024, 7, 21),
        DateTime(2024, 8, 19),
        DateTime(2024, 9, 18),
        DateTime(2024, 10, 17),
        DateTime(2024, 11, 15),
        DateTime(2024, 12, 15),
      ];
      
      int correct = 0;
      for (var date in expectedPurnama) {
        if (LunarPhaseService.isPurnama(date)) {
          correct++;
        } else {
          print('MISS: ${date.day}/${date.month}/2024 not detected as Purnama');
        }
      }
      
      print('Purnama 2024: $correct/${expectedPurnama.length} correct');
      expect(correct, equals(expectedPurnama.length), 
        reason: 'All 2024 Purnama dates should be detected');
    });
    
    test('Verifikasi 2024 - Tilem', () {
      final expectedTilem = [
        DateTime(2024, 1, 11),
        DateTime(2024, 2, 9),
        DateTime(2024, 3, 10),
        DateTime(2024, 4, 8),
        DateTime(2024, 5, 8),
        DateTime(2024, 6, 6),
        DateTime(2024, 7, 6),
        DateTime(2024, 8, 4),
        DateTime(2024, 9, 3),
        DateTime(2024, 10, 2),
        DateTime(2024, 11, 1),
        DateTime(2024, 12, 1),
        DateTime(2024, 12, 30),
      ];
      
      int correct = 0;
      for (var date in expectedTilem) {
        if (LunarPhaseService.isTilem(date)) {
          correct++;
        } else {
          print('MISS: ${date.day}/${date.month}/2024 not detected as Tilem');
        }
      }
      
      print('Tilem 2024: $correct/${expectedTilem.length} correct');
      expect(correct, equals(expectedTilem.length),
        reason: 'All 2024 Tilem dates should be detected');
    });
  });
}
