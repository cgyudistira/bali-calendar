/// Input validation utilities
class Validators {
  /// Validates if a date is within the supported range (1900-2100)
  static bool isValidDateRange(DateTime date) {
    return date.year >= 1900 && date.year <= 2100;
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
      return 'Date must be between 1900 and 2100';
    }
    
    if (!isNotFutureDate(date)) {
      return 'Birth date cannot be in the future';
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
}
