import '../../data/models/pawukon_date.dart';

/// Service for calculating Pawukon calendar dates
class PawukonService {
  // Constants
  static const int _dayPawukon = 210; // 30 wuku × 7 days

  // Pivot date: 2000-01-01 (Updated based on PHP implementation)
  // This is Wuku Sungsang (10), day 70 in cycle
  static final DateTime _pivotDate2000 = DateTime(2000, 1, 1);
  static const int _pivotPawukonDay2000 = 70;

  // Pivot date: 1970-01-01
  // This is Wuku Tolu (5), day 33 in cycle
  static final DateTime _pivotDate1970 = DateTime(1970, 1, 1);
  static const int _pivotPawukonDay1970 = 33;

  /// Calculate Pawukon date from Gregorian date
  /// Returns null if date is out of supported range (1900-2100)
  PawukonDate? gregorianToPawukon(DateTime date) {
    // Validate date range
    if (date.year < 1900 || date.year > 2100) {
      return null;
    }
    
    // Normalize to midnight
    final normalizedDate = DateTime(date.year, date.month, date.day);

    // Choose best pivot (use 2000 for dates >= 2000-01-01)
    final pivot = normalizedDate.compareTo(_pivotDate2000) >= 0
        ? _pivotDate2000
        : _pivotDate1970;
    final pivotDay = normalizedDate.compareTo(_pivotDate2000) >= 0
        ? _pivotPawukonDay2000
        : _pivotPawukonDay1970;

    // Calculate day difference
    final dayDiff = normalizedDate.difference(pivot).inDays;

    // Calculate position in 210-day cycle
    int angkaWuku;
    if (dayDiff >= 0) {
      angkaWuku = (pivotDay + dayDiff) % _dayPawukon;
    } else {
      angkaWuku = _dayPawukon - (-(pivotDay + dayDiff) % _dayPawukon);
    }
    if (angkaWuku == 0) angkaWuku = _dayPawukon;

    final pawukonDay = angkaWuku - 1; // Convert to 0-based index

    // Calculate wuku (0-29)
    int noWuku = ((angkaWuku / 7.0).ceil());
    if (noWuku > 30) noWuku %= 30;
    if (noWuku == 0) noWuku = 30;
    final wuku = Wuku.values[noWuku - 1];

    // Calculate saptawara (0-6) - 7-day week (based on day of week)
    final saptawaraId = normalizedDate.weekday % 7; // Sunday = 0
    final saptaWara = SaptaWara.values[saptawaraId];

    // Calculate pancawara (0-4) - 5-day cycle
    // Formula: (angkaWuku % 5) + 1, then map to 0-based index
    final noPancawara = (angkaWuku % 5) + 1;
    final pancawaraId = noPancawara - 1;
    final pancaWara = PancaWara.values[pancawaraId];

    // Calculate triwara (0-2) - 3-day cycle
    // Formula: angkaWuku % 3
    int noTriwara = angkaWuku % 3;
    if (noTriwara == 0) noTriwara = 3;
    final triWara = TriWara.values[noTriwara - 1];

    // Calculate ekawara (0-1)
    // Luang if (uripPancawara + uripSaptawara) is odd
    final uripSum = pancaWara.urip + saptaWara.urip;
    final noEkawara = uripSum % 2 != 0 ? 1 : 0;
    final ekaWara = EkaWara.values[noEkawara];

    // Calculate dwiwara (0-1)
    // Menga if (uripPancawara + uripSaptawara) is even, Pepet if odd
    final noDwiwara = uripSum % 2 == 0 ? 0 : 1;
    final dwiWara = DwiWara.values[noDwiwara];

    // Calculate caturwara (0-3)
    // Special case: Jaya Tiga (angkaWuku 71, 72, 73)
    int noCaturwara;
    if (angkaWuku == 71 || angkaWuku == 72 || angkaWuku == 73) {
      noCaturwara = 3; // Jaya
    } else if (angkaWuku <= 70) {
      noCaturwara = angkaWuku % 4;
    } else {
      noCaturwara = (angkaWuku + 2) % 4;
    }
    if (noCaturwara == 0) noCaturwara = 4;
    final caturWara = CaturWara.values[noCaturwara - 1];

    // Calculate sadwara (0-5) - 6-day cycle
    int noSadwara = angkaWuku % 6;
    if (noSadwara == 0) noSadwara = 6;
    final sadWara = SadWara.values[noSadwara - 1];

    // Calculate astawara (0-7) - 8-day cycle
    // Special case: Kala Tiga (angkaWuku 71, 72, 73)
    int noAstawara;
    if (angkaWuku == 71 || angkaWuku == 72 || angkaWuku == 73) {
      noAstawara = 7; // Kala
    } else if (angkaWuku <= 70) {
      noAstawara = angkaWuku % 8;
    } else {
      noAstawara = (angkaWuku + 6) % 8;
    }
    if (noAstawara == 0) noAstawara = 8;
    final astaWara = AstaWara.values[noAstawara - 1];

    // Calculate sangawara (0-8) - 9-day cycle
    // Special case: Dangu Pat (angkaWuku 1-4)
    int noSangawara;
    if (angkaWuku <= 4) {
      noSangawara = 1; // Dangu
    } else {
      noSangawara = (angkaWuku + 6) % 9;
    }
    if (noSangawara == 0) noSangawara = 9;
    final sangaWara = SangaWara.values[noSangawara - 1];

    // Calculate dasawara (0-9) - 10-day cycle
    // Formula: ((uripPancawara + uripSaptawara) % 10) + 1
    final noDasawara = ((pancaWara.urip + saptaWara.urip) % 10) + 1;
    final dasaWara = DasaWara.values[noDasawara - 1];

    // Calculate total urip
    final urip = wuku.urip + saptaWara.urip + pancaWara.urip + triWara.urip;

    return PawukonDate(
      dayInCycle: pawukonDay,
      wuku: wuku,
      ekaWara: ekaWara,
      dwiWara: dwiWara,
      triWara: triWara,
      caturWara: caturWara,
      pancaWara: pancaWara,
      sadWara: sadWara,
      saptaWara: saptaWara,
      astaWara: astaWara,
      sangaWara: sangaWara,
      dasaWara: dasaWara,
      urip: urip,
    );
  }

  /// Get current Pawukon date
  PawukonDate? getCurrentPawukonDate() {
    return gregorianToPawukon(DateTime.now());
  }
  
  /// Validate if a date is within supported range
  bool isDateInRange(DateTime date) {
    return date.year >= 1900 && date.year <= 2100;
  }

  /// Calculate days until next otonan (210-day cycle birthday)
  /// Returns null if dates are out of range
  int? daysUntilNextOtonan(DateTime birthDate, DateTime currentDate) {
    final birthPawukon = gregorianToPawukon(birthDate);
    final currentPawukon = gregorianToPawukon(currentDate);
    
    if (birthPawukon == null || currentPawukon == null) {
      return null;
    }

    final dayDiff = currentPawukon.dayInCycle - birthPawukon.dayInCycle;
    final daysUntilNext = dayDiff <= 0 ? -dayDiff : _dayPawukon - dayDiff;

    return daysUntilNext;
  }

  /// Get next otonan date
  /// Returns null if dates are out of range
  DateTime? getNextOtonan(DateTime birthDate, DateTime currentDate) {
    final daysUntil = daysUntilNextOtonan(birthDate, currentDate);
    if (daysUntil == null) return null;
    return currentDate.add(Duration(days: daysUntil));
  }

  /// Get list of future otonan dates
  /// Returns empty list if dates are out of range
  List<DateTime> getFutureOtonans(DateTime birthDate, int count) {
    final otonans = <DateTime>[];
    DateTime current = DateTime.now();

    for (int i = 0; i < count; i++) {
      final nextOtonan = getNextOtonan(birthDate, current);
      if (nextOtonan == null) break;
      otonans.add(nextOtonan);
      current = nextOtonan.add(const Duration(days: 1));
    }

    return otonans;
  }

  /// Check if a date is Kajeng Kliwon
  /// Kajeng Kliwon occurs when TriWara is Kajeng (2) and PancaWara is Kliwon (4)
  bool isKajengKliwon(DateTime date) {
    final pawukon = gregorianToPawukon(date);
    return pawukon.triWara.id == 2 && pawukon.pancaWara.id == 4;
  }

  /// Get all Kajeng Kliwon dates in a date range
  List<DateTime> getKajengKliwonDates(DateTime start, DateTime end) {
    final dates = <DateTime>[];
    DateTime current = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);

    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      if (isKajengKliwon(current)) {
        dates.add(current);
      }
      current = current.add(const Duration(days: 1));
    }

    return dates;
  }

  /// Modulo operation that handles negative numbers correctly
  int _mod(int a, int b) {
    return ((a % b) + b) % b;
  }
}
