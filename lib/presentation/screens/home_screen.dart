import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/strings.dart';
import '../providers/calendar_provider.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/bali_pattern.dart';
import '../widgets/detail_day_sheet.dart';

/// Home screen displaying the Balinese calendar
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BaliPattern(
        opacity: 0.1,
        child: Consumer<CalendarProvider>(
          builder: (context, calendarProvider, child) {
            if (calendarProvider.isLoading && calendarProvider.monthCalendarDates.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  
                  // Calendar widget
                  CalendarWidget(
                    calendarDates: calendarProvider.monthCalendarDates,
                    initialMonth: calendarProvider.currentMonth,
                    onDateTap: (date) {
                      calendarProvider.setSelectedDate(date);
                      _showDateDetails(context, date);
                    },
                    onMonthChanged: (month) {
                      calendarProvider.setCurrentMonth(month);
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Legend
                  _buildLegend(context),
                  
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Build app bar with current Saka date
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Consumer<CalendarProvider>(
        builder: (context, calendarProvider, child) {
          final currentCalendar = calendarProvider.selectedCalendarDate;
          final sakaDate = currentCalendar?.sakaDate;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(AppStrings.appName),
              if (sakaDate != null)
                Text(
                  'Saka ${sakaDate.year}, ${sakaDate.sasih}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                ),
            ],
          );
        },
      ),
      actions: [
        // Today button
        IconButton(
          icon: const Icon(Icons.today),
          onPressed: () {
            context.read<CalendarProvider>().goToToday();
          },
          tooltip: 'Go to today',
        ),
        
        // Settings button
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            // TODO: Navigate to settings screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Settings screen coming soon'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          tooltip: AppStrings.settings,
        ),
      ],
    );
  }

  /// Build legend explaining the colored dots
  Widget _buildLegend(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Legend',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              _buildLegendItem(
                context,
                color: const Color(0xFFFFD700), // Yellow/Gold
                label: 'Holy Days (Major & Tumpek)',
              ),
              const SizedBox(height: 8),
              _buildLegendItem(
                context,
                color: Colors.red,
                label: 'Purnama (Full Moon)',
              ),
              const SizedBox(height: 8),
              _buildLegendItem(
                context,
                color: Colors.black,
                label: 'Tilem (New Moon)',
              ),
              const SizedBox(height: 8),
              _buildLegendItem(
                context,
                color: Colors.blue,
                label: 'Kajeng Kliwon',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build individual legend item
  Widget _buildLegendItem(BuildContext context, {
    required Color color,
    required String label,
  }) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  /// Show date details in a bottom sheet
  void _showDateDetails(BuildContext context, DateTime date) {
    final calendarProvider = context.read<CalendarProvider>();
    final calendarDate = calendarProvider.getCalendarDate(date);
    
    if (calendarDate == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DetailDaySheet(calendarDate: calendarDate),
    );
  }
}
