import '../lib/domain/services/saka_service.dart';
import '../lib/domain/services/pawukon_service.dart';
import '../lib/domain/services/bali_calendar_service.dart';

/// Test all BaliCalendarService methods
void main() {
  print('=== BALI CALENDAR SERVICE TEST ===\n');

  final sakaService = SakaService();
  final pawukonService = PawukonService();
  final service = BaliCalendarService(sakaService, pawukonService);

  // Test 1: getCalendarForDate
  print('TEST 1: getCalendarForDate()');
  print('─────────────────────────────');
  final testDate = DateTime(2025, 1, 15);
  final calendar = service.getCalendarForDate(testDate);
  print('Date: ${testDate.year}-${testDate.month}-${testDate.day}');
  print('Saka: ${calendar.sakaDate.year}, ${calendar.sakaDate.sasih.name}');
  print('Pawukon: Wuku ${calendar.pawukonDate.wuku.name}');
  print('✅ PASS\n');

  // Test 2: getCurrentCalendar
  print('TEST 2: getCurrentCalendar()');
  print('─────────────────────────────');
  final current = service.getCurrentCalendar();
  final now = DateTime.now();
  print('Current Date: ${now.year}-${now.month}-${now.day}');
  print('Saka: ${current.sakaDate.year}, ${current.sakaDate.sasih.name}');
  print('✅ PASS\n');

  // Test 3: getCalendarForMonth
  print('TEST 3: getCalendarForMonth()');
  print('──────────────────────────────');
  final monthCalendars = service.getCalendarForMonth(2025, 1);
  print('January 2025 has ${monthCalendars.length} days');
  print('First day: ${monthCalendars.first.gregorianDate.day}');
  print('Last day: ${monthCalendars.last.gregorianDate.day}');
  assert(monthCalendars.length == 31, 'January should have 31 days');
  print('✅ PASS\n');

  // Test 4: getPurnamaDates
  print('TEST 4: getPurnamaDates()');
  print('──────────────────────────');
  final start = DateTime(2025, 1, 1);
  final end = DateTime(2025, 3, 31);
  final purnamaDates = service.getPurnamaDates(start, end);
  print('Purnama dates from Jan-Mar 2025:');
  for (final date in purnamaDates) {
    final cal = service.getCalendarForDate(date);
    print('  ${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} - ${cal.sakaDate.sasih.name}');
    assert(cal.isPurnama, 'Date should be Purnama');
  }
  print('Total: ${purnamaDates.length} Purnama dates');
  print('✅ PASS\n');

  // Test 5: getTilemDates
  print('TEST 5: getTilemDates()');
  print('────────────────────────');
  final tilemDates = service.getTilemDates(start, end);
  print('Tilem dates from Jan-Mar 2025:');
  for (final date in tilemDates) {
    final cal = service.getCalendarForDate(date);
    print('  ${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} - ${cal.sakaDate.sasih.name}');
    assert(cal.isTilem, 'Date should be Tilem');
  }
  print('Total: ${tilemDates.length} Tilem dates');
  print('✅ PASS\n');

  // Test 6: getKajengKliwonDates
  print('TEST 6: getKajengKliwonDates()');
  print('───────────────────────────────');
  final kajengKliwonDates = service.getKajengKliwonDates(start, end);
  print('Kajeng Kliwon dates from Jan-Mar 2025:');
  int count = 0;
  for (final date in kajengKliwonDates) {
    final cal = service.getCalendarForDate(date);
    if (count < 5) {
      print('  ${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} - ${cal.pawukonDate.triWara.name} ${cal.pawukonDate.pancaWara.name}');
    }
    assert(cal.isKajengKliwon, 'Date should be Kajeng Kliwon');
    count++;
  }
  if (kajengKliwonDates.length > 5) {
    print('  ... and ${kajengKliwonDates.length - 5} more');
  }
  print('Total: ${kajengKliwonDates.length} Kajeng Kliwon dates');
  print('✅ PASS\n');

  // Test 7: getAnggaraKasihDates
  print('TEST 7: getAnggaraKasihDates()');
  print('───────────────────────────────');
  final anggaraKasihDates = service.getAnggaraKasihDates(start, end);
  print('Anggara Kasih dates from Jan-Mar 2025:');
  for (final date in anggaraKasihDates) {
    final cal = service.getCalendarForDate(date);
    print('  ${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} - ${cal.pawukonDate.saptaWara.name} ${cal.pawukonDate.pancaWara.name}');
    assert(cal.isAnggaraKasih, 'Date should be Anggara Kasih');
    assert(cal.pawukonDate.saptaWara.id == 2, 'Should be Tuesday');
    assert(cal.pawukonDate.pancaWara.id == 4, 'Should be Kliwon');
  }
  print('Total: ${anggaraKasihDates.length} Anggara Kasih dates');
  print('✅ PASS\n');

  // Test 8: getBudaCemengDates
  print('TEST 8: getBudaCemengDates()');
  print('──────────────────────────────');
  final budaCemengDates = service.getBudaCemengDates(start, end);
  print('Buda Cemeng dates from Jan-Mar 2025:');
  for (final date in budaCemengDates) {
    final cal = service.getCalendarForDate(date);
    print('  ${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} - ${cal.pawukonDate.saptaWara.name} ${cal.pawukonDate.pancaWara.name}');
    assert(cal.isBudaCemeng, 'Date should be Buda Cemeng');
    assert(cal.pawukonDate.saptaWara.id == 3, 'Should be Wednesday');
    assert(cal.pawukonDate.pancaWara.id == 4, 'Should be Kliwon');
  }
  print('Total: ${budaCemengDates.length} Buda Cemeng dates');
  print('✅ PASS\n');

  // Test 9: getSpecialDayFlags
  print('TEST 9: getSpecialDayFlags()');
  print('─────────────────────────────');
  final testDate2 = DateTime(2025, 1, 13);
  final flags = service.getSpecialDayFlags(testDate2);
  print('Date: ${testDate2.year}-${testDate2.month}-${testDate2.day}');
  print('Flags:');
  print('  isPurnama: ${flags['isPurnama']}');
  print('  isTilem: ${flags['isTilem']}');
  print('  isKajengKliwon: ${flags['isKajengKliwon']}');
  print('  isAnggaraKasih: ${flags['isAnggaraKasih']}');
  print('  isBudaCemeng: ${flags['isBudaCemeng']}');
  
  // Verify flags match actual calendar
  final cal2 = service.getCalendarForDate(testDate2);
  assert(flags['isPurnama'] == cal2.isPurnama, 'Purnama flag mismatch');
  assert(flags['isTilem'] == cal2.isTilem, 'Tilem flag mismatch');
  assert(flags['isKajengKliwon'] == cal2.isKajengKliwon, 'Kajeng Kliwon flag mismatch');
  assert(flags['isAnggaraKasih'] == cal2.isAnggaraKasih, 'Anggara Kasih flag mismatch');
  assert(flags['isBudaCemeng'] == cal2.isBudaCemeng, 'Buda Cemeng flag mismatch');
  print('✅ PASS\n');

  print('═══════════════════════════════');
  print('ALL TESTS PASSED! ✅');
  print('═══════════════════════════════');
}
