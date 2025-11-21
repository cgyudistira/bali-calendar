import '../../data/models/saka_date.dart';
import 'lunar_phase_service.dart';

/// Service for calculating Saka calendar dates (Lunar calendar)
/// Uses Babadbali.com algorithm for accurate lunar phase calculation
class SakaService {
  // Constants
  static const int _dayNgunaratri = 63; // Ngunaratri cycle

  // Pivot date: 2000-01-06
  // Saka 1921, Sasih Kapitu (6), Pangelong 10
  static final DateTime _pivotDate2000 = DateTime(2000, 1, 6);
  static const int _pivotSaka2000 = 1921;
  static const int _pivotSasih2000 = 6; // Kapitu
  static const int _pivotSasihDay2000 = 10;
  static const bool _pivotIsPangelong2000 = true;
  static const int _pivotNgunaratri2000 = 424;
  static const bool _pivotIsNampih2000 = false;

  // Pivot date: 1970-01-01
  // Saka 1891, Sasih Kapitu (6), Pangelong 8
  static final DateTime _pivotDate1970 = DateTime(1970, 1, 1);
  static const int _pivotSaka1970 = 1891;
  static const int _pivotSasih1970 = 6; // Kapitu
  static const int _pivotSasihDay1970 = 8;
  static const bool _pivotIsPangelong1970 = true;
  static const int _pivotNgunaratri1970 = 50;
  static const bool _pivotIsNampih1970 = false;

  // Special Saka Kala period (different nampih rules)
  static final DateTime _sakaKalaStart = DateTime(1993, 1, 24);
  static final DateTime _sakaKalaEnd = DateTime(2003, 1, 3);

  /// Calculate Saka date from Gregorian date
  /// Returns null if date is out of supported range (1900-2100)
  SakaDate? gregorianToSaka(DateTime date) {
    // Validate date range
    if (date.year < 1900 || date.year > 2100) {
      return null;
    }
    
    // Normalize to midnight
    final normalizedDate = DateTime(date.year, date.month, date.day);

    // Choose best pivot
    final usePivot2000 = normalizedDate.compareTo(_pivotDate2000) >= 0;
    final pivot = usePivot2000 ? _pivotDate2000 : _pivotDate1970;
    final pivotSaka = usePivot2000 ? _pivotSaka2000 : _pivotSaka1970;
    final pivotSasih = usePivot2000 ? _pivotSasih2000 : _pivotSasih1970;
    final pivotSasihDay = usePivot2000 ? _pivotSasihDay2000 : _pivotSasihDay1970;
    final pivotIsPangelong = usePivot2000 ? _pivotIsPangelong2000 : _pivotIsPangelong1970;
    final pivotNgunaratri = usePivot2000 ? _pivotNgunaratri2000 : _pivotNgunaratri1970;
    final pivotIsNampih = usePivot2000 ? _pivotIsNampih2000 : _pivotIsNampih1970;

    // Calculate day difference
    final dayDiff = normalizedDate.difference(pivot).inDays;

    // Calculate Sasih info (year, month, nampih status)
    final sasihInfo = _calculateSasihInfo(
      pivot,
      dayDiff,
      pivotSaka,
      pivotSasih,
      pivotSasihDay,
      pivotIsNampih,
      pivotNgunaratri,
    );

    // Calculate Sasih day (penanggal/pangelong and day number)
    final sasihDayInfo = _calculateSasihDay(
      pivot,
      dayDiff,
      pivotSasihDay,
      pivotIsPangelong,
      pivotNgunaratri,
    );

    final sakaYear = sasihInfo['year'] as int;
    final sasihId = sasihInfo['sasih'] as int;
    final isNampih = sasihInfo['isNampih'] as bool;
    final day = sasihDayInfo['day'] as int;
    final isPangelong = sasihDayInfo['isPangelong'] as bool;
    final isNgunaratri = sasihDayInfo['isNgunaratri'] as bool;

    // Get Sasih object
    final sasih = _getSasih(sasihId, isNampih, sakaYear);

    // Determine day info (Penanggal, Pangelong, Purnama, Tilem)
    // Pass normalizedDate for lookup table verification
    final dayInfo = _getSasihDayInfo(day, isPangelong, isNgunaratri, sasih, sakaYear, normalizedDate);

    return SakaDate(
      year: sakaYear,
      sasih: sasih,
      day: day,
      dayInfo: dayInfo,
      isNgunaratri: isNgunaratri,
    );
  }

  /// Get current Saka date
  SakaDate? getCurrentSakaDate() {
    return gregorianToSaka(DateTime.now());
  }
  
  /// Validate if a date is within supported range
  bool isDateInRange(DateTime date) {
    return date.year >= 1900 && date.year <= 2100;
  }

  /// Calculate Sasih information (year, month, nampih status)
  Map<String, dynamic> _calculateSasihInfo(
    DateTime pivot,
    int dayDiff,
    int pivotSaka,
    int pivotSasih,
    int pivotSasihDay,
    bool pivotIsNampih,
    int pivotNgunaratri,
  ) {
    final daySkip = (dayDiff / _dayNgunaratri).ceil();
    final dayTotal = pivotSasihDay + dayDiff + daySkip;

    final pivotOffset = (pivotSasihDay == 0 && pivotNgunaratri == 0) ? 0 : 1;
    int totalSasih = (dayTotal / 30).ceil() - pivotOffset;

    int currentSasih = pivotSasih;
    int currentSaka = pivotSaka - (currentSasih == 9 ? 1 : 0); // Kadasa
    int nampihCount = pivotIsNampih ? 1 : 0;

    bool inSK = pivot.compareTo(_sakaKalaStart) >= 0 && pivot.compareTo(_sakaKalaEnd) < 0;

    while (totalSasih != 0) {
      if (dayDiff >= 0) {
        if (nampihCount == 0 || nampihCount == 2) {
          nampihCount = 0;
          currentSasih = _mod(currentSasih + 1, 12);
        }

        totalSasih = totalSasih - 1;

        if (currentSasih == 9 && nampihCount == 0) {
          // Kadasa
          currentSaka = currentSaka + 1;
        }

        if (currentSasih == 7 && currentSaka == 1914) {
          // Kawolu
          inSK = true;
        } else if (currentSasih == 7 && currentSaka == 1924) {
          inSK = false;
        }
      } else {
        if (nampihCount == 0 || nampihCount == 2) {
          nampihCount = 0;
          currentSasih = _mod(currentSasih - 1, 12);
        }

        totalSasih = totalSasih + 1;

        if (currentSasih == 8 && nampihCount == 0) {
          // Kasanga
          currentSaka = currentSaka - 1;
        }

        if (currentSasih == 6 && currentSaka == 1914) {
          // Kapitu
          inSK = false;
        } else if (currentSasih == 6 && currentSaka == 1924) {
          inSK = true;
        }
      }

      // Check for Nampih Sasih based on 19-year cycle
      nampihCount += _checkNampihSasih(currentSaka, currentSasih, inSK);
    }

    final isNampih = dayTotal >= 0 ? (nampihCount == 2) : (nampihCount == 1);

    return {
      'year': currentSaka,
      'sasih': currentSasih,
      'isNampih': isNampih,
    };
  }

  /// Calculate Sasih day information
  Map<String, dynamic> _calculateSasihDay(
    DateTime pivot,
    int dayDiff,
    int pivotSasihDay,
    bool pivotIsPangelong,
    int pivotNgunaratri,
  ) {
    final daySkip = (dayDiff / _dayNgunaratri).ceil();
    
    // Convert pivot day to absolute position in 30-day cycle
    // Penanggal 1-15 = days 1-15, Pangelong 1-15 = days 16-30
    int pivotAbsoluteDay = pivotIsPangelong ? (15 + pivotSasihDay) : pivotSasihDay;
    
    // Calculate total absolute day position
    final dayTotal = pivotAbsoluteDay + dayDiff + daySkip;

    // Calculate position in 30-day cycle
    int absoluteDay = _mod(dayTotal, 30);
    if (absoluteDay == 0) absoluteDay = 30;
    
    // Determine if pangelong or penanggal
    // Days 1-15 are penanggal (waxing), days 16-30 are pangelong (waning)
    final isPangelong = (absoluteDay > 15);
    final isNgunaratri = (_mod(dayDiff, _dayNgunaratri) == 0);

    // Get day number within phase (1-15)
    int day = isPangelong ? (absoluteDay - 15) : absoluteDay;

    return {
      'day': day,
      'isPangelong': isPangelong,
      'isNgunaratri': isNgunaratri,
    };
  }

  /// Check if current sasih should be nampih based on 19-year cycle
  int _checkNampihSasih(int saka, int sasih, bool inSK) {
    final mod19 = saka % 19;

    switch (mod19) {
      case 0:
      case 6:
      case 11:
        if (sasih == 10 && !inSK && saka != 1925) return 1; // Destha
        break;
      case 3:
      case 8:
      case 14:
      case 16:
        if (sasih == 11 && !inSK) return 1; // Sadha
        break;
      case 2:
      case 10:
        if (sasih == 10 && inSK) return 1; // Destha
        break;
      case 4:
        if (sasih == 2 && inSK) return 1; // Katiga
        break;
      case 7:
        if (sasih == 0 && inSK) return 1; // Kasa
        break;
      case 13:
        if (sasih == 9 && inSK) return 1; // Kadasa
        break;
      case 15:
        if (sasih == 1 && inSK) return 1; // Karo
        break;
      case 18:
        if (sasih == 11 && inSK) return 1; // Sadha
        break;
    }

    return 0;
  }

  /// Get Sasih object based on ID and nampih status
  Sasih _getSasih(int sasihId, bool isNampih, int saka) {
    if (!isNampih) {
      return Sasih.values[sasihId];
    }

    // Handle nampih sasih
    if (sasihId == 10) {
      // Destha
      return saka < 1914 ? Sasih.values[12] : Sasih.values[14]; // Mala/Nampih Destha
    } else if (sasihId == 2) {
      return Sasih.values[15]; // Nampih Katiga
    } else if (sasihId == 0) {
      return Sasih.values[16]; // Nampih Kasa
    } else if (sasihId == 9) {
      return Sasih.values[17]; // Nampih Kadasa
    } else if (sasihId == 1) {
      return Sasih.values[18]; // Nampih Karo
    } else if (sasihId == 11) {
      // Sadha
      return saka < 1914 ? Sasih.values[13] : Sasih.values[19]; // Mala/Nampih Sadha
    }

    return Sasih.values[sasihId];
  }

  /// Determine day info (Penanggal, Pangelong, Purnama, Tilem)
  /// Uses Babadbali.com algorithm for accurate lunar phase calculation
  SasihDayInfo _getSasihDayInfo(int day, bool isPangelong, bool isNgunaratri, Sasih sasih, int saka, DateTime date) {
    // Use Babadbali algorithm for accurate Purnama/Tilem detection
    if (LunarPhaseService.isPurnama(date)) {
      return SasihDayInfo.purnama;
    }
    if (LunarPhaseService.isTilem(date)) {
      return SasihDayInfo.tilem;
    }
    
    // Return appropriate phase based on pangelong/penanggal
    if (isPangelong) {
      return SasihDayInfo.pangelong;
    } else {
      return SasihDayInfo.penanggal;
    }
  }

  /// Modulo operation that handles negative numbers correctly
  int _mod(int a, int b) {
    return ((a % b) + b) % b;
  }
}
