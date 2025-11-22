import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import '../../data/models/notification_preferences.dart';
import '../../data/models/holy_day.dart';
import '../../data/repositories/settings_repository.dart';
import 'holy_day_service.dart';
import 'weton_service.dart';

/// Service for managing local notifications
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Service for managing local notifications
class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;
  final SettingsRepository _settingsRepository;
  final HolyDayService _holyDayService;
  final WetonService? _wetonService;
  
  bool _isInitialized = false;
  
  NotificationService({
    required SettingsRepository settingsRepository,
    required HolyDayService holyDayService,
    WetonService? wetonService,
  })  : _settingsRepository = settingsRepository,
        _holyDayService = holyDayService,
        _wetonService = wetonService,
        _notificationsPlugin = FlutterLocalNotificationsPlugin();
  
  /// Initialize notification service
  Future<bool> initialize() async {
    if (_isInitialized) return true;
    
    try {
      // Initialize time zones
      tz.initializeTimeZones();
      
      // Android initialization settings
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      
      // iOS initialization settings
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );
      
      // Combined initialization settings
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );
      
      // Initialize plugin
      final initialized = await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );
      
      if (initialized == true) {
        await _createNotificationChannels();
        _isInitialized = true;
        return true;
      }
      
      return false;
    } catch (e) {
      throw NotificationException('Failed to initialize notifications: $e');
    }
  }
  
  /// Create Android notification channels
  Future<void> _createNotificationChannels() async {
    // Channel for holy days
    const holyDayChannel = AndroidNotificationChannel(
      'holy_days',
      'Holy Days',
      description: 'Notifications for Balinese Hindu holy days',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );
    
    // Channel for otonan
    const otonanChannel = AndroidNotificationChannel(
      'otonan',
      'Otonan Reminders',
      description: 'Reminders for your otonan (Balinese birthday)',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );
    
    // Create channels
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(holyDayChannel);
    
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(otonanChannel);
  }
  
  /// Request notification permissions
  Future<bool> requestPermissions() async {
    try {
      // Android 13+ requires runtime permission
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      
      if (androidPlugin != null) {
        final granted = await androidPlugin.requestNotificationsPermission();
        if (granted != true) return false;
      }
      
      // iOS permissions
      final iosPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      
      if (iosPlugin != null) {
        final granted = await iosPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        if (granted != true) return false;
      }
      
      return true;
    } catch (e) {
      throw NotificationException('Failed to request permissions: $e');
    }
  }
  
  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    try {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      
      if (androidPlugin != null) {
        return await androidPlugin.areNotificationsEnabled() ?? false;
      }
      
      // For iOS, assume enabled if we got here
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    // This will be implemented when we add navigation
    debugPrint('Notification tapped: ${response.payload}');
  }
  
  /// Schedule a single notification
  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required String channelId,
    String? payload,
  }) async {
    if (!_isInitialized) {
      throw NotificationException('Notification service not initialized');
    }
    
    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        _convertToTZDateTime(scheduledDate),
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelId == 'holy_days' ? 'Holy Days' : 'Otonan Reminders',
            channelDescription: channelId == 'holy_days'
                ? 'Notifications for Balinese Hindu holy days'
                : 'Reminders for your otonan',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
    } catch (e) {
      throw NotificationException('Failed to schedule notification: $e');
    }
  }
  
  /// Convert DateTime to TZDateTime
  tz.TZDateTime _convertToTZDateTime(DateTime dateTime) {
    final local = tz.local;
    return tz.TZDateTime.from(dateTime, local);
  }
  
  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    try {
      await _notificationsPlugin.cancel(id);
    } catch (e) {
      throw NotificationException('Failed to cancel notification: $e');
    }
  }
  
  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    try {
      await _notificationsPlugin.cancelAll();
    } catch (e) {
      throw NotificationException('Failed to cancel all notifications: $e');
    }
  }
  
  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _notificationsPlugin.pendingNotificationRequests();
    } catch (e) {
      throw NotificationException('Failed to get pending notifications: $e');
    }
  }
  
  /// Show immediate notification (for testing)
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) {
      throw NotificationException('Notification service not initialized');
    }
    
    try {
      await _notificationsPlugin.show(
        id,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'holy_days',
            'Holy Days',
            channelDescription: 'Notifications for Balinese Hindu holy days',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: payload,
      );
    } catch (e) {
      throw NotificationException('Failed to show notification: $e');
    }
  }
  
  /// Generate unique notification ID from date and category
  int _generateNotificationId(DateTime date, String category) {
    // Use date and category hash to generate unique ID
    final dateStr = '${date.year}${date.month}${date.day}';
    final categoryHash = category.hashCode.abs() % 1000;
    return int.parse('$dateStr$categoryHash') % 2147483647; // Max int32
  }
  
  // ==================== Scheduling Methods ====================
  
  /// Schedule notifications for holy days
  Future<void> scheduleHolyDayNotifications({
    DateTime? startDate,
    DateTime? endDate,
    int daysAhead = 90,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    try {
      // Load preferences
      final prefs = _loadPreferencesFromSettings();
      
      // Get date range
      final start = startDate ?? DateTime.now();
      final end = endDate ?? start.add(Duration(days: daysAhead));
      
      // Get holy days in range
      final holyDays = _holyDayService.getHolyDaysInRange(start, end);
      
      // Schedule notifications for each holy day
      for (final holyDay in holyDays) {
        await _scheduleHolyDayNotification(holyDay, prefs);
      }
    } catch (e) {
      throw NotificationException('Failed to schedule holy day notifications: $e');
    }
  }
  
  /// Schedule notification for a single holy day
  Future<void> _scheduleHolyDayNotification(
    HolyDay holyDay,
    NotificationPreferences prefs,
  ) async {
    // Check if this category is enabled
    if (!_isCategoryEnabled(holyDay.category, prefs)) {
      return;
    }
    
    // Get notification dates for this holy day
    for (final dateStr in holyDay.dates) {
      final holyDate = DateTime.parse(dateStr);
      
      // Skip past dates
      if (holyDate.isBefore(DateTime.now())) continue;
      
      // Schedule on the day
      await _scheduleHolyDayNotificationForDate(
        holyDay,
        holyDate,
        prefs,
        isAdvance: false,
      );
      
      // Schedule advance notification if enabled
      if (prefs.advanceDays > 0 && _shouldSendAdvanceNotification(holyDay)) {
        final advanceDate = holyDate.subtract(Duration(days: prefs.advanceDays));
        if (advanceDate.isAfter(DateTime.now())) {
          await _scheduleHolyDayNotificationForDate(
            holyDay,
            advanceDate,
            prefs,
            isAdvance: true,
            actualDate: holyDate,
          );
        }
      }
    }
  }
  
  /// Schedule notification for specific date
  Future<void> _scheduleHolyDayNotificationForDate(
    HolyDay holyDay,
    DateTime notificationDate,
    NotificationPreferences prefs, {
    bool isAdvance = false,
    DateTime? actualDate,
  }) async {
    // Calculate notification time
    final scheduledTime = DateTime(
      notificationDate.year,
      notificationDate.month,
      notificationDate.day,
      prefs.notificationTime.hour,
      prefs.notificationTime.minute,
    );
    
    // Skip if in the past
    if (scheduledTime.isBefore(DateTime.now())) return;
    
    // Generate notification ID
    final id = _generateNotificationId(
      notificationDate,
      '${holyDay.id}_${isAdvance ? "advance" : "day"}',
    );
    
    // Create notification title and body
    final title = isAdvance
        ? 'Upcoming: ${holyDay.name}'
        : holyDay.name;
    
    final body = isAdvance
        ? 'In ${prefs.advanceDays} days: ${holyDay.description}'
        : holyDay.description;
    
    // Schedule notification
    await _scheduleNotification(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledTime,
      channelId: 'holy_days',
      payload: 'holy_day:${holyDay.id}',
    );
  }
  
  /// Check if category is enabled in preferences
  bool _isCategoryEnabled(HolyDayCategory category, NotificationPreferences prefs) {
    switch (category) {
      case HolyDayCategory.purnama:
        return prefs.enablePurnama;
      case HolyDayCategory.tilem:
        return prefs.enableTilem;
      case HolyDayCategory.kajengKliwon:
        return prefs.enableKajengKliwon;
      case HolyDayCategory.tumpek:
        return prefs.enableTumpek;
      case HolyDayCategory.major:
        return prefs.enableMajorHolidays;
      case HolyDayCategory.other:
        return true; // Always enable "other" category
    }
  }
  
  /// Check if holy day should have advance notification
  bool _shouldSendAdvanceNotification(HolyDay holyDay) {
    // Only major holidays and tumpek get advance notifications
    return holyDay.category == HolyDayCategory.major ||
           holyDay.category == HolyDayCategory.tumpek;
  }
  
  /// Schedule otonan reminder
  Future<void> scheduleOtonanReminder() async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (_wetonService == null) {
      throw NotificationException('WetonService not available');
    }
    
    try {
      // Load preferences
      final prefs = _loadPreferencesFromSettings();
      
      // Check if otonan notifications are enabled
      if (!prefs.enableOtonan) return;
      
      // Get birth date
      final birthDate = _settingsRepository.loadBirthDate();
      if (birthDate == null) return;
      
      // Get next otonan
      final nextOtonan = _wetonService!.getNextOtonan(birthDate, DateTime.now());
      if (nextOtonan == null) return;
      
      // Schedule notification for otonan day
      final scheduledTime = DateTime(
        nextOtonan.year,
        nextOtonan.month,
        nextOtonan.day,
        prefs.notificationTime.hour,
        prefs.notificationTime.minute,
      );
      
      if (scheduledTime.isAfter(DateTime.now())) {
        await _scheduleNotification(
          id: _generateNotificationId(nextOtonan, 'otonan'),
          title: 'Otonan Today! 🎉',
          body: 'Today is your otonan (Balinese birthday). May you be blessed!',
          scheduledDate: scheduledTime,
          channelId: 'otonan',
          payload: 'otonan:${birthDate.toIso8601String()}',
        );
      }
      
      // Schedule advance notification if enabled
      if (prefs.advanceDays > 0) {
        final advanceDate = nextOtonan.subtract(Duration(days: prefs.advanceDays));
        final advanceTime = DateTime(
          advanceDate.year,
          advanceDate.month,
          advanceDate.day,
          prefs.notificationTime.hour,
          prefs.notificationTime.minute,
        );
        
        if (advanceTime.isAfter(DateTime.now())) {
          await _scheduleNotification(
            id: _generateNotificationId(advanceDate, 'otonan_advance'),
            title: 'Otonan Coming Soon',
            body: 'Your otonan is in ${prefs.advanceDays} days!',
            scheduledDate: advanceTime,
            channelId: 'otonan',
            payload: 'otonan_advance:${birthDate.toIso8601String()}',
          );
        }
      }
    } catch (e) {
      throw NotificationException('Failed to schedule otonan reminder: $e');
    }
  }
  
  /// Load preferences from settings repository
  NotificationPreferences _loadPreferencesFromSettings() {
    final prefsMap = _settingsRepository.loadAllNotificationPreferences();
    return NotificationPreferences.fromMap(prefsMap);
  }
  
  /// Schedule all notifications (holy days + otonan)
  Future<void> scheduleAllNotifications() async {
    await scheduleHolyDayNotifications();
    await scheduleOtonanReminder();
  }
  
  // ==================== Preferences Management ====================
  
  /// Update notification preferences and reschedule
  Future<void> updatePreferences(NotificationPreferences preferences) async {
    try {
      // Save preferences to settings
      await _settingsRepository.saveAllNotificationPreferences(
        enabled: true, // Master switch handled separately
        purnama: preferences.enablePurnama,
        tilem: preferences.enableTilem,
        kajengKliwon: preferences.enableKajengKliwon,
        tumpek: preferences.enableTumpek,
        majorHolidays: preferences.enableMajorHolidays,
        otonan: preferences.enableOtonan,
        advanceDays: preferences.advanceDays,
        notificationTime: preferences.notificationTime,
      );
      
      // Cancel all existing notifications
      await cancelAllNotifications();
      
      // Reschedule with new preferences
      if (preferences.hasAnyEnabled) {
        await scheduleAllNotifications();
      }
    } catch (e) {
      throw NotificationException('Failed to update preferences: $e');
    }
  }
  
  /// Enable/disable specific category
  Future<void> toggleCategory(HolyDayCategory category, bool enabled) async {
    try {
      final prefs = _loadPreferencesFromSettings();
      
      NotificationPreferences updatedPrefs;
      switch (category) {
        case HolyDayCategory.purnama:
          updatedPrefs = prefs.copyWith(enablePurnama: enabled);
          break;
        case HolyDayCategory.tilem:
          updatedPrefs = prefs.copyWith(enableTilem: enabled);
          break;
        case HolyDayCategory.kajengKliwon:
          updatedPrefs = prefs.copyWith(enableKajengKliwon: enabled);
          break;
        case HolyDayCategory.tumpek:
          updatedPrefs = prefs.copyWith(enableTumpek: enabled);
          break;
        case HolyDayCategory.major:
          updatedPrefs = prefs.copyWith(enableMajorHolidays: enabled);
          break;
        case HolyDayCategory.other:
          // Other category always enabled
          return;
      }
      
      await updatePreferences(updatedPrefs);
    } catch (e) {
      throw NotificationException('Failed to toggle category: $e');
    }
  }
  
  /// Enable all categories
  Future<void> enableAllCategories() async {
    final prefs = NotificationPreferences.defaults();
    await updatePreferences(prefs);
  }
  
  /// Disable all categories
  Future<void> disableAllCategories() async {
    await cancelAllNotifications();
    
    await _settingsRepository.saveAllNotificationPreferences(
      enabled: false,
      purnama: false,
      tilem: false,
      kajengKliwon: false,
      tumpek: false,
      majorHolidays: false,
      otonan: false,
      advanceDays: 0,
      notificationTime: const TimeOfDay(hour: 8, minute: 0),
    );
  }
  
  /// Get current preferences
  NotificationPreferences getCurrentPreferences() {
    return _loadPreferencesFromSettings();
  }
  
  /// Update advance notification days
  Future<void> updateAdvanceDays(int days) async {
    if (days < 0 || days > 7) {
      throw ArgumentError('Advance days must be between 0 and 7');
    }
    
    final prefs = _loadPreferencesFromSettings();
    await updatePreferences(prefs.copyWith(advanceDays: days));
  }
  
  /// Update notification time
  Future<void> updateNotificationTime(TimeOfDay time) async {
    final prefs = _loadPreferencesFromSettings();
    await updatePreferences(prefs.copyWith(notificationTime: time));
  }
  
  /// Get notification statistics
  Future<Map<String, dynamic>> getNotificationStats() async {
    final pending = await getPendingNotifications();
    final prefs = getCurrentPreferences();
    
    return {
      'totalPending': pending.length,
      'enabledCategories': prefs.enabledCategories.length,
      'advanceDays': prefs.advanceDays,
      'notificationTime': '${prefs.notificationTime.hour}:${prefs.notificationTime.minute}',
      'hasAnyEnabled': prefs.hasAnyEnabled,
      'allEnabled': prefs.allEnabled,
    };
  }
}

/// Exception thrown when notification operations fail
class NotificationException implements Exception {
  final String message;
  
  NotificationException(this.message);
  
  @override
  String toString() => 'NotificationException: $message';
}
