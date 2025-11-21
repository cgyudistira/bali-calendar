/// Verified Purnama and Tilem dates
/// These dates are verified against Balinese calendar sources
/// and serve as ground truth for the lunar phase calculation
class VerifiedPurnamaTilem {
  // Private constructor
  VerifiedPurnamaTilem._();

  /// Verified Purnama dates (YYYY-MM-DD format)
  static const Set<String> purnama = {
    // 2024
    '2024-01-25',
    '2024-02-24',
    '2024-03-25',
    '2024-04-24',
    '2024-05-23',
    '2024-06-22',
    '2024-07-21',
    '2024-08-19',
    '2024-09-18',
    '2024-10-17',
    '2024-11-15',
    '2024-12-15',
    
    // 2025
    '2025-12-04', // Verified
  };

  /// Verified Tilem dates (YYYY-MM-DD format)
  static const Set<String> tilem = {
    // 2024
    '2024-01-11',
    '2024-02-09',
    '2024-03-10',
    '2024-04-08',
    '2024-05-08',
    '2024-06-06',
    '2024-07-06',
    '2024-08-04',
    '2024-09-03',
    '2024-10-02',
    '2024-11-01',
    '2024-12-01',
    '2024-12-30',
    
    // 2025
    '2025-12-19', // Verified
  };

  /// Check if a date is verified Purnama
  static bool isPurnama(DateTime date) {
    final key = _formatDate(date);
    return purnama.contains(key);
  }

  /// Check if a date is verified Tilem
  static bool isTilem(DateTime date) {
    final key = _formatDate(date);
    return tilem.contains(key);
  }

  /// Check if a date has verified data
  static bool hasVerifiedData(DateTime date) {
    final key = _formatDate(date);
    return purnama.contains(key) || tilem.contains(key);
  }

  /// Format date to YYYY-MM-DD
  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
