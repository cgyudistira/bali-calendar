import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/strings.dart';
import '../../core/constants/colors.dart';
import '../../domain/services/ai_recommender_service.dart';
import '../providers/ai_recommender_provider.dart';
import '../providers/weton_provider.dart';
import '../widgets/bali_pattern.dart';

/// Screen for AI-powered day recommendations
class AIRecommenderScreen extends StatelessWidget {
  const AIRecommenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.aiRecommender),
      ),
      body: BaliPattern(
        opacity: 0.05,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              _buildHeader(context),
              const SizedBox(height: 32),
              
              // Activity type selector
              _buildActivitySelector(context),
              const SizedBox(height: 24),
              
              // User weton section
              _buildWetonSection(context),
              const SizedBox(height: 24),
              
              // Search period selector
              _buildSearchPeriodSelector(context),
              const SizedBox(height: 24),
              
              // Generate button
              _buildGenerateButton(context),
              const SizedBox(height: 32),
              
              // Results section
              Consumer<AIRecommenderProvider>(
                builder: (context, provider, child) {
                  if (provider.isGenerating) {
                    return const Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Analyzing auspicious dates...'),
                        ],
                      ),
                    );
                  }
                  
                  if (provider.errorMessage != null) {
                    return _buildErrorMessage(context, provider.errorMessage!);
                  }
                  
                  if (provider.recommendations.isNotEmpty) {
                    return _buildRecommendations(context, provider);
                  }
                  
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build header
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.auto_awesome,
            size: 48,
            color: AppColors.info,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppStrings.aiRecommender,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Find the most auspicious dates for your important activities',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build activity selector
  Widget _buildActivitySelector(BuildContext context) {
    final activities = [
      'Wedding',
      'Business Opening',
      'Travel',
      'Ceremony',
      'Construction',
      'Other',
    ];

    return Consumer<AIRecommenderProvider>(
      builder: (context, provider, child) {
        final hasError = provider.activityType.isEmpty && provider.errorMessage != null;
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      AppStrings.selectActivity,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '*',
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ],
                ),
                if (hasError) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Please select an activity type',
                    style: TextStyle(
                      color: Colors.red[700],
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: activities.map((activity) {
                    final isSelected = provider.activityType == activity;
                    return ChoiceChip(
                      label: Text(activity),
                      selected: isSelected,
                      onSelected: (selected) {
                        provider.setActivityType(selected ? activity : '');
                      },
                      selectedColor: AppColors.primary.withValues(alpha: 0.3),
                      backgroundColor: Colors.grey[200],
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primary : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build weton section
  Widget _buildWetonSection(BuildContext context) {
    return Consumer2<AIRecommenderProvider, WetonProvider>(
      builder: (context, aiProvider, wetonProvider, child) {
        final hasWeton = wetonProvider.hasSavedWeton;
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Your Weton (Optional)',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Including your weton improves recommendation accuracy',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                if (hasWeton) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Using your saved weton',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  OutlinedButton.icon(
                    onPressed: () {
                      // Navigate to weton checker
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Go to Weton Checker to calculate and save your weton'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Calculate My Weton'),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build search period selector
  Widget _buildSearchPeriodSelector(BuildContext context) {
    return Consumer<AIRecommenderProvider>(
      builder: (context, provider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Search Period',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildPeriodChip(context, provider, 30, '30 Days'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildPeriodChip(context, provider, 60, '60 Days'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildPeriodChip(context, provider, 90, '90 Days'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build period chip
  Widget _buildPeriodChip(
    BuildContext context,
    AIRecommenderProvider provider,
    int days,
    String label,
  ) {
    final isSelected = provider.searchPeriod == days;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) provider.setSearchPeriod(days);
      },
      selectedColor: AppColors.secondary.withValues(alpha: 0.3),
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: isSelected ? AppColors.secondary : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  /// Build generate button
  Widget _buildGenerateButton(BuildContext context) {
    return Consumer<AIRecommenderProvider>(
      builder: (context, provider, child) {
        final canGenerate = provider.activityType.isNotEmpty && !provider.isGenerating;
        
        return ElevatedButton.icon(
          onPressed: canGenerate
              ? () async {
                  final error = await provider.generateRecommendations();
                  if (error != null && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.white),
                            const SizedBox(width: 12),
                            Expanded(child: Text(error)),
                          ],
                        ),
                        backgroundColor: Colors.red[700],
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              : null,
          icon: const Icon(Icons.auto_awesome),
          label: Text(
            AppStrings.generateRecommendations,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }

  /// Build error message
  Widget _buildErrorMessage(BuildContext context, String message) {
    return Card(
      color: AppColors.error.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build recommendations list
  Widget _buildRecommendations(BuildContext context, AIRecommenderProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.recommendedDays,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...provider.recommendations.asMap().entries.map((entry) {
          final index = entry.key;
          final recommendation = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildRecommendationCard(
              context,
              recommendation,
              index + 1,
              provider.activityType,
            ),
          );
        }),
      ],
    );
  }

  /// Build recommendation card
  Widget _buildRecommendationCard(
    BuildContext context,
    DayRecommendation recommendation,
    int rank,
    String activityType,
  ) {
    final service = context.read<AIRecommenderProvider>();
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rank and score
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '#$rank',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                _buildScoreIndicator(context, recommendation.score),
              ],
            ),
            const SizedBox(height: 16),
            
            // Date
            Text(
              _formatDate(recommendation.date),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Balinese calendar info
            Text(
              '${recommendation.calendarDate.sakaDate.sasih}, '
              'Wuku ${recommendation.calendarDate.pawukonDate.wuku.name}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            
            // Score interpretation
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getScoreColor(recommendation.score).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    _getScoreIcon(recommendation.score),
                    color: _getScoreColor(recommendation.score),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      context.read<AIRecommenderProvider>()
                          ._recommenderService.getScoreInterpretation(recommendation.score),
                      style: TextStyle(
                        color: _getScoreColor(recommendation.score),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Why this day section
            Text(
              AppStrings.whyThisDay,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Positive factors
            if (recommendation.positiveFactors.isNotEmpty) ...[
              ...recommendation.positiveFactors.map((factor) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle, size: 16, color: AppColors.success),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          factor,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
            
            // Considerations
            if (recommendation.considerations.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...recommendation.considerations.map((consideration) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, size: 16, color: AppColors.warning),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          consideration,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
            
            // Activity guidance
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
              ),
              child: Text(
                context.read<AIRecommenderProvider>()
                    ._recommenderService.getActivityGuidance(activityType, recommendation.score),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            
            // Add to calendar button
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Add to calendar feature coming soon!'),
                  ),
                );
              },
              icon: const Icon(Icons.calendar_today),
              label: const Text(AppStrings.addToCalendar),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build score indicator
  Widget _buildScoreIndicator(BuildContext context, int score) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _getScoreColor(score),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            '$score',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  /// Get score color
  Color _getScoreColor(int score) {
    if (score >= 85) return AppColors.success;
    if (score >= 70) return AppColors.info;
    if (score >= 60) return AppColors.primary;
    return AppColors.warning;
  }

  /// Get score icon
  IconData _getScoreIcon(int score) {
    if (score >= 85) return Icons.star;
    if (score >= 70) return Icons.thumb_up;
    if (score >= 60) return Icons.check_circle;
    return Icons.info;
  }

  /// Format date
  String _formatDate(DateTime date) {
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
}
