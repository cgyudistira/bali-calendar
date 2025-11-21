import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/strings.dart';
import '../../data/models/holy_day.dart';
import '../providers/holy_days_provider.dart';
import '../widgets/bali_pattern.dart';
import '../widgets/date_indicator.dart';

/// Screen displaying list of holy days with filtering and search
class HolyDaysScreen extends StatelessWidget {
  const HolyDaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.holyDays),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<HolyDaysProvider>().refresh();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BaliPattern(
        opacity: 0.05,
        child: Column(
          children: [
            // Search bar
            _buildSearchBar(context),
            
            // Category filters
            _buildCategoryFilters(context),
            
            // Holy days list
            Expanded(
              child: Consumer<HolyDaysProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (provider.filteredHolyDays.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  return _buildHolyDaysList(context, provider);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build search bar
  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (value) {
          context.read<HolyDaysProvider>().setSearchQuery(value);
        },
        decoration: InputDecoration(
          hintText: AppStrings.searchHolyDays,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Consumer<HolyDaysProvider>(
            builder: (context, provider, child) {
              if (provider.searchQuery.isEmpty) return const SizedBox.shrink();
              
              return IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  context.read<HolyDaysProvider>().setSearchQuery('');
                },
              );
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }

  /// Build category filter chips
  Widget _buildCategoryFilters(BuildContext context) {
    return Consumer<HolyDaysProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: HolyDayCategory.values.map((category) {
              final isSelected = provider.isCategorySelected(category);
              final color = getHolyDayColor(category);
              
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(category.displayName),
                  selected: isSelected,
                  onSelected: (selected) {
                    provider.toggleCategory(category);
                  },
                  backgroundColor: color.withValues(alpha: 0.1),
                  selectedColor: color.withValues(alpha: 0.3),
                  checkmarkColor: color,
                  labelStyle: TextStyle(
                    color: isSelected ? color : Colors.grey[700],
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color: isSelected ? color : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  /// Build holy days list grouped by category
  Widget _buildHolyDaysList(BuildContext context, HolyDaysProvider provider) {
    final groupedHolyDays = provider.getGroupedHolyDays();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groupedHolyDays.length,
      itemBuilder: (context, index) {
        final category = groupedHolyDays.keys.elementAt(index);
        final holyDays = groupedHolyDays[category]!;
        
        return _buildCategorySection(context, category, holyDays);
      },
    );
  }

  /// Build category section with expandable list
  Widget _buildCategorySection(
    BuildContext context,
    HolyDayCategory category,
    List<HolyDay> holyDays,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          leading: Icon(
            getHolyDayIcon(category),
            color: getHolyDayColor(category),
          ),
          title: Text(
            category.displayName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            '${holyDays.length} ${holyDays.length == 1 ? 'day' : 'days'}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          children: holyDays.map((holyDay) {
            return _buildHolyDayCard(context, holyDay);
          }).toList(),
        ),
      ),
    );
  }

  /// Build individual holy day card
  Widget _buildHolyDayCard(BuildContext context, HolyDay holyDay) {
    return InkWell(
      onTap: () => _showHolyDayDetails(context, holyDay),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    holyDay.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: getHolyDayColor(holyDay.category).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    holyDay.category.displayName,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: getHolyDayColor(holyDay.category),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (holyDay.dates.isNotEmpty)
              Text(
                _formatDate(holyDay.dateTimeList.first),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            const SizedBox(height: 8),
            Text(
              holyDay.description,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _showHolyDayDetails(context, holyDay),
                  icon: const Icon(Icons.info_outline, size: 16),
                  label: const Text(AppStrings.viewDetails),
                  style: TextButton.styleFrom(
                    foregroundColor: getHolyDayColor(holyDay.category),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.noResults,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              context.read<HolyDaysProvider>().clearFilters();
            },
            child: const Text('Clear filters'),
          ),
        ],
      ),
    );
  }

  /// Show holy day details in bottom sheet
  void _showHolyDayDetails(BuildContext context, HolyDay holyDay) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildHolyDayDetailsSheet(context, holyDay),
    );
  }

  /// Build holy day details bottom sheet
  Widget _buildHolyDayDetailsSheet(BuildContext context, HolyDay holyDay) {
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
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title with category badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          holyDay.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Icon(
                        getHolyDayIcon(holyDay.category),
                        color: getHolyDayColor(holyDay.category),
                        size: 32,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: getHolyDayColor(holyDay.category).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      holyDay.category.displayName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: getHolyDayColor(holyDay.category),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Dates
                  if (holyDay.dates.isNotEmpty) ...[
                    Text(
                      'Dates',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...holyDay.dateTimeList.take(5).map((date) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '• ${_formatDate(date)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }),
                    if (holyDay.dates.length > 5)
                      Text(
                        '  ... and ${holyDay.dates.length - 5} more',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    const SizedBox(height: 24),
                  ],

                  // Description
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    holyDay.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),

                  // Cultural significance
                  if (holyDay.culturalSignificance.isNotEmpty) ...[
                    Text(
                      'Cultural Significance',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      holyDay.culturalSignificance,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Format date
  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
