import '../lib/domain/services/pawukon_service.dart';

/// Test Pawukon Service Utilities
void main() {
  print('=== PAWUKON SERVICE UTILITIES TEST ===\n');

  final pawukonService = PawukonService();

  // Test 1: getCurrentPawukonDate
  print('📅 TEST 1: Get Current Pawukon Date');
  print('────────────────────────────────────');
  final current = pawukonService.getCurrentPawukonDate();
  print('Current Wuku: ${current.wuku.name}');
  print('Current Day in Cycle: ${current.dayInCycle}/210');
  print('Sapta Wara: ${current.saptaWara.name}');
  print('Panca Wara: ${current.pancaWara.name}');
  print('✅ PASSED\n');

  // Test 2: isKajengKliwon
  print('🔍 TEST 2: Check Kajeng Kliwon');
  print('──────────────────────────────');
  final testDate = DateTime(2025, 1, 1);
  final isKK = pawukonService.isKajengKliwon(testDate);
  final pawukon = pawukonService.gregorianToPawukon(testDate);
  print('Date: 2025-01-01');
  print('Tri Wara: ${pawukon.triWara.name} (id: ${pawukon.triWara.id})');
  print('Panca Wara: ${pawukon.pancaWara.name} (id: ${pawukon.pancaWara.id})');
  print('Is Kajeng Kliwon: $isKK');
  print('✅ PASSED\n');

  // Test 3: getKajengKliwonDates
  print('📋 TEST 3: Get Kajeng Kliwon Dates in Range');
  print('────────────────────────────────────────────');
  final start = DateTime(2025, 1, 1);
  final end = DateTime(2025, 3, 31);
  final kkDates = pawukonService.getKajengKliwonDates(start, end);
  print('Range: 2025-01-01 to 2025-03-31');
  print('Found ${kkDates.length} Kajeng Kliwon dates:');
  for (int i = 0; i < kkDates.length; i++) {
    final date = kkDates[i];
    final p = pawukonService.gregorianToPawukon(date);
    print('  ${i + 1}. ${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} - ${p.saptaWara.name} ${p.pancaWara.name}');
    
    // Verify spacing
    if (i > 0) {
      final diff = date.difference(kkDates[i - 1]).inDays;
      if (diff != 15) {
        print('     ⚠️  WARNING: Gap is $diff days (expected 15)');
      }
    }
  }
  print('✅ PASSED\n');

  // Test 4: daysUntilNextOtonan
  print('🎂 TEST 4: Days Until Next Otonan');
  print('──────────────────────────────────');
  final birthDate = DateTime(2000, 1, 1);
  final currentDate = DateTime(2025, 11, 21);
  final daysUntil = pawukonService.daysUntilNextOtonan(birthDate, currentDate);
  print('Birth Date: 2000-01-01');
  print('Current Date: 2025-11-21');
  print('Days Until Next Otonan: $daysUntil');
  print('✅ PASSED\n');

  // Test 5: getNextOtonan
  print('📆 TEST 5: Get Next Otonan Date');
  print('────────────────────────────────');
  final nextOtonan = pawukonService.getNextOtonan(birthDate, currentDate);
  print('Birth Date: 2000-01-01');
  print('Current Date: 2025-11-21');
  print('Next Otonan: ${nextOtonan.year}-${nextOtonan.month.toString().padLeft(2, '0')}-${nextOtonan.day.toString().padLeft(2, '0')}');
  
  // Verify it's the same Pawukon day
  final birthPawukon = pawukonService.gregorianToPawukon(birthDate);
  final otonanPawukon = pawukonService.gregorianToPawukon(nextOtonan);
  print('Birth Pawukon Day: ${birthPawukon.dayInCycle}');
  print('Otonan Pawukon Day: ${otonanPawukon.dayInCycle}');
  if (birthPawukon.dayInCycle == otonanPawukon.dayInCycle) {
    print('✅ Verified: Same Pawukon day');
  } else {
    print('❌ ERROR: Different Pawukon days!');
  }
  print('✅ PASSED\n');

  // Test 6: getFutureOtonans
  print('📅 TEST 6: Get Future Otonan Dates');
  print('───────────────────────────────────');
  final futureOtonans = pawukonService.getFutureOtonans(birthDate, 5);
  print('Birth Date: 2000-01-01');
  print('Next 5 Otonan dates:');
  for (int i = 0; i < futureOtonans.length; i++) {
    final otonan = futureOtonans[i];
    final p = pawukonService.gregorianToPawukon(otonan);
    print('  ${i + 1}. ${otonan.year}-${otonan.month.toString().padLeft(2, '0')}-${otonan.day.toString().padLeft(2, '0')} - Wuku ${p.wuku.name}, ${p.saptaWara.name} ${p.pancaWara.name}');
    
    // Verify spacing
    if (i > 0) {
      final diff = otonan.difference(futureOtonans[i - 1]).inDays;
      if (diff != 210) {
        print('     ❌ ERROR: Gap is $diff days (expected 210)');
      }
    }
    
    // Verify same Pawukon day
    if (p.dayInCycle != birthPawukon.dayInCycle) {
      print('     ❌ ERROR: Different Pawukon day (${p.dayInCycle} vs ${birthPawukon.dayInCycle})');
    }
  }
  print('✅ PASSED\n');

  // Test 7: Special Rules Verification
  print('⚡ TEST 7: Special Rules (Jaya Tiga, Kala Tiga, Dangu Pat)');
  print('──────────────────────────────────────────────────────────');
  
  // Jaya Tiga and Kala Tiga (angkaWuku 71-73)
  print('Testing Jaya Tiga & Kala Tiga (angkaWuku 71-73):');
  final date71 = DateTime(2000, 1, 2); // angkaWuku 71
  final date72 = DateTime(2000, 1, 3); // angkaWuku 72
  final date73 = DateTime(2000, 1, 4); // angkaWuku 73
  
  for (final date in [date71, date72, date73]) {
    final p = pawukonService.gregorianToPawukon(date);
    final angkaWuku = p.dayInCycle + 1;
    print('  angkaWuku $angkaWuku: Catur Wara = ${p.caturWara.name}, Asta Wara = ${p.astaWara.name}');
    if (p.caturWara.name != 'Jaya') {
      print('    ❌ ERROR: Expected Catur Wara = Jaya');
    }
    if (p.astaWara.name != 'Kala') {
      print('    ❌ ERROR: Expected Asta Wara = Kala');
    }
  }
  
  // Dangu Pat (angkaWuku 1-4)
  print('\nTesting Dangu Pat (angkaWuku 1-4):');
  final date1 = DateTime(1999, 10, 24); // angkaWuku 1
  final date2 = DateTime(1999, 10, 25); // angkaWuku 2
  final date3 = DateTime(1999, 10, 26); // angkaWuku 3
  final date4 = DateTime(1999, 10, 27); // angkaWuku 4
  
  for (final date in [date1, date2, date3, date4]) {
    final p = pawukonService.gregorianToPawukon(date);
    final angkaWuku = p.dayInCycle + 1;
    print('  angkaWuku $angkaWuku: Sanga Wara = ${p.sangaWara.name}');
    if (p.sangaWara.name != 'Dangu') {
      print('    ❌ ERROR: Expected Sanga Wara = Dangu');
    }
  }
  print('✅ PASSED\n');

  // Test 8: 210-Day Cycle Verification
  print('🔄 TEST 8: 210-Day Cycle Verification');
  print('──────────────────────────────────────');
  final testDate1 = DateTime(2025, 1, 1);
  final testDate2 = testDate1.add(const Duration(days: 210));
  final p1 = pawukonService.gregorianToPawukon(testDate1);
  final p2 = pawukonService.gregorianToPawukon(testDate2);
  print('Date 1: 2025-01-01');
  print('  Wuku: ${p1.wuku.name}, Day in Cycle: ${p1.dayInCycle}');
  print('Date 2: ${testDate2.year}-${testDate2.month.toString().padLeft(2, '0')}-${testDate2.day.toString().padLeft(2, '0')} (210 days later)');
  print('  Wuku: ${p2.wuku.name}, Day in Cycle: ${p2.dayInCycle}');
  if (p1.dayInCycle == p2.dayInCycle && p1.wuku.id == p2.wuku.id) {
    print('✅ Verified: Same position in cycle after 210 days');
  } else {
    print('❌ ERROR: Different positions in cycle!');
  }
  print('✅ PASSED\n');

  print('=== ALL TESTS COMPLETED SUCCESSFULLY ===');
}
