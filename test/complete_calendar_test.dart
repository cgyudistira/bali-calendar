import '../lib/domain/services/saka_service.dart';
import '../lib/domain/services/pawukon_service.dart';
import '../lib/domain/services/bali_calendar_service.dart';
import '../lib/data/models/saka_date.dart';

/// Complete Bali Calendar Test
void main() {
  print('=== BALI CALENDAR TEST ===\n');

  final sakaService = SakaService();
  final pawukonService = PawukonService();
  final baliCalendarService = BaliCalendarService(sakaService, pawukonService);

  // Test current date
  final testDate = DateTime.now();
  final calendar = baliCalendarService.getCalendarForDate(testDate);

  print('📅 GREGORIAN DATE');
  print('─────────────────');
  print('${testDate.day}/${testDate.month}/${testDate.year}');
  print('');

  print('🌙 SAKA CALENDAR (Lunar)');
  print('────────────────────────');
  print('Year: ${calendar.sakaDate.year}');
  print('Sasih: ${calendar.sakaDate.sasih.name}');
  print('Day: ${calendar.sakaDate.dayInfo == SasihDayInfo.penanggal || calendar.sakaDate.dayInfo == SasihDayInfo.purnama ? "Penanggal" : "Pangelong"} ${calendar.sakaDate.day}');
  if (calendar.sakaDate.isPurnama) print('✨ PURNAMA (Full Moon)');
  if (calendar.sakaDate.isTilem) print('🌑 TILEM (New Moon)');
  if (calendar.sakaDate.isNgunaratri) print('⚡ NGUNARATRI');
  print('');

  print('🔄 PAWUKON CALENDAR (210-Day Cycle)');
  print('───────────────────────────────────');
  print('Wuku: ${calendar.pawukonDate.wuku.name} (${calendar.pawukonDate.wuku.id})');
  print('Day in Cycle: ${calendar.pawukonDate.dayInCycle}/210');
  print('');

  print('📊 COMPLETE WEWARAN (All 10 Cycles)');
  print('───────────────────────────────────');
  print('1️⃣  Eka Wara (1-day):   ${calendar.pawukonDate.ekaWara.name.isEmpty ? "(empty)" : calendar.pawukonDate.ekaWara.name} (urip: ${calendar.pawukonDate.ekaWara.urip})');
  print('2️⃣  Dwi Wara (2-day):   ${calendar.pawukonDate.dwiWara.name} (urip: ${calendar.pawukonDate.dwiWara.urip})');
  print('3️⃣  Tri Wara (3-day):   ${calendar.pawukonDate.triWara.name} (urip: ${calendar.pawukonDate.triWara.urip})');
  print('4️⃣  Catur Wara (4-day): ${calendar.pawukonDate.caturWara.name} (urip: ${calendar.pawukonDate.caturWara.urip})');
  print('5️⃣  Panca Wara (5-day): ${calendar.pawukonDate.pancaWara.name} (urip: ${calendar.pawukonDate.pancaWara.urip})');
  print('6️⃣  Sad Wara (6-day):   ${calendar.pawukonDate.sadWara.name} (urip: ${calendar.pawukonDate.sadWara.urip})');
  print('7️⃣  Sapta Wara (7-day): ${calendar.pawukonDate.saptaWara.name} (urip: ${calendar.pawukonDate.saptaWara.urip})');
  print('8️⃣  Asta Wara (8-day):  ${calendar.pawukonDate.astaWara.name} (urip: ${calendar.pawukonDate.astaWara.urip})');
  print('9️⃣  Sanga Wara (9-day): ${calendar.pawukonDate.sangaWara.name} (urip: ${calendar.pawukonDate.sangaWara.urip})');
  print('🔟 Dasa Wara (10-day):  ${calendar.pawukonDate.dasaWara.name} (urip: ${calendar.pawukonDate.dasaWara.urip})');
  print('');

  print('💫 URIP/NEPTU VALUES');
  print('────────────────────');
  print('Sapta Wara:     ${calendar.pawukonDate.saptaWara.urip}');
  print('Panca Wara:     ${calendar.pawukonDate.pancaWara.urip}');
  print('─────────────────────');
  print('Urip Dasar:     ${calendar.pawukonDate.uripBasic} (Sapta + Panca)');
  print('');
  print('Detail Tambahan:');
  print('Wuku Urip:      ${calendar.pawukonDate.wuku.urip}');
  print('Tri Wara:       ${calendar.pawukonDate.triWara.urip}');
  print('─────────────────────');
  print('Urip Lengkap:   ${calendar.pawukonDate.uripExtended} (Wuku + Sapta + Panca + Tri)');
  print('');

  print('🌟 SPECIAL DAYS CHECK');
  print('─────────────────────');
  final flags = baliCalendarService.getSpecialDayFlags(testDate);
  if (flags['isKajengKliwon']!) print('✅ KAJENG KLIWON');
  if (flags['isAnggaraKasih']!) print('✅ ANGGARA KASIH (Mangala Kasih)');
  if (flags['isBudaCemeng']!) print('✅ BUDA CEMENG (Buda Kliwon Wuku Wayang)');
  if (flags['isPurnama']!) print('✅ PURNAMA');
  if (flags['isTilem']!) print('✅ TILEM');
  
  if (!flags['isKajengKliwon']! && !flags['isAnggaraKasih']! && 
      !flags['isBudaCemeng']! && !flags['isPurnama']! && !flags['isTilem']!) {
    print('(No special days)');
  }
  print('');

  print('📝 SUMMARY');
  print('──────────');
  print('${calendar.pawukonDate.saptaWara.name} ${calendar.pawukonDate.pancaWara.name}');
  print('Wuku ${calendar.pawukonDate.wuku.name}');
  print('Saka ${calendar.sakaDate.year}, ${calendar.sakaDate.sasih.name}');
  print('');

  print('=== TEST COMPLETE ===');
}
