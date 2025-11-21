import 'package:flutter/material.dart';
import '../../data/models/bali_calendar_date.dart';
import '../../data/models/holy_day.dart';
import '../../core/constants/colors.dart';

/// Widget that displays colored dots for events on a calendar date
/// - Yellow dots for holy days
/// - Red dots for Purnama
/// - Black dots for Tilem
/// - Blue dots for Kajeng Kliwon
class DateIndicator extends StatelessWidget {
  final BaliCalendarDate calendarDate;
  
  const DateIndicator({
    super.key,
    required this.calendarDate,
  });

  /// Get list of indicator colors for this date
  List<Color> _getIndicatorColors() {
    final colors = <Color>[];
    
    // Check for holy days (yellow) - highest priority
    if (calendarDate.hasHolyDays) {
      // Check if there are major holidays or other significant holy days
      final hasMajorOrSignificant = calendarDate.holyDays.any((hd) =>
          hd.category == HolyDayCategory.major ||
          hd.category == HolyDayCategory.tumpek);
      
      if (hasMajorOrSignificant) {
        colors.add(AppColors.holyDayColor); // Yellow/Gold
      }
    }
    
    // Check for Purnama (red)
    if (calendarDate.isPurnama) {
      colors.add(Colors.red);
    }
    
    // Check for Tilem (black)
    if (calendarDate.isTilem) {
      colors.add(Colors.black);
    }
    
    // Check for Kajeng Kliwon (blue)
    if (calendarDate.isKajengKliwon) {
      colors.add(Colors.blue);
    }
    
    return colors;
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getIndicatorColors();
    
    // Don't show anything if no events
    if (colors.isEmpty) {
      return const SizedBox(height: 8);
    }
    
    // Show up to 3 dots
    final displayColors = colors.take(3).toList();
    
    return SizedBox(
      height: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: displayColors.map((color) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Event chip widget for displaying holy day information
class EventChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  
  const EventChip({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper to get color for holy day category
Color getHolyDayColor(HolyDayCategory category) {
  switch (category) {
    case HolyDayCategory.purnama:
    case HolyDayCategory.tilem:
      return AppColors.purnamaColor;
    case HolyDayCategory.kajengKliwon:
      return AppColors.kajengKliwonColor;
    case HolyDayCategory.major:
    case HolyDayCategory.tumpek:
      return AppColors.holyDayColor;
    case HolyDayCategory.other:
      return AppColors.secondary;
  }
}

/// Helper to get icon for holy day category
IconData getHolyDayIcon(HolyDayCategory category) {
  switch (category) {
    case HolyDayCategory.purnama:
      return Icons.brightness_7; // Full moon
    case HolyDayCategory.tilem:
      return Icons.brightness_2; // New moon
    case HolyDayCategory.kajengKliwon:
      return Icons.star;
    case HolyDayCategory.major:
      return Icons.celebration;
    case HolyDayCategory.tumpek:
      return Icons.event_note;
    case HolyDayCategory.other:
      return Icons.event;
  }
}
