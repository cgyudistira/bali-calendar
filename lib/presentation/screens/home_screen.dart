import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/strings.dart';
import '../../core/constants/colors.dart';
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
      body: BaliPattern(
        opacity: 0.05,
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(context),
            SliverToBoxAdapter(
              child: Consumer<CalendarProvider>(
                builder: (context, calendarProvider, child) {
                  if (calendarProvider.isLoading && calendarProvider.monthCalendarDates.isEmpty) {
                    return const SizedBox(
                      height: 400,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Calendar Card with Glassmorphism effect
                        _buildCalendarCard(context, calendarProvider),
                        
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
          ],
        ),
      ),
    );
  }

  /// Build Sliver App Bar with modern styling
  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 180.0,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.primaryGradient,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(32),
            ),
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -30,
                left: -30,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
              // Content
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Consumer<CalendarProvider>(
                        builder: (context, provider, _) {
                          final date = provider.selectedCalendarDate?.sakaDate;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                date != null ? 'Saka ${date.year}' : AppStrings.appName,
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                date != null ? 'Sasih ${date.sasih.name}' : 'Balinese Calendar',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.today, color: Colors.white),
          onPressed: () {
            context.read<CalendarProvider>().goToToday();
          },
          tooltip: 'Go to today',
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {
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

  /// Build calendar card with glassmorphism style
  Widget _buildCalendarCard(BuildContext context, CalendarProvider calendarProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: CalendarWidget(
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
      ),
    );
  }

  /// Build legend explaining the colored dots
  Widget _buildLegend(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Legend',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildLegendItem(
            context,
            color: AppColors.holyDayColor,
            label: 'Holy Days (Major & Tumpek)',
          ),
          const SizedBox(height: 12),
          _buildLegendItem(
            context,
            color: AppColors.purnamaColor,
            label: 'Purnama (Full Moon)',
          ),
          const SizedBox(height: 12),
          _buildLegendItem(
            context,
            color: AppColors.tilemColor,
            label: 'Tilem (New Moon)',
          ),
          const SizedBox(height: 12),
          _buildLegendItem(
            context,
            color: AppColors.kajengKliwonColor,
            label: 'Kajeng Kliwon',
          ),
        ],
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
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
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
