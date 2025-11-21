import 'package:flutter/material.dart';
import '../../data/models/bali_calendar_date.dart';
import '../../core/constants/colors.dart';
import 'date_indicator.dart';

/// Calendar widget displaying monthly grid with Balinese calendar integration
class CalendarWidget extends StatefulWidget {
  /// Callback when a date is tapped
  final Function(DateTime)? onDateTap;
  
  /// Initial month to display
  final DateTime? initialMonth;
  
  /// Calendar dates for the current month
  final List<BaliCalendarDate> calendarDates;
  
  /// Callback when month changes
  final Function(DateTime)? onMonthChanged;
  
  const CalendarWidget({
    super.key,
    this.onDateTap,
    this.initialMonth,
    required this.calendarDates,
    this.onMonthChanged,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late PageController _pageController;
  late DateTime _currentMonth;
  final DateTime _today = DateTime.now();

  @override
  void initState() {
    super.initState();
    _currentMonth = widget.initialMonth ?? DateTime.now();
    _pageController = PageController(initialPage: 1000);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Get the first day of the month
  DateTime _getFirstDayOfMonth(DateTime month) {
    return DateTime(month.year, month.month, 1);
  }

  /// Get the last day of the month
  DateTime _getLastDayOfMonth(DateTime month) {
    return DateTime(month.year, month.month + 1, 0);
  }

  /// Get the number of days in the month
  int _getDaysInMonth(DateTime month) {
    return _getLastDayOfMonth(month).day;
  }

  /// Get the weekday of the first day (0 = Sunday, 6 = Saturday)
  int _getFirstWeekday(DateTime month) {
    return _getFirstDayOfMonth(month).weekday % 7;
  }

  /// Navigate to previous month
  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
    widget.onMonthChanged?.call(_currentMonth);
  }

  /// Navigate to next month
  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
    widget.onMonthChanged?.call(_currentMonth);
  }

  /// Check if a date is today
  bool _isToday(DateTime date) {
    return date.year == _today.year &&
        date.month == _today.month &&
        date.day == _today.day;
  }

  /// Get calendar date for a specific date
  BaliCalendarDate? _getCalendarDate(DateTime date) {
    try {
      return widget.calendarDates.firstWhere(
        (cd) =>
            cd.gregorianDate.year == date.year &&
            cd.gregorianDate.month == date.month &&
            cd.gregorianDate.day == date.day,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Month header with navigation
        _buildMonthHeader(),
        const SizedBox(height: 16),
        
        // Weekday labels
        _buildWeekdayLabels(),
        const SizedBox(height: 8),
        
        // Calendar grid
        _buildCalendarGrid(),
      ],
    );
  }

  /// Build month header with navigation buttons
  Widget _buildMonthHeader() {
    final monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous month button
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _previousMonth,
            tooltip: 'Previous month',
          ),
          
          // Month and year display
          Text(
            '${monthNames[_currentMonth.month - 1]} ${_currentMonth.year}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          
          // Next month button
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _nextMonth,
            tooltip: 'Next month',
          ),
        ],
      ),
    );
  }

  /// Build weekday labels (Sun - Sat)
  Widget _buildWeekdayLabels() {
    const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: weekdays.map((day) {
          return Expanded(
            child: Center(
              child: Text(
                day,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Build calendar grid with dates
  Widget _buildCalendarGrid() {
    final daysInMonth = _getDaysInMonth(_currentMonth);
    final firstWeekday = _getFirstWeekday(_currentMonth);
    final totalCells = ((daysInMonth + firstWeekday) / 7).ceil() * 7;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: totalCells,
        itemBuilder: (context, index) {
          // Calculate the day number
          final dayNumber = index - firstWeekday + 1;
          
          // Empty cell before first day or after last day
          if (dayNumber < 1 || dayNumber > daysInMonth) {
            return const SizedBox.shrink();
          }
          
          final date = DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
          final calendarDate = _getCalendarDate(date);
          final isToday = _isToday(date);
          
          return _buildDateCell(date, calendarDate, isToday);
        },
      ),
    );
  }

  /// Build individual date cell
  Widget _buildDateCell(DateTime date, BaliCalendarDate? calendarDate, bool isToday) {
    return InkWell(
      onTap: () => widget.onDateTap?.call(date),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: isToday
              ? AppColors.primary.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isToday
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Date number
            Text(
              date.day.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                color: isToday
                    ? AppColors.primary
                    : Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            
            // Event indicators
            if (calendarDate != null)
              const SizedBox(height: 2),
            if (calendarDate != null)
              DateIndicator(calendarDate: calendarDate),
          ],
        ),
      ),
    );
  }
}
