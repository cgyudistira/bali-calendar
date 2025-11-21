/// Input validation utilities
class Validators {
  // Date range constants
  static const int minYear = 1900;
  static const int maxYear = 2100;
  
  /// Validates if a date is within the supported range (1900-2100)
  static bool isValidDateRange(DateTime date) {
    return date.year >= minYear && date.year <= maxYear;
  }
  
  /// Validates if a string is not empty
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
  
  /// Validates if a date is not in the future
  static bool isNotFutureDate(DateTime date) {
    final now = DateTime.now();
    return date.isBefore(now) || 
           (date.year == now.year && 
            date.month == now.month && 
            date.day == now.day);
  }
  
  /// Validates birth date (not in future, within range)
  static String? validateBirthDate(DateTime? date) {
    if (date == null) {
      return 'Please select a birth date';
    }
    
    if (!isValidDateRange(date)) {
      return 'Date must be between $minYear and $maxYear';
    }
    
    if (!isNotFutureDate(date)) {
      return 'Birth date cannot be in the future';
    }
    
    return null; // Valid
  }
  
  /// Validates activity type selection
  static String? validateActivityType(String? activityType) {
    if (!isNotEmpty(activityType)) {
      return 'Please select an activity type';
    }
    
    // Valid activity types
    const validTypes = [
      'Wedding',
      'Business Opening',
      'Travel',
      'Ceremony',
      'Construction',
      'Other',
    ];
    
    if (!validTypes.contains(activityType)) {
      return 'Invalid activity type selected';
    }
    
    return null; // Valid
  }
  
  /// Validates search period
  static String? validateSearchPeriod(int? days) {
    if (days == null) {
      return 'Please select a search period';
    }
    
    if (days < 1 || days > 365) {
      return 'Search period must be between 1 and 365 days';
    }
    
    return null; // Valid
  }
  
  /// Validates text input
  static String? validateText(String? value, {String? fieldName}) {
    if (!isNotEmpty(value)) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }
  
  /// Validates date for calendar operations
  static String? validateCalendarDate(DateTime? date) {
    if (date == null) {
      return 'Please select a date';
    }
    
    if (!isValidDateRange(date)) {
      return 'Date must be between $minYear and $maxYear';
    }
    
    return null; // Valid
  }
  
  /// Get user-friendly error message for date range
  static String getDateRangeErrorMessage() {
    return 'This app supports dates between $minYear and $maxYear only.';
  }
  
  /// Check if date is valid for calculations
  static bool canCalculateForDate(DateTime date) {
    return isValidDateRange(date);
  }
}
