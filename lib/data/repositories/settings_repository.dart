import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../models/notification_preferences.dart';

/// Repository for managing app settings using SharedPreferences
class SettingsRepository {
  static const String _keyBirthDate = 'birth_date';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyNotifyPurnama = 'notify_purnama';
  static const String _keyNotifyTilem = 'notify_tilem';
  static const String _keyNotifyKajengKliwon = 'notify_kajeng_kliwon';
  static const String _keyNotifyTumpek = 'notify_tumpek';
  static const String _keyNotifyMajorHolidays = 'notify_major_holidays';
  static const String _keyNotifyOtonan = 'notify_otonan';
  static const String _keyAdvanceNotificationDays = 'advance_notification_days';
  static const String _keyNotificationTime = 'notification_time';
  
  final SharedPreferences _prefs;
  
  SettingsRepository(this._prefs);
  
  /// Factory method to create repository with SharedPreferences
  static Future<SettingsRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsRepository(prefs);
  }
  
  // ==================== Birth Date ====================
  
  /// Save user's birth date
  Future<bool> saveBirthDate(DateTime birthDate) async {
    try {
      return await _prefs.setString(
        _keyBirthDate,
        birthDate.toIso8601String(),
      );
    } catch (e) {
      throw SettingsException('Failed to save birth date: $e');
    }
  }
  
  /// Load user's birth date
  DateTime? loadBirthDate() {
    try {
      final dateString = _prefs.getString(_keyBirthDate);
      if (dateString == null) return null;
      return DateTime.parse(dateString);
    } catch (e) {
      throw SettingsException('Failed to load birth date: $e');
    }
  }
  
  /// Get user's birth date (async version for compatibility)
  Future<DateTime?> getUserBirthDate() async {
    return loadBirthDate();
  }
  
  /// Save user's birth date (async version for compatibility)
  Future<bool> saveUserBirthDate(DateTime birthDate) async {
    return saveBirthDate(birthDate);
  }
  
  /// Check if birth date is saved
  bool hasBirthDate() {
    return _prefs.containsKey(_keyBirthDate);
  }
  
  /// Clear saved birth date
  Future<bool> clearBirthDate() async {
    try {
      return await _prefs.remove(_keyBirthDate);
    } catch (e) {
      throw SettingsException('Failed to clear birth date: $e');
    }
  }
  
  // ==================== Theme ====================
  
  /// Save theme mode preference
  Future<bool> saveThemeMode(ThemeMode themeMode) async {
    try {
      return await _prefs.setString(_keyThemeMode, themeMode.name);
    } catch (e) {
      throw SettingsException('Failed to save theme mode: $e');
    }
  }
  
  /// Load theme mode preference
  ThemeMode loadThemeMode() {
    try {
      final themeName = _prefs.getString(_keyThemeMode);
      if (themeName == null) return ThemeMode.system;
      
      return ThemeMode.values.firstWhere(
        (mode) => mode.name == themeName,
        orElse: () => ThemeMode.system,
      );
    } catch (e) {
      throw SettingsException('Failed to load theme mode: $e');
    }
  }
  
  /// Get theme mode (async version for compatibility)
  Future<ThemeMode> getThemeMode() async {
    return loadThemeMode();
  }
  
  // ==================== Notifications ====================
  
  /// Save notification enabled state
  Future<bool> saveNotificationsEnabled(bool enabled) async {
    try {
      return await _prefs.setBool(_keyNotificationsEnabled, enabled);
    } catch (e) {
      throw SettingsException('Failed to save notifications enabled: $e');
    }
  }
  
  /// Load notification enabled state
  bool loadNotificationsEnabled() {
    try {
      return _prefs.getBool(_keyNotificationsEnabled) ?? true;
    } catch (e) {
      throw SettingsException('Failed to load notifications enabled: $e');
    }
  }
  
  /// Save Purnama notification preference
  Future<bool> saveNotifyPurnama(bool enabled) async {
    try {
      return await _prefs.setBool(_keyNotifyPurnama, enabled);
    } catch (e) {
      throw SettingsException('Failed to save Purnama notification: $e');
    }
  }
  
  /// Load Purnama notification preference
  bool loadNotifyPurnama() {
    try {
      return _prefs.getBool(_keyNotifyPurnama) ?? true;
    } catch (e) {
      throw SettingsException('Failed to load Purnama notification: $e');
    }
  }
  
  /// Save Tilem notification preference
  Future<bool> saveNotifyTilem(bool enabled) async {
    try {
      return await _prefs.setBool(_keyNotifyTilem, enabled);
    } catch (e) {
      throw SettingsException('Failed to save Tilem notification: $e');
    }
  }
  
  /// Load Tilem notification preference
  bool loadNotifyTilem() {
    try {
      return _prefs.getBool(_keyNotifyTilem) ?? true;
    } catch (e) {
      throw SettingsException('Failed to load Tilem notification: $e');
    }
  }
  
  /// Save Kajeng Kliwon notification preference
  Future<bool> saveNotifyKajengKliwon(bool enabled) async {
    try {
      return await _prefs.setBool(_keyNotifyKajengKliwon, enabled);
    } catch (e) {
      throw SettingsException('Failed to save Kajeng Kliwon notification: $e');
    }
  }
  
  /// Load Kajeng Kliwon notification preference
  bool loadNotifyKajengKliwon() {
    try {
      return _prefs.getBool(_keyNotifyKajengKliwon) ?? true;
    } catch (e) {
      throw SettingsException('Failed to load Kajeng Kliwon notification: $e');
    }
  }
  
  /// Save Tumpek notification preference
  Future<bool> saveNotifyTumpek(bool enabled) async {
    try {
      return await _prefs.setBool(_keyNotifyTumpek, enabled);
    } catch (e) {
      throw SettingsException('Failed to save Tumpek notification: $e');
    }
  }
  
  /// Load Tumpek notification preference
  bool loadNotifyTumpek() {
    try {
      return _prefs.getBool(_keyNotifyTumpek) ?? true;
    } catch (e) {
      throw SettingsException('Failed to load Tumpek notification: $e');
    }
  }
  
  /// Save major holidays notification preference
  Future<bool> saveNotifyMajorHolidays(bool enabled) async {
    try {
      return await _prefs.setBool(_keyNotifyMajorHolidays, enabled);
    } catch (e) {
      throw SettingsException('Failed to save major holidays notification: $e');
    }
  }
  
  /// Load major holidays notification preference
  bool loadNotifyMajorHolidays() {
    try {
      return _prefs.getBool(_keyNotifyMajorHolidays) ?? true;
    } catch (e) {
      throw SettingsException('Failed to load major holidays notification: $e');
    }
  }
  
  /// Save otonan notification preference
  Future<bool> saveNotifyOtonan(bool enabled) async {
    try {
      return await _prefs.setBool(_keyNotifyOtonan, enabled);
    } catch (e) {
      throw SettingsException('Failed to save otonan notification: $e');
    }
  }
  
  /// Load otonan notification preference
  bool loadNotifyOtonan() {
    try {
      return _prefs.getBool(_keyNotifyOtonan) ?? true;
    } catch (e) {
      throw SettingsException('Failed to load otonan notification: $e');
    }
  }
  
  /// Save advance notification days (0, 1, 3, 7)
  Future<bool> saveAdvanceNotificationDays(int days) async {
    try {
      if (days < 0 || days > 7) {
        throw ArgumentError('Advance notification days must be between 0 and 7');
      }
      return await _prefs.setInt(_keyAdvanceNotificationDays, days);
    } catch (e) {
      throw SettingsException('Failed to save advance notification days: $e');
    }
  }
  
  /// Load advance notification days
  int loadAdvanceNotificationDays() {
    try {
      return _prefs.getInt(_keyAdvanceNotificationDays) ?? 3;
    } catch (e) {
      throw SettingsException('Failed to load advance notification days: $e');
    }
  }
  
  /// Save notification time (hour and minute)
  Future<bool> saveNotificationTime(TimeOfDay time) async {
    try {
      final timeString = '${time.hour}:${time.minute}';
      return await _prefs.setString(_keyNotificationTime, timeString);
    } catch (e) {
      throw SettingsException('Failed to save notification time: $e');
    }
  }
  
  /// Load notification time
  TimeOfDay loadNotificationTime() {
    try {
      final timeString = _prefs.getString(_keyNotificationTime);
      if (timeString == null) return const TimeOfDay(hour: 8, minute: 0);
      
      final parts = timeString.split(':');
      if (parts.length != 2) return const TimeOfDay(hour: 8, minute: 0);
      
      final hour = int.tryParse(parts[0]) ?? 8;
      final minute = int.tryParse(parts[1]) ?? 0;
      
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      throw SettingsException('Failed to load notification time: $e');
    }
  }
  
  // ==================== Bulk Operations ====================
  
  /// Save all notification preferences at once
  Future<void> saveAllNotificationPreferences({
    required bool enabled,
    required bool purnama,
    required bool tilem,
    required bool kajengKliwon,
    required bool tumpek,
    required bool majorHolidays,
    required bool otonan,
    required int advanceDays,
    required TimeOfDay notificationTime,
  }) async {
    try {
      await Future.wait([
        saveNotificationsEnabled(enabled),
        saveNotifyPurnama(purnama),
        saveNotifyTilem(tilem),
        saveNotifyKajengKliwon(kajengKliwon),
        saveNotifyTumpek(tumpek),
        saveNotifyMajorHolidays(majorHolidays),
        saveNotifyOtonan(otonan),
        saveAdvanceNotificationDays(advanceDays),
        saveNotificationTime(notificationTime),
      ]);
    } catch (e) {
      throw SettingsException('Failed to save notification preferences: $e');
    }
  }
  
  /// Load all notification preferences at once
  Map<String, dynamic> loadAllNotificationPreferences() {
    try {
      return {
        'enabled': loadNotificationsEnabled(),
        'purnama': loadNotifyPurnama(),
        'tilem': loadNotifyTilem(),
        'kajengKliwon': loadNotifyKajengKliwon(),
        'tumpek': loadNotifyTumpek(),
        'majorHolidays': loadNotifyMajorHolidays(),
        'otonan': loadNotifyOtonan(),
        'advanceDays': loadAdvanceNotificationDays(),
        'notificationTime': loadNotificationTime(),
      };
    } catch (e) {
      throw SettingsException('Failed to load notification preferences: $e');
    }
  }
  
  // ==================== Reset ====================
  
  /// Clear all settings
  Future<bool> clearAllSettings() async {
    try {
      return await _prefs.clear();
    } catch (e) {
      throw SettingsException('Failed to clear all settings: $e');
    }
  }
  
  /// Reset notification preferences to defaults
  Future<void> resetNotificationPreferences() async {
    try {
      await saveAllNotificationPreferences(
        enabled: true,
        purnama: true,
        tilem: true,
        kajengKliwon: true,
        tumpek: true,
        majorHolidays: true,
        otonan: true,
        advanceDays: 3,
        notificationTime: const TimeOfDay(hour: 8, minute: 0),
      );
    } catch (e) {
      throw SettingsException('Failed to reset notification preferences: $e');
    }
  }
  
  /// Get notification preferences (async version for compatibility)
  Future<NotificationPreferences> getNotificationPreferences() async {
    final prefs = loadAllNotificationPreferences();
    return NotificationPreferences(
      enablePurnama: prefs['purnama'] as bool,
      enableTilem: prefs['tilem'] as bool,
      enableKajengKliwon: prefs['kajengKliwon'] as bool,
      enableTumpek: prefs['tumpek'] as bool,
      enableMajorHolidays: prefs['majorHolidays'] as bool,
      enableOtonan: prefs['otonan'] as bool,
      advanceDays: prefs['advanceDays'] as int,
      notificationTime: prefs['notificationTime'] as TimeOfDay,
    );
  }
  
  /// Save notification preferences (async version for compatibility)
  Future<void> saveNotificationPreferences(NotificationPreferences preferences) async {
    await saveAllNotificationPreferences(
      enabled: true,
      purnama: preferences.enablePurnama,
      tilem: preferences.enableTilem,
      kajengKliwon: preferences.enableKajengKliwon,
      tumpek: preferences.enableTumpek,
      majorHolidays: preferences.enableMajorHolidays,
      otonan: preferences.enableOtonan,
      advanceDays: preferences.advanceDays,
      notificationTime: preferences.notificationTime,
    );
  }
}

/// Exception thrown when settings operations fail
class SettingsException implements Exception {
  final String message;
  
  SettingsException(this.message);
  
  @override
  String toString() => 'SettingsException: $message';
}
