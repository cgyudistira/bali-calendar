import 'pawukon_date.dart';
import 'saka_date.dart';
import 'holy_day.dart';

/// Combined Balinese calendar date information
class BaliCalendarDate {
  final DateTime gregorianDate;
  final SakaDate sakaDate;
  final PawukonDate pawukonDate;
  final List<HolyDay> holyDays;

  const BaliCalendarDate({
    required this.gregorianDate,
    required this.sakaDate,
    required this.pawukonDate,
    this.holyDays = const [],
  });

  /// Check if this date is Kajeng Kliwon
  bool get isKajengKliwon =>
      pawukonDate.triWara.id == 2 && pawukonDate.pancaWara.id == 4;

  /// Check if this date is Purnama (full moon)
  bool get isPurnama => sakaDate.isPurnama;

  /// Check if this date is Tilem (new moon)
  bool get isTilem => sakaDate.isTilem;

  /// Check if this date is Anggara Kasih (Tuesday Kliwon)
  bool get isAnggaraKasih =>
      pawukonDate.saptaWara.id == 2 && pawukonDate.pancaWara.id == 4;

  /// Check if this date is Buda Cemeng (Wednesday Kliwon)
  bool get isBudaCemeng =>
      pawukonDate.saptaWara.id == 3 && pawukonDate.pancaWara.id == 4;

  /// Check if this date has any holy days
  bool get hasHolyDays => holyDays.isNotEmpty;
  
  /// Get holy days by category
  List<HolyDay> getHolyDaysByCategory(HolyDayCategory category) {
    return holyDays.where((hd) => hd.category == category).toList();
  }
  
  /// Check if this date has a major holiday
  bool get hasMajorHoliday => 
      holyDays.any((hd) => hd.category == HolyDayCategory.major);
  
  /// Get names of all holy days on this date
  List<String> get holyDayNames => holyDays.map((hd) => hd.name).toList();

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('Gregorian: ${gregorianDate.year}-${gregorianDate.month.toString().padLeft(2, '0')}-${gregorianDate.day.toString().padLeft(2, '0')}');
    buffer.writeln('Saka: $sakaDate');
    buffer.writeln('Pawukon: $pawukonDate');
    
    if (holyDays.isNotEmpty) {
      buffer.writeln('Holy Days:');
      for (final holyDay in holyDays) {
        buffer.writeln('  - ${holyDay.name} (${holyDay.category.displayName})');
      }
    }
    
    return buffer.toString();
  }
}
