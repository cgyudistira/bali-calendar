import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/strings.dart';
import '../../core/constants/colors.dart';
import '../providers/weton_provider.dart';
import '../widgets/bali_pattern.dart';

/// Screen for checking weton (Balinese birthday) information
class WetonCheckerScreen extends StatelessWidget {
  const WetonCheckerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.wetonChecker),
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
              
              // Date picker section
              _buildDatePickerSection(context),
              const SizedBox(height: 24),
              
              // Calculate button
              _buildCalculateButton(context),
              const SizedBox(height: 32),
              
              // Results section
              Consumer<WetonProvider>(
                builder: (context, provider, child) {
                  if (provider.isCalculating) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  
                  if (provider.calculatedWeton != null) {
                    return Column(
                      children: [
                        _buildWetonResults(context, provider),
                        const SizedBox(height: 24),
                        _buildOtonanCountdown(context, provider),
                        const SizedBox(height: 24),
                        _buildActionButtons(context, provider),
                      ],
                    );
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

  /// Build header with icon and description
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.cake,
            size: 48,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppStrings.wetonChecker,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Discover your Balinese birthday and otonan cycle',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build date picker section
  Widget _buildDatePickerSection(BuildContext context) {
    return Consumer<WetonProvider>(
      builder: (context, provider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.enterBirthDate,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _selectDate(context, provider),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            provider.selectedBirthDate != null
                                ? _formatDate(provider.selectedBirthDate!)
                                : 'Select your birth date',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: provider.selectedBirthDate != null
                                  ? Colors.black
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build calculate button
  Widget _buildCalculateButton(BuildContext context) {
    return Consumer<WetonProvider>(
      builder: (context, provider, child) {
        final canCalculate = provider.selectedBirthDate != null && !provider.isCalculating;
        
        return ElevatedButton(
          onPressed: canCalculate
              ? () => provider.calculateWeton()
              : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            AppStrings.calculateWeton,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  /// Build weton results card
  Widget _buildWetonResults(BuildContext context, WetonProvider provider) {
    final weton = provider.calculatedWeton!;
    final pawukonDate = weton.pawukonDate;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: AppColors.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  AppStrings.yourWeton,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Wuku
            _buildWetonInfoRow(
              context,
              label: AppStrings.wuku,
              value: pawukonDate.wuku.name,
              icon: Icons.refresh,
            ),
            const Divider(height: 24),
            
            // Saptawara
            _buildWetonInfoRow(
              context,
              label: AppStrings.saptawara,
              value: pawukonDate.saptaWara.name,
              icon: Icons.calendar_view_week,
            ),
            const Divider(height: 24),
            
            // Pancawara
            _buildWetonInfoRow(
              context,
              label: AppStrings.pancawara,
              value: pawukonDate.pancaWara.name,
              icon: Icons.looks_5,
            ),
            const Divider(height: 24),
            
            // Triwara
            _buildWetonInfoRow(
              context,
              label: AppStrings.triwara,
              value: pawukonDate.triWara.name,
              icon: Icons.looks_3,
            ),
            const Divider(height: 24),
            
            // Neptu
            _buildWetonInfoRow(
              context,
              label: AppStrings.neptu,
              value: weton.neptu.toString(),
              icon: Icons.calculate,
            ),
            
            // Characteristics
            if (weton.characteristics != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Characteristics',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      weton.characteristics!.personality,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (weton.characteristics!.strengths.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Strengths:',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ...weton.characteristics!.strengths.map((strength) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            '• $strength',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        );
                      }),
                    ],
                    if (weton.characteristics!.guidance.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Guidance:',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        weton.characteristics!.guidance,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build weton info row
  Widget _buildWetonInfoRow(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.secondary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Build otonan countdown card
  Widget _buildOtonanCountdown(BuildContext context, WetonProvider provider) {
    final nextOtonan = provider.getNextOtonan();
    final daysUntil = provider.getDaysUntilOtonan();
    
    if (nextOtonan == null || daysUntil == null) {
      return const SizedBox.shrink();
    }
    
    return Card(
      color: AppColors.secondary.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.event,
                  color: AppColors.secondary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  AppStrings.nextOtonan,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _formatDate(nextOtonan),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$daysUntil ${AppStrings.daysUntilOtonan}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build action buttons
  Widget _buildActionButtons(BuildContext context, WetonProvider provider) {
    return Column(
      children: [
        // Save weton button
        if (!provider.hasSavedWeton || 
            provider.savedBirthDate != provider.selectedBirthDate)
          ElevatedButton.icon(
            onPressed: () async {
              final success = await provider.saveWeton();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Weton saved successfully!'
                          : 'Failed to save weton',
                    ),
                    backgroundColor: success ? AppColors.success : AppColors.error,
                  ),
                );
              }
            },
            icon: const Icon(Icons.save),
            label: const Text(AppStrings.saveWeton),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        
        // Set reminder button (placeholder)
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Reminder feature coming soon!'),
              ),
            );
          },
          icon: const Icon(Icons.notifications),
          label: const Text(AppStrings.setReminder),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  /// Select date using date picker
  Future<void> _selectDate(BuildContext context, WetonProvider provider) async {
    final initialDate = provider.selectedBirthDate ?? DateTime.now();
    final firstDate = DateTime(1900);
    final lastDate = DateTime.now();
    
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(lastDate) ? lastDate : initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      provider.setSelectedBirthDate(picked);
    }
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
