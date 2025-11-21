import 'package:flutter/material.dart';

/// Model for notification preferences
class NotificationPreferences {
  /// Enable Purnama (full moon) notifications
  final bool enablePurnama;
  
  /// Enable Tilem (new moon) notifications
  final bool enableTilem;
  
  /// Enable Kajeng Kliwon notifications
  final bool enableKajengKliwon;
  
  /// Enable Tumpek celebrations notifications
  final bool enableTumpek;
  
  /// Enable major holidays notifications
  final bool enableMajorHolidays;
  
  /// Enable otonan (birthday) notifications
  final bool enableOtonan;
  
  /// Number of days in advance to send notifications (0-7)
  final int advanceDays;
  
  /// Time of day to send notifications
  final TimeOfDay notificationTime;
  
  const NotificationPreferences({
    this.enablePurnama = true,
    this.enableTilem = true,
    this.enableKajengKliwon = true,
    this.enableTumpek = true,
    this.enableMajorHolidays = true,
    this.enableOtonan = true,
    this.advanceDays = 3,
    this.notificationTime = const TimeOfDay(hour: 8, minute: 0),
  });
  
  /// Create default preferences
  factory NotificationPreferences.defaults() {
    return const NotificationPreferences();
  }
  
  /// Create preferences with all notifications disabled
  factory NotificationPreferences.allDisabled() {
    return const NotificationPreferences(
      enablePurnama: false,
      enableTilem: false,
      enableKajengKliwon: false,
      enableTumpek: false,
      enableMajorHolidays: false,
      enableOtonan: false,
      advanceDays: 0,
    );
  }
  
  /// Copy with method for immutable updates
  NotificationPreferences copyWith({
    bool? enablePurnama,
    bool? enableTilem,
    bool? enableKajengKliwon,
    bool? enableTumpek,
    bool? enableMajorHolidays,
    bool? enableOtonan,
    int? advanceDays,
    TimeOfDay? notificationTime,
  }) {
    return NotificationPreferences(
      enablePurnama: enablePurnama ?? this.enablePurnama,
      enableTilem: enableTilem ?? this.enableTilem,
      enableKajengKliwon: enableKajengKliwon ?? this.enableKajengKliwon,
      enableTumpek: enableTumpek ?? this.enableTumpek,
      enableMajorHolidays: enableMajorHolidays ?? this.enableMajorHolidays,
      enableOtonan: enableOtonan ?? this.enableOtonan,
      advanceDays: advanceDays ?? this.advanceDays,
      notificationTime: notificationTime ?? this.notificationTime,
    );
  }
  
  /// Check if any notifications are enabled
  bool get hasAnyEnabled {
    return enablePurnama ||
           enableTilem ||
           enableKajengKliwon ||
           enableTumpek ||
           enableMajorHolidays ||
           enableOtonan;
  }
  
  /// Check if all notifications are enabled
  bool get allEnabled {
    return enablePurnama &&
           enableTilem &&
           enableKajengKliwon &&
           enableTumpek &&
           enableMajorHolidays &&
           enableOtonan;
  }
  
  /// Get list of enabled categories
  List<String> get enabledCategories {
    final categories = <String>[];
    if (enablePurnama) categories.add('Purnama');
    if (enableTilem) categories.add('Tilem');
    if (enableKajengKliwon) categories.add('Kajeng Kliwon');
    if (enableTumpek) categories.add('Tumpek');
    if (enableMajorHolidays) categories.add('Major Holidays');
    if (enableOtonan) categories.add('Otonan');
    return categories;
  }
  
  /// Convert to map for storage
  Map<String, dynamic> toMap() {
    return {
      'enablePurnama': enablePurnama,
      'enableTilem': enableTilem,
      'enableKajengKliwon': enableKajengKliwon,
      'enableTumpek': enableTumpek,
      'enableMajorHolidays': enableMajorHolidays,
      'enableOtonan': enableOtonan,
      'advanceDays': advanceDays,
      'notificationTimeHour': notificationTime.hour,
      'notificationTimeMinute': notificationTime.minute,
    };
  }
  
  /// Create from map
  factory NotificationPreferences.fromMap(Map<String, dynamic> map) {
    return NotificationPreferences(
      enablePurnama: map['enablePurnama'] as bool? ?? true,
      enableTilem: map['enableTilem'] as bool? ?? true,
      enableKajengKliwon: map['enableKajengKliwon'] as bool? ?? true,
      enableTumpek: map['enableTumpek'] as bool? ?? true,
      enableMajorHolidays: map['enableMajorHolidays'] as bool? ?? true,
      enableOtonan: map['enableOtonan'] as bool? ?? true,
      advanceDays: map['advanceDays'] as int? ?? 3,
      notificationTime: TimeOfDay(
        hour: map['notificationTimeHour'] as int? ?? 8,
        minute: map['notificationTimeMinute'] as int? ?? 0,
      ),
    );
  }
  
  @override
  String toString() {
    return 'NotificationPreferences('
        'purnama: $enablePurnama, '
        'tilem: $enableTilem, '
        'kajengKliwon: $enableKajengKliwon, '
        'tumpek: $enableTumpek, '
        'majorHolidays: $enableMajorHolidays, '
        'otonan: $enableOtonan, '
        'advanceDays: $advanceDays, '
        'time: ${notificationTime.hour}:${notificationTime.minute}'
        ')';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationPreferences &&
        other.enablePurnama == enablePurnama &&
        other.enableTilem == enableTilem &&
        other.enableKajengKliwon == enableKajengKliwon &&
        other.enableTumpek == enableTumpek &&
        other.enableMajorHolidays == enableMajorHolidays &&
        other.enableOtonan == enableOtonan &&
        other.advanceDays == advanceDays &&
        other.notificationTime.hour == notificationTime.hour &&
        other.notificationTime.minute == notificationTime.minute;
  }
  
  @override
  int get hashCode {
    return Object.hash(
      enablePurnama,
      enableTilem,
      enableKajengKliwon,
      enableTumpek,
      enableMajorHolidays,
      enableOtonan,
      advanceDays,
      notificationTime.hour,
      notificationTime.minute,
    );
  }
}
