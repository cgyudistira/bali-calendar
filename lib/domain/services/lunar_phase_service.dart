import '../../data/lookup/verified_purnama_tilem.dart';

/// Lunar Phase Service for Balinese Calendar
/// Based on Balinese lunar calendar system (Purnama-Tilem)
/// 
/// Uses hybrid approach:
/// 1. Verified lookup table for known dates (100% accuracy)
/// 2. Astronomical calculation for other dates
/// 
/// The Balinese calendar uses a lunar cycle of 29.53059 days (29 days 12 hours 44 minutes).
/// Each Sasih (lunar month) consists of 30 tithi: 15 Penanggal (waxing) + 15 Pangelong (waning).
/// Every 63 days, there is a Tithi Nampih adjustment because each Sasih must be expressed 
/// in whole days (29 or 30 days).
/// 
/// Reference: Balinese Calendar System (Eka Sungsang)
class LunarPhaseService {
  // Private constructor to prevent instantiation
  LunarPhaseService._();
  
  // Lunar cycle constant (synodic month)
  static const double _lunarCycle = 29.53059; // days
  
  // Verified pivot dates for accurate calculation
  // Using astronomically verified date with Balinese calendar adjustment
  // The Balinese calendar typically marks Purnama/Tilem 1 day after astronomical peak
  static final DateTime _pivotPurnama = DateTime(2024, 12, 16); // Adjusted pivot
  
  // Calculate Tilem pivot from Purnama (half cycle before)
  static DateTime get _pivotTilem => _pivotPurnama.subtract(
    Duration(days: (_lunarCycle / 2).round())
  ); // Should be around 2 December 2024
  
  /// Calculate days since last new moon (Tilem)
  /// Returns a value from 0 to ~29.53 representing position in lunar cycle
  static double _daysSinceNewMoon(DateTime date) {
    final daysSincePivot = date.difference(_pivotTilem).inDays.toDouble();
    
    // Calculate position in lunar cycle
    double position = daysSincePivot % _lunarCycle;
    
    // Normalize to 0-29.53 range
    if (position < 0) {
      position += _lunarCycle;
    }
    
    return position;
  }
  
  /// Calculate lunar phase (0-29 scale for compatibility)
  /// Returns phase value: 0=tilem, ~15=purnama, range 0-29
  static int calculateLunarPhase(DateTime date) {
    final days = _daysSinceNewMoon(date);
    // Convert to 0-29 scale (30 tithi system)
    return (days * 30 / _lunarCycle).round() % 30;
  }
  
  /// Check if date is Tilem (New Moon)
  /// Uses verified lookup table first, then falls back to astronomical calculation
  static bool isTilem(DateTime date) {
    // PRIORITY 1: Check verified lookup table
    if (VerifiedPurnamaTilem.hasVerifiedData(date)) {
      return VerifiedPurnamaTilem.isTilem(date);
    }
    
    // Check if any neighbor date is verified Tilem - if so, this date is NOT Tilem
    final yesterday = date.subtract(const Duration(days: 1));
    final tomorrow = date.add(const Duration(days: 1));
    
    if (VerifiedPurnamaTilem.isTilem(yesterday) || VerifiedPurnamaTilem.isTilem(tomorrow)) {
      return false;
    }
    
    // PRIORITY 2: Astronomical calculation
    final days = _daysSinceNewMoon(date);
    
    // Calculate distance from Tilem (day 0)
    final distanceFromTilem = days < (_lunarCycle / 2) ? days : (_lunarCycle - days);
    
    final daysYesterday = _daysSinceNewMoon(yesterday);
    final daysTomorrow = _daysSinceNewMoon(tomorrow);
    
    final distanceYesterday = daysYesterday < (_lunarCycle / 2) ? daysYesterday : (_lunarCycle - daysYesterday);
    final distanceTomorrow = daysTomorrow < (_lunarCycle / 2) ? daysTomorrow : (_lunarCycle - daysTomorrow);
    
    // This date is Tilem if it's closer to day 0 than both neighbors
    return distanceFromTilem < distanceYesterday && distanceFromTilem < distanceTomorrow;
  }
  
  /// Check if date is Purnama (Full Moon)
  /// Uses verified lookup table first, then falls back to astronomical calculation
  static bool isPurnama(DateTime date) {
    // PRIORITY 1: Check verified lookup table
    if (VerifiedPurnamaTilem.hasVerifiedData(date)) {
      return VerifiedPurnamaTilem.isPurnama(date);
    }
    
    // Check if any neighbor date is verified Purnama - if so, this date is NOT Purnama
    final yesterday = date.subtract(const Duration(days: 1));
    final tomorrow = date.add(const Duration(days: 1));
    
    if (VerifiedPurnamaTilem.isPurnama(yesterday) || VerifiedPurnamaTilem.isPurnama(tomorrow)) {
      return false;
    }
    
    // PRIORITY 2: Astronomical calculation
    final days = _daysSinceNewMoon(date);
    final halfCycle = _lunarCycle / 2.0; // ~14.76529
    
    // Calculate distance from Purnama (half cycle)
    final distanceFromPurnama = (days - halfCycle).abs();
    
    final daysYesterday = _daysSinceNewMoon(yesterday);
    final daysTomorrow = _daysSinceNewMoon(tomorrow);
    
    final distanceYesterday = (daysYesterday - halfCycle).abs();
    final distanceTomorrow = (daysTomorrow - halfCycle).abs();
    
    // This date is Purnama if it's closer to half cycle than both neighbors
    return distanceFromPurnama < distanceYesterday && distanceFromPurnama < distanceTomorrow;
  }
  
  /// Get lunar phase description
  static String getLunarPhaseDescription(DateTime date) {
    final phase = calculateLunarPhase(date);
    
    if (phase <= 2 || phase >= 28) {
      return 'Tilem (New Moon)';
    } else if (phase >= 3 && phase <= 6) {
      return 'Bulan Sabit Pertama';
    } else if (phase >= 7 && phase <= 12) {
      return 'Bulan Paruh Pertama';
    } else if (phase >= 13 && phase <= 17) {
      return 'Purnama (Full Moon)';
    } else if (phase >= 18 && phase <= 24) {
      return 'Bulan Paruh Terakhir';
    } else if (phase >= 25 && phase <= 27) {
      return 'Bulan Sabit Terakhir';
    } else {
      return 'Bulan Mati';
    }
  }
  
  /// Get days since new moon (for debugging/testing)
  static double getDaysSinceNewMoon(DateTime date) {
    return _daysSinceNewMoon(date);
  }
}
