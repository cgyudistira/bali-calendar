import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Accessibility utilities for the app
class AccessibilityUtils {
  /// Minimum touch target size (48x48dp as per Material Design guidelines)
  static const double minTouchTargetSize = 48.0;
  
  /// Check if a widget meets minimum touch target size
  static bool meetsMinTouchTarget(double width, double height) {
    return width >= minTouchTargetSize && height >= minTouchTargetSize;
  }
  
  /// Wrap a widget to ensure minimum touch target size
  static Widget ensureMinTouchTarget({
    required Widget child,
    double? width,
    double? height,
  }) {
    return SizedBox(
      width: width ?? minTouchTargetSize,
      height: height ?? minTouchTargetSize,
      child: Center(child: child),
    );
  }
  
  /// Get semantic label for a date
  static String getDateSemanticLabel(DateTime date, {bool includeWeekday = true}) {
    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    final weekday = includeWeekday ? '${weekdays[date.weekday - 1]}, ' : '';
    final month = months[date.month - 1];
    
    return '$weekday$month ${date.day}, ${date.year}';
  }
  
  /// Get semantic label for holy day
  static String getHolyDaySemanticLabel(String holyDayName) {
    return 'Holy day: $holyDayName';
  }
  
  /// Get semantic label for calendar date with holy days
  static String getCalendarDateSemanticLabel(
    DateTime date,
    List<String> holyDays,
  ) {
    final dateLabel = getDateSemanticLabel(date);
    if (holyDays.isEmpty) {
      return dateLabel;
    }
    
    final holyDaysLabel = holyDays.join(', ');
    return '$dateLabel. Holy days: $holyDaysLabel';
  }
  
  /// Get semantic label for navigation button
  static String getNavigationSemanticLabel(String destination) {
    return 'Navigate to $destination';
  }
  
  /// Get semantic label for action button
  static String getActionSemanticLabel(String action) {
    return action;
  }
  
  /// Check color contrast ratio (WCAG AA requires 4.5:1 for normal text)
  static double getContrastRatio(Color color1, Color color2) {
    final luminance1 = color1.computeLuminance();
    final luminance2 = color2.computeLuminance();
    
    final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
    final darker = luminance1 > luminance2 ? luminance2 : luminance1;
    
    return (lighter + 0.05) / (darker + 0.05);
  }
  
  /// Check if color combination meets WCAG AA standards (4.5:1)
  static bool meetsWCAGAA(Color foreground, Color background) {
    return getContrastRatio(foreground, background) >= 4.5;
  }
  
  /// Check if color combination meets WCAG AAA standards (7:1)
  static bool meetsWCAGAAA(Color foreground, Color background) {
    return getContrastRatio(foreground, background) >= 7.0;
  }
  
  /// Get semantic label for score/rating
  static String getScoreSemanticLabel(int score, int maxScore) {
    return 'Score: $score out of $maxScore';
  }
  
  /// Get semantic label for date picker
  static String getDatePickerSemanticLabel(DateTime? selectedDate) {
    if (selectedDate == null) {
      return 'Select a date';
    }
    return 'Selected date: ${getDateSemanticLabel(selectedDate)}';
  }
  
  /// Get semantic label for switch/toggle
  static String getSwitchSemanticLabel(String label, bool value) {
    return '$label: ${value ? "enabled" : "disabled"}';
  }
  
  /// Announce message to screen reader
  static void announce(BuildContext context, String message) {
    // Use SemanticsService to announce
    SemanticsService.announce(message, TextDirection.ltr);
  }
}
