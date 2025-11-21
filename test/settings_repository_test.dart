import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../lib/data/repositories/settings_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  late SettingsRepository repository;
  
  setUp(() async {
    // Clear all preferences before each test
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    repository = SettingsRepository(prefs);
  });
  
  group('SettingsRepository - Birth Date', () {
    test('should save and load birth date', () async {
      final birthDate = DateTime(1990, 5, 15);
      
      final saved = await repository.saveBirthDate(birthDate);
      expect(saved, true);
      
      final loaded = repository.loadBirthDate();
      expect(loaded, isNotNull);
      expect(loaded!.year, birthDate.year);
      expect(loaded.month, birthDate.month);
      expect(loaded.day, birthDate.day);
      
      print('Saved and loaded birth date: $loaded');
    });
    
    test('should return null when no birth date is saved', () {
      final loaded = repository.loadBirthDate();
      expect(loaded, isNull);
      
      print('No birth date saved: $loaded');
    });
    
    test('should check if birth date exists', () async {
      expect(repository.hasBirthDate(), false);
      
      await repository.saveBirthDate(DateTime(1990, 5, 15));
      expect(repository.hasBirthDate(), true);
      
      print('Has birth date: ${repository.hasBirthDate()}');
    });
    
    test('should clear birth date', () async {
      await repository.saveBirthDate(DateTime(1990, 5, 15));
      expect(repository.hasBirthDate(), true);
      
      final cleared = await repository.clearBirthDate();
      expect(cleared, true);
      expect(repository.hasBirthDate(), false);
      
      print('Birth date cleared');
    });
  });
  
  group('SettingsRepository - Theme', () {
    test('should save and load theme mode', () async {
      final saved = await repository.saveThemeMode(ThemeMode.dark);
      expect(saved, true);
      
      final loaded = repository.loadThemeMode();
      expect(loaded, ThemeMode.dark);
      
      print('Saved and loaded theme mode: $loaded');
    });
    
    test('should return system theme as default', () {
      final loaded = repository.loadThemeMode();
      expect(loaded, ThemeMode.system);
      
      print('Default theme mode: $loaded');
    });
    
    test('should save all theme modes', () async {
      for (final mode in ThemeMode.values) {
        await repository.saveThemeMode(mode);
        final loaded = repository.loadThemeMode();
        expect(loaded, mode);
        print('Theme mode $mode: OK');
      }
    });
  });
  
  group('SettingsRepository - Notifications', () {
    test('should save and load notifications enabled', () async {
      await repository.saveNotificationsEnabled(false);
      expect(repository.loadNotificationsEnabled(), false);
      
      await repository.saveNotificationsEnabled(true);
      expect(repository.loadNotificationsEnabled(), true);
      
      print('Notifications enabled: ${repository.loadNotificationsEnabled()}');
    });
    
    test('should save and load Purnama notification', () async {
      await repository.saveNotifyPurnama(false);
      expect(repository.loadNotifyPurnama(), false);
      
      await repository.saveNotifyPurnama(true);
      expect(repository.loadNotifyPurnama(), true);
      
      print('Notify Purnama: ${repository.loadNotifyPurnama()}');
    });
    
    test('should save and load Tilem notification', () async {
      await repository.saveNotifyTilem(false);
      expect(repository.loadNotifyTilem(), false);
      
      print('Notify Tilem: ${repository.loadNotifyTilem()}');
    });
    
    test('should save and load Kajeng Kliwon notification', () async {
      await repository.saveNotifyKajengKliwon(false);
      expect(repository.loadNotifyKajengKliwon(), false);
      
      print('Notify Kajeng Kliwon: ${repository.loadNotifyKajengKliwon()}');
    });
    
    test('should save and load Tumpek notification', () async {
      await repository.saveNotifyTumpek(false);
      expect(repository.loadNotifyTumpek(), false);
      
      print('Notify Tumpek: ${repository.loadNotifyTumpek()}');
    });
    
    test('should save and load major holidays notification', () async {
      await repository.saveNotifyMajorHolidays(false);
      expect(repository.loadNotifyMajorHolidays(), false);
      
      print('Notify Major Holidays: ${repository.loadNotifyMajorHolidays()}');
    });
    
    test('should save and load otonan notification', () async {
      await repository.saveNotifyOtonan(false);
      expect(repository.loadNotifyOtonan(), false);
      
      print('Notify Otonan: ${repository.loadNotifyOtonan()}');
    });
    
    test('should save and load advance notification days', () async {
      await repository.saveAdvanceNotificationDays(7);
      expect(repository.loadAdvanceNotificationDays(), 7);
      
      await repository.saveAdvanceNotificationDays(0);
      expect(repository.loadAdvanceNotificationDays(), 0);
      
      print('Advance notification days: ${repository.loadAdvanceNotificationDays()}');
    });
    
    test('should reject invalid advance notification days', () async {
      expect(
        () => repository.saveAdvanceNotificationDays(-1),
        throwsA(isA<SettingsException>()),
      );
      
      expect(
        () => repository.saveAdvanceNotificationDays(8),
        throwsA(isA<SettingsException>()),
      );
      
      print('Invalid advance days rejected');
    });
    
    test('should save and load notification time', () async {
      const time = TimeOfDay(hour: 14, minute: 30);
      
      await repository.saveNotificationTime(time);
      final loaded = repository.loadNotificationTime();
      
      expect(loaded.hour, time.hour);
      expect(loaded.minute, time.minute);
      
      print('Notification time: ${loaded.hour}:${loaded.minute}');
    });
    
    test('should return default notification time', () {
      final loaded = repository.loadNotificationTime();
      expect(loaded.hour, 8);
      expect(loaded.minute, 0);
      
      print('Default notification time: ${loaded.hour}:${loaded.minute}');
    });
  });
  
  group('SettingsRepository - Bulk Operations', () {
    test('should save all notification preferences', () async {
      await repository.saveAllNotificationPreferences(
        enabled: false,
        purnama: false,
        tilem: false,
        kajengKliwon: false,
        tumpek: false,
        majorHolidays: false,
        otonan: false,
        advanceDays: 7,
        notificationTime: const TimeOfDay(hour: 20, minute: 0),
      );
      
      expect(repository.loadNotificationsEnabled(), false);
      expect(repository.loadNotifyPurnama(), false);
      expect(repository.loadNotifyTilem(), false);
      expect(repository.loadNotifyKajengKliwon(), false);
      expect(repository.loadNotifyTumpek(), false);
      expect(repository.loadNotifyMajorHolidays(), false);
      expect(repository.loadNotifyOtonan(), false);
      expect(repository.loadAdvanceNotificationDays(), 7);
      
      final time = repository.loadNotificationTime();
      expect(time.hour, 20);
      expect(time.minute, 0);
      
      print('All notification preferences saved');
    });
    
    test('should load all notification preferences', () async {
      await repository.saveAllNotificationPreferences(
        enabled: true,
        purnama: false,
        tilem: true,
        kajengKliwon: false,
        tumpek: true,
        majorHolidays: false,
        otonan: true,
        advanceDays: 1,
        notificationTime: const TimeOfDay(hour: 9, minute: 30),
      );
      
      final prefs = repository.loadAllNotificationPreferences();
      
      expect(prefs['enabled'], true);
      expect(prefs['purnama'], false);
      expect(prefs['tilem'], true);
      expect(prefs['kajengKliwon'], false);
      expect(prefs['tumpek'], true);
      expect(prefs['majorHolidays'], false);
      expect(prefs['otonan'], true);
      expect(prefs['advanceDays'], 1);
      
      final time = prefs['notificationTime'] as TimeOfDay;
      expect(time.hour, 9);
      expect(time.minute, 30);
      
      print('All notification preferences loaded: ${prefs.keys.length} items');
    });
    
    test('should reset notification preferences to defaults', () async {
      // Set custom values
      await repository.saveAllNotificationPreferences(
        enabled: false,
        purnama: false,
        tilem: false,
        kajengKliwon: false,
        tumpek: false,
        majorHolidays: false,
        otonan: false,
        advanceDays: 7,
        notificationTime: const TimeOfDay(hour: 20, minute: 0),
      );
      
      // Reset to defaults
      await repository.resetNotificationPreferences();
      
      expect(repository.loadNotificationsEnabled(), true);
      expect(repository.loadNotifyPurnama(), true);
      expect(repository.loadNotifyTilem(), true);
      expect(repository.loadNotifyKajengKliwon(), true);
      expect(repository.loadNotifyTumpek(), true);
      expect(repository.loadNotifyMajorHolidays(), true);
      expect(repository.loadNotifyOtonan(), true);
      expect(repository.loadAdvanceNotificationDays(), 3);
      
      final time = repository.loadNotificationTime();
      expect(time.hour, 8);
      expect(time.minute, 0);
      
      print('Notification preferences reset to defaults');
    });
  });
  
  group('SettingsRepository - Clear', () {
    test('should clear all settings', () async {
      // Save some data
      await repository.saveBirthDate(DateTime(1990, 5, 15));
      await repository.saveThemeMode(ThemeMode.dark);
      await repository.saveNotificationsEnabled(false);
      
      // Clear all
      final cleared = await repository.clearAllSettings();
      expect(cleared, true);
      
      // Verify all cleared
      expect(repository.hasBirthDate(), false);
      expect(repository.loadThemeMode(), ThemeMode.system);
      expect(repository.loadNotificationsEnabled(), true); // Default
      
      print('All settings cleared');
    });
  });
  
  group('SettingsRepository - Factory', () {
    test('should create repository with factory method', () async {
      final repo = await SettingsRepository.create();
      expect(repo, isNotNull);
      
      // Test basic functionality
      await repo.saveBirthDate(DateTime(1990, 5, 15));
      expect(repo.hasBirthDate(), true);
      
      print('Repository created with factory method');
    });
  });
}
