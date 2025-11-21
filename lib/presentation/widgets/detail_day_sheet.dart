import 'package:flutter/material.dart';
import '../../data/models/bali_calendar_date.dart';
import '../../core/constants/strings.dart';
import '../../core/constants/colors.dart';
import 'date_indicator.dart';

/// Bottom sheet widget displaying detailed information for a selected date
class DetailDaySheet extends StatelessWidget {
  final BaliCalendarDate calendarDate;
  
  const DetailDaySheet({
    super.key,
    required this.calendarDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                
                // Gradient header with date
                _buildGradientHeader(context),
                
                // Content sections
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gregorian section
                      _buildGregorianSection(context),
                      const SizedBox(height: 24),
                      
                      // Saka section
                      _buildSakaSection(context),
                      const SizedBox(height: 24),
                      
                      // Pawukon section
                      _buildPawukonSection(context),
                      const SizedBox(height: 24),
                      
                      // Holy days section
                      _buildHolyDaysSection(context),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build gradient header with sunrise colors
  Widget _buildGradientHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.sunriseGradient,
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatGregorianDate(calendarDate.gregorianDate),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getDateDescription(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  /// Build Gregorian section
  Widget _buildGregorianSection(BuildContext context) {
    return _buildSection(
      context,
      icon: Icons.calendar_today,
      iconColor: AppColors.primary,
      title: AppStrings.gregorianCalendar,
      content: _formatGregorianDate(calendarDate.gregorianDate),
    );
  }

  /// Build Saka section
  Widget _buildSakaSection(BuildContext context) {
    final sakaDate = calendarDate.sakaDate;
    return _buildSection(
      context,
      icon: Icons.calendar_month,
      iconColor: AppColors.secondary,
      title: AppStrings.sakaCalendar,
      content: '${AppStrings.year} ${sakaDate.year}\n'
          '${sakaDate.sasih}\n'
          '${sakaDate.dayInfo.displayName} ${sakaDate.day}',
    );
  }

  /// Build Pawukon section
  Widget _buildPawukonSection(BuildContext context) {
    final pawukonDate = calendarDate.pawukonDate;
    return _buildSection(
      context,
      icon: Icons.refresh,
      iconColor: AppColors.info,
      title: AppStrings.pawukonCalendar,
      content: '${AppStrings.wuku}: ${pawukonDate.wuku.name}\n'
          '${AppStrings.saptawara}: ${pawukonDate.saptaWara.name}\n'
          '${AppStrings.pancawara}: ${pawukonDate.pancaWara.name}\n'
          '${AppStrings.triwara}: ${pawukonDate.triWara.name}',
    );
  }

  /// Build holy days section
  Widget _buildHolyDaysSection(BuildContext context) {
    if (!calendarDate.hasHolyDays) {
      return _buildSection(
        context,
        icon: Icons.celebration_outlined,
        iconColor: Colors.grey,
        title: AppStrings.holyDays,
        content: AppStrings.noHolyDays,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.holyDayColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.celebration,
                size: 20,
                color: AppColors.holyDayColor,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              AppStrings.holyDays,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...calendarDate.holyDays.map((holyDay) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: EventChip(
              label: holyDay.name,
              color: getHolyDayColor(holyDay.category),
              icon: getHolyDayIcon(holyDay.category),
            ),
          );
        }),
      ],
    );
  }

  /// Build a section with icon, title, and content
  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 44),
          child: Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }

  /// Format Gregorian date
  String _formatGregorianDate(DateTime date) {
    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];

    return '$weekday, $month ${date.day}, ${date.year}';
  }

  /// Get description of special days
  String _getDateDescription() {
    final descriptions = <String>[];
    
    if (calendarDate.isPurnama) {
      descriptions.add('Purnama (Full Moon)');
    }
    if (calendarDate.isTilem) {
      descriptions.add('Tilem (New Moon)');
    }
    if (calendarDate.isKajengKliwon) {
      descriptions.add('Kajeng Kliwon');
    }
    if (calendarDate.hasHolyDays) {
      final majorHolyDays = calendarDate.holyDays.where((hd) => 
        hd.category.name == 'major' || hd.category.name == 'tumpek'
      ).length;
      if (majorHolyDays > 0) {
        descriptions.add('$majorHolyDays Holy Day${majorHolyDays > 1 ? 's' : ''}');
      }
    }
    
    if (descriptions.isEmpty) {
      return 'Regular day';
    }
    
    return descriptions.join(' • ');
  }
}
