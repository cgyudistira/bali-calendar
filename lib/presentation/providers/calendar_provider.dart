import 'package:flutter/foundation.dart';
import '../../data/models/bali_calendar_date.dart';
import '../../domain/services/bali_calendar_service.dart';

/// Provider for managing calendar state
class CalendarProvider extends ChangeNotifier {
  final BaliCalendarService _calendarService;
  
  DateTime _selectedDate;
  DateTime _currentMonth;
  List<BaliCalendarDate> _monthCalendarDates = [];
  bool _isLoading = false;

  CalendarProvider(this._calendarService)
      : _selectedDate = DateTime.now(),
        _currentMonth = DateTime.now() {
    _loadMonthData();
  }

  /// Get the currently selected date
  DateTime get selectedDate => _selectedDate;

  /// Get the current month being displayed
  DateTime get currentMonth => _currentMonth;

  /// Get calendar dates for the current month
  List<BaliCalendarDate> get monthCalendarDates => _monthCalendarDates;

  /// Check if data is loading
  bool get isLoading => _isLoading;

  /// Get calendar date for the selected date
  BaliCalendarDate get selectedCalendarDate {
    return _calendarService.getCalendarForDate(_selectedDate);
  }

  /// Set the selected date
  void setSelectedDate(DateTime date) {
    _selectedDate = DateTime(date.year, date.month, date.day);
    notifyListeners();
  }

  /// Set the current month and load data
  void setCurrentMonth(DateTime month) {
    _currentMonth = DateTime(month.year, month.month, 1);
    _loadMonthData();
  }

  /// Navigate to previous month
  void previousMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    _loadMonthData();
  }

  /// Navigate to next month
  void nextMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    _loadMonthData();
  }

  /// Navigate to today
  void goToToday() {
    final today = DateTime.now();
    _selectedDate = today;
    _currentMonth = DateTime(today.year, today.month, 1);
    _loadMonthData();
  }

  /// Load calendar data for the current month
  void _loadMonthData() {
    _isLoading = true;
    notifyListeners();

    try {
      _monthCalendarDates = _calendarService.getCalendarForMonth(
        _currentMonth.year,
        _currentMonth.month,
      );
    } catch (e) {
      debugPrint('Error loading month data: $e');
      _monthCalendarDates = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh calendar data
  void refresh() {
    _calendarService.clearCache();
    _loadMonthData();
  }

  /// Get calendar date for a specific date
  BaliCalendarDate? getCalendarDate(DateTime date) {
    try {
      return _monthCalendarDates.firstWhere(
        (cd) =>
            cd.gregorianDate.year == date.year &&
            cd.gregorianDate.month == date.month &&
            cd.gregorianDate.day == date.day,
      );
    } catch (e) {
      // If not in current month data, fetch directly
      return _calendarService.getCalendarForDate(date);
    }
  }
}
