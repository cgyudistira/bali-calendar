import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/models/notification_preferences.dart';
import '../../domain/services/notification_service.dart';

/// Provider for managing settings state
class SettingsProvider extends ChangeNotifier {
  final SettingsRepository _settingsRepository;
  final NotificationService _notificationService;
  
  ThemeMode _themeMode = ThemeMode.system;
  NotificationPreferences _notificationPreferences = const NotificationPreferences();
  bool _isLoading = false;

  SettingsProvider(this._settingsRepository, this._notificationService) {
    _loadSettings();
  }

  /// Get theme mode
  ThemeMode get themeMode => _themeMode;

  /// Get notification preferences
  NotificationPreferences get notificationPreferences => _notificationPreferences;

  /// Check if loading
  bool get isLoading => _isLoading;

  /// Load settings from repository
  Future<void> _loadSettings() async {
    _isLoading = true;
    notifyListeners();

    try {
      _themeMode = await _settingsRepository.getThemeMode();
      _notificationPreferences = await _settingsRepository.getNotificationPreferences();
    } catch (e) {
      debugPrint('Error loading settings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      await _settingsRepository.saveThemeMode(mode);
      _themeMode = mode;
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }

  /// Toggle dark mode
  Future<void> toggleDarkMode(bool isDark) async {
    final mode = isDark ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(mode);
  }

  /// Update notification preferences
  /// Returns error message if update fails, null if successful
  Future<String?> updateNotificationPreferences(NotificationPreferences preferences) async {
    try {
      // Check if notifications are enabled
      final areEnabled = await _notificationService.areNotificationsEnabled();
      if (!areEnabled) {
        // Request permissions
        final granted = await _notificationService.requestPermissions();
        if (!granted) {
          return 'Notification permissions are required. Please enable them in settings.';
        }
      }
      
      await _settingsRepository.saveNotificationPreferences(preferences);
      await _notificationService.updatePreferences(preferences);
      _notificationPreferences = preferences;
      notifyListeners();
      return null; // Success
    } on NotificationException catch (e) {
      debugPrint('Notification error: $e');
      return e.message;
    } catch (e) {
      debugPrint('Error updating notification preferences: $e');
      return 'Failed to update notification settings';
    }
  }

  /// Toggle notification category
  /// Returns error message if toggle fails, null if successful
  Future<String?> toggleNotificationCategory(String category, bool enabled) async {
    NotificationPreferences updated;
    
    switch (category) {
      case 'purnama':
        updated = _notificationPreferences.copyWith(enablePurnama: enabled);
        break;
      case 'tilem':
        updated = _notificationPreferences.copyWith(enableTilem: enabled);
        break;
      case 'kajengKliwon':
        updated = _notificationPreferences.copyWith(enableKajengKliwon: enabled);
        break;
      case 'tumpek':
        updated = _notificationPreferences.copyWith(enableTumpek: enabled);
        break;
      case 'majorHolidays':
        updated = _notificationPreferences.copyWith(enableMajorHolidays: enabled);
        break;
      case 'otonan':
        updated = _notificationPreferences.copyWith(enableOtonan: enabled);
        break;
      default:
        return 'Invalid category';
    }
    
    return await updateNotificationPreferences(updated);
  }

  /// Set advance notification days
  Future<void> setAdvanceNotificationDays(int days) async {
    final updated = _notificationPreferences.copyWith(advanceDays: days);
    await updateNotificationPreferences(updated);
  }

  /// Set notification time
  Future<void> setNotificationTime(TimeOfDay time) async {
    final updated = _notificationPreferences.copyWith(
      notificationTime: time,
    );
    await updateNotificationPreferences(updated);
  }

  /// Refresh settings
  Future<void> refresh() async {
    await _loadSettings();
  }
}
