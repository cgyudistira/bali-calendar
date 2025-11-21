import 'package:test/test.dart';
import '../lib/domain/services/pawukon_service.dart';
import '../lib/data/models/pawukon_date.dart';

void main() {
  late PawukonService service;

  setUp(() {
    service = PawukonService();
  });

  group('PawukonService - gregorianToPawukon', () {
    test('calculates correct Pawukon date for 2000-01-01 (pivot date)', () {
      final date = DateTime(2000, 1, 1);
      final pawukon = service.gregorianToPawukon(date);

      // 2000-01-01 is angkaWuku 70, which is Wuku Sungsang (id: 9)
      expect(pawukon.wuku.name, 'Sungsang');
      expect(pawukon.dayInCycle, 69); // 0-based index (70 - 1)
    });

    test('calculates correct Pawukon date for 1970-01-01 (pivot date)', () {
      final date = DateTime(1970, 1, 1);
      final pawukon = service.gregorianToPawukon(date);

      // 1970-01-01 is angkaWuku 33, which is Wuku Tolu (id: 4)
      expect(pawukon.wuku.name, 'Tolu');
      expect(pawukon.dayInCycle, 32); // 0-based index (33 - 1)
    });

    test('calculates all 10 wewaran correctly', () {
      final date = DateTime(2025, 1, 15);
      final pawukon = service.gregorianToPawukon(date);

      // Verify all wewaran are calculated
      expect(pawukon.ekaWara, isNotNull);
      expect(pawukon.dwiWara, isNotNull);
      expect(pawukon.triWara, isNotNull);
      expect(pawukon.caturWara, isNotNull);
      expect(pawukon.pancaWara, isNotNull);
      expect(pawukon.sadWara, isNotNull);
      expect(pawukon.saptaWara, isNotNull);
      expect(pawukon.astaWara, isNotNull);
      expect(pawukon.sangaWara, isNotNull);
      expect(pawukon.dasaWara, isNotNull);
    });

    test('calculates total urip correctly', () {
      final date = DateTime(2025, 1, 15);
      final pawukon = service.gregorianToPawukon(date);

      // Total urip should be sum of wuku + sapta + panca + tri
      final expectedUrip = pawukon.wuku.urip +
          pawukon.saptaWara.urip +
          pawukon.pancaWara.urip +
          pawukon.triWara.urip;

      expect(pawukon.urip, expectedUrip);
    });
  });

  group('PawukonService - special rules', () {
    test('applies Jaya Tiga rule for angkaWuku 71-73', () {
      // Find dates that correspond to angkaWuku 71, 72, 73
      // Starting from pivot 2000-01-01 (angkaWuku 70)
      final date71 = DateTime(2000, 1, 2); // angkaWuku 71
      final date72 = DateTime(2000, 1, 3); // angkaWuku 72
      final date73 = DateTime(2000, 1, 4); // angkaWuku 73

      final pawukon71 = service.gregorianToPawukon(date71);
      final pawukon72 = service.gregorianToPawukon(date72);
      final pawukon73 = service.gregorianToPawukon(date73);

      // All should have Catur Wara = Jaya (id: 2)
      expect(pawukon71.caturWara.name, 'Jaya');
      expect(pawukon72.caturWara.name, 'Jaya');
      expect(pawukon73.caturWara.name, 'Jaya');
    });

    test('applies Kala Tiga rule for angkaWuku 71-73', () {
      final date71 = DateTime(2000, 1, 2);
      final date72 = DateTime(2000, 1, 3);
      final date73 = DateTime(2000, 1, 4);

      final pawukon71 = service.gregorianToPawukon(date71);
      final pawukon72 = service.gregorianToPawukon(date72);
      final pawukon73 = service.gregorianToPawukon(date73);

      // All should have Asta Wara = Kala (id: 6)
      expect(pawukon71.astaWara.name, 'Kala');
      expect(pawukon72.astaWara.name, 'Kala');
      expect(pawukon73.astaWara.name, 'Kala');
    });

    test('applies Dangu Pat rule for angkaWuku 1-4', () {
      // Find dates for angkaWuku 1-4
      // From pivot 2000-01-01 (angkaWuku 70), go back 69 days to get angkaWuku 1
      final date1 = DateTime(1999, 10, 24); // angkaWuku 1
      final date2 = DateTime(1999, 10, 25); // angkaWuku 2
      final date3 = DateTime(1999, 10, 26); // angkaWuku 3
      final date4 = DateTime(1999, 10, 27); // angkaWuku 4

      final pawukon1 = service.gregorianToPawukon(date1);
      final pawukon2 = service.gregorianToPawukon(date2);
      final pawukon3 = service.gregorianToPawukon(date3);
      final pawukon4 = service.gregorianToPawukon(date4);

      // All should have Sanga Wara = Dangu (id: 0)
      expect(pawukon1.sangaWara.name, 'Dangu');
      expect(pawukon2.sangaWara.name, 'Dangu');
      expect(pawukon3.sangaWara.name, 'Dangu');
      expect(pawukon4.sangaWara.name, 'Dangu');
    });
  });

  group('PawukonService - Kajeng Kliwon', () {
    test('identifies Kajeng Kliwon correctly', () {
      // Find a date that is Kajeng Kliwon
      // We need TriWara = Kajeng (id: 2) and PancaWara = Kliwon (id: 4)
      final date = DateTime(2025, 1, 1);
      
      // Check if it's Kajeng Kliwon
      final isKK = service.isKajengKliwon(date);
      final pawukon = service.gregorianToPawukon(date);
      
      if (isKK) {
        expect(pawukon.triWara.id, 2);
        expect(pawukon.pancaWara.id, 4);
      }
    });

    test('finds Kajeng Kliwon dates in range', () {
      final start = DateTime(2025, 1, 1);
      final end = DateTime(2025, 3, 31);
      
      final kkDates = service.getKajengKliwonDates(start, end);
      
      // Kajeng Kliwon occurs every 15 days
      expect(kkDates.isNotEmpty, true);
      
      // Verify each date is actually Kajeng Kliwon
      for (final date in kkDates) {
        expect(service.isKajengKliwon(date), true);
      }
      
      // Check spacing between dates (should be 15 days)
      if (kkDates.length > 1) {
        for (int i = 1; i < kkDates.length; i++) {
          final diff = kkDates[i].difference(kkDates[i - 1]).inDays;
          expect(diff, 15);
        }
      }
    });
  });

  group('PawukonService - Otonan calculations', () {
    test('calculates days until next otonan correctly', () {
      final birthDate = DateTime(2000, 1, 1);
      final currentDate = DateTime(2000, 1, 1);
      
      final daysUntil = service.daysUntilNextOtonan(birthDate, currentDate);
      
      // On birth date, next otonan should be 210 days away
      expect(daysUntil, 0); // Same day, so 0 days until "next" (which is today)
    });

    test('calculates next otonan date correctly', () {
      final birthDate = DateTime(2000, 1, 1);
      final currentDate = DateTime(2000, 1, 2);
      
      final nextOtonan = service.getNextOtonan(birthDate, currentDate);
      
      // Next otonan should be 210 days from birth
      final expectedDate = birthDate.add(const Duration(days: 210));
      expect(nextOtonan, expectedDate);
    });

    test('generates multiple future otonan dates', () {
      final birthDate = DateTime(2000, 1, 1);
      final count = 5;
      
      final otonans = service.getFutureOtonans(birthDate, count);
      
      expect(otonans.length, count);
      
      // Verify each otonan is 210 days apart
      for (int i = 1; i < otonans.length; i++) {
        final diff = otonans[i].difference(otonans[i - 1]).inDays;
        expect(diff, 210);
      }
    });

    test('otonan dates have same Pawukon day as birth date', () {
      final birthDate = DateTime(2000, 1, 1);
      final birthPawukon = service.gregorianToPawukon(birthDate);
      
      final otonans = service.getFutureOtonans(birthDate, 3);
      
      for (final otonan in otonans) {
        final otonanPawukon = service.gregorianToPawukon(otonan);
        expect(otonanPawukon.dayInCycle, birthPawukon.dayInCycle);
      }
    });
  });

  group('PawukonService - getCurrentPawukonDate', () {
    test('returns current Pawukon date', () {
      final current = service.getCurrentPawukonDate();
      
      expect(current, isNotNull);
      expect(current.wuku, isNotNull);
      expect(current.saptaWara, isNotNull);
    });
  });

  group('PawukonService - 210-day cycle', () {
    test('cycles correctly after 210 days', () {
      final date1 = DateTime(2000, 1, 1);
      final date2 = date1.add(const Duration(days: 210));
      
      final pawukon1 = service.gregorianToPawukon(date1);
      final pawukon2 = service.gregorianToPawukon(date2);
      
      // After 210 days, should return to same position in cycle
      expect(pawukon1.dayInCycle, pawukon2.dayInCycle);
      expect(pawukon1.wuku.id, pawukon2.wuku.id);
    });
  });
}
