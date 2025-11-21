import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/strings.dart';
import '../../core/constants/colors.dart';
import '../providers/settings_provider.dart';
import '../widgets/bali_pattern.dart';

/// Settings screen for app configuration
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
      ),
      body: BaliPattern(
        opacity: 0.05,
        child: Consumer<SettingsProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              children: [
                // Appearance Section
                _buildSectionHeader(context, AppStrings.appearance),
                _buildDarkModeSwitch(context, provider),
                const Divider(),
                
                // Notifications Section
                _buildSectionHeader(context, AppStrings.notifications),
                _buildNotificationCategories(context, provider),
                _buildAdvanceNotificationSelector(context, provider),
                _buildNotificationTimePicker(context, provider),
                const Divider(),
                
                // About Section
                _buildSectionHeader(context, AppStrings.about),
                _buildAboutItems(context),
                
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Build section header
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Build dark mode switch
  Widget _buildDarkModeSwitch(BuildContext context, SettingsProvider provider) {
    final isDark = provider.themeMode == ThemeMode.dark;
    
    return ListTile(
      leading: Icon(
        isDark ? Icons.dark_mode : Icons.light_mode,
        color: AppColors.primary,
      ),
      title: const Text(AppStrings.darkMode),
      subtitle: Text(
        isDark ? 'Dark theme enabled' : 'Light theme enabled',
      ),
      trailing: Switch(
        value: isDark,
        onChanged: (value) {
          provider.toggleDarkMode(value);
        },
        activeColor: AppColors.primary,
      ),
    );
  }

  /// Build notification categories
  Widget _buildNotificationCategories(BuildContext context, SettingsProvider provider) {
    final prefs = provider.notificationPreferences;
    
    return Column(
      children: [
        _buildNotificationSwitch(
          context,
          provider,
          'Purnama (Full Moon)',
          'Get notified on full moon days',
          Icons.brightness_7,
          'purnama',
          prefs.enablePurnama,
        ),
        _buildNotificationSwitch(
          context,
          provider,
          'Tilem (New Moon)',
          'Get notified on new moon days',
          Icons.brightness_2,
          'tilem',
          prefs.enableTilem,
        ),
        _buildNotificationSwitch(
          context,
          provider,
          'Kajeng Kliwon',
          'Get notified on Kajeng Kliwon days',
          Icons.star,
          'kajengKliwon',
          prefs.enableKajengKliwon,
        ),
        _buildNotificationSwitch(
          context,
          provider,
          'Tumpek Days',
          'Get notified on Tumpek celebrations',
          Icons.event_note,
          'tumpek',
          prefs.enableTumpek,
        ),
        _buildNotificationSwitch(
          context,
          provider,
          'Major Holidays',
          'Get notified on major holy days',
          Icons.celebration,
          'majorHolidays',
          prefs.enableMajorHolidays,
        ),
        _buildNotificationSwitch(
          context,
          provider,
          'Otonan Reminder',
          'Get notified on your otonan',
          Icons.cake,
          'otonan',
          prefs.enableOtonan,
        ),
      ],
    );
  }

  /// Build notification switch
  Widget _buildNotificationSwitch(
    BuildContext context,
    SettingsProvider provider,
    String title,
    String subtitle,
    IconData icon,
    String category,
    bool value,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColors.secondary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: (enabled) async {
          final error = await provider.toggleNotificationCategory(category, enabled);
          if (error != null && context.mounted) {
            // Show error dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Permission Required'),
                  ],
                ),
                content: Text(error),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Open app settings (platform-specific)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enable notifications in system settings'),
                        ),
                      );
                    },
                    child: const Text('Open Settings'),
                  ),
                ],
              ),
            );
          }
        },
        activeColor: AppColors.secondary,
      ),
    );
  }

  /// Build advance notification selector
  Widget _buildAdvanceNotificationSelector(BuildContext context, SettingsProvider provider) {
    final days = provider.notificationPreferences.advanceDays;
    
    return ListTile(
      leading: const Icon(Icons.schedule, color: AppColors.secondary),
      title: const Text(AppStrings.advanceNotification),
      subtitle: Text('Notify $days ${days == 1 ? 'day' : 'days'} before'),
      trailing: DropdownButton<int>(
        value: days,
        items: [0, 1, 3, 7].map((d) {
          return DropdownMenuItem(
            value: d,
            child: Text(d == 0 ? 'Same day' : '$d ${d == 1 ? 'day' : 'days'}'),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            provider.setAdvanceNotificationDays(value);
          }
        },
      ),
    );
  }

  /// Build notification time picker
  Widget _buildNotificationTimePicker(BuildContext context, SettingsProvider provider) {
    final prefs = provider.notificationPreferences;
    final time = prefs.notificationTime;
    
    return ListTile(
      leading: const Icon(Icons.access_time, color: AppColors.secondary),
      title: const Text(AppStrings.notificationTime),
      subtitle: Text('Notifications at ${time.format(context)}'),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () async {
          final picked = await showTimePicker(
            context: context,
            initialTime: time,
          );
          
          if (picked != null) {
            provider.setNotificationTime(picked);
          }
        },
      ),
    );
  }

  /// Build about items
  Widget _buildAboutItems(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.info_outline, color: AppColors.info),
          title: const Text('App Version'),
          subtitle: const Text(AppStrings.appVersion),
        ),
        ListTile(
          leading: const Icon(Icons.description, color: AppColors.info),
          title: const Text('Cultural Acknowledgment'),
          onTap: () {
            _showCulturalAcknowledgment(context);
          },
          trailing: const Icon(Icons.chevron_right),
        ),
        ListTile(
          leading: const Icon(Icons.code, color: AppColors.info),
          title: const Text('Open Source'),
          subtitle: const Text('View on GitHub'),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('GitHub link: github.com/yourusername/bali-calendar'),
              ),
            );
          },
          trailing: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }

  /// Show cultural acknowledgment dialog
  void _showCulturalAcknowledgment(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cultural Acknowledgment'),
        content: const SingleChildScrollView(
          child: Text(AppStrings.culturalAcknowledgment),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
