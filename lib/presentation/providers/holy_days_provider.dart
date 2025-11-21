import 'package:flutter/foundation.dart';
import '../../data/models/holy_day.dart';
import '../../domain/services/holy_day_service.dart';

/// Provider for managing holy days list state
class HolyDaysProvider extends ChangeNotifier {
  final HolyDayService _holyDayService;
  
  List<HolyDay> _allHolyDays = [];
  List<HolyDay> _filteredHolyDays = [];
  Set<HolyDayCategory> _selectedCategories = {};
  String _searchQuery = '';
  bool _isLoading = false;

  HolyDaysProvider(this._holyDayService) {
    _loadHolyDays();
  }

  /// Get all holy days
  List<HolyDay> get allHolyDays => _allHolyDays;

  /// Get filtered holy days
  List<HolyDay> get filteredHolyDays => _filteredHolyDays;

  /// Get selected categories
  Set<HolyDayCategory> get selectedCategories => _selectedCategories;

  /// Get search query
  String get searchQuery => _searchQuery;

  /// Check if loading
  bool get isLoading => _isLoading;

  /// Check if a category is selected
  bool isCategorySelected(HolyDayCategory category) {
    return _selectedCategories.contains(category);
  }

  /// Load holy days from service
  Future<void> _loadHolyDays() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Get upcoming holy days for next 2 years
      final now = DateTime.now();
      final endDate = DateTime(now.year + 2, 12, 31);
      
      _allHolyDays = _holyDayService.getHolyDaysInRange(now, endDate);
      
      // Sort by date
      _allHolyDays.sort((a, b) {
        if (a.dates.isEmpty || b.dates.isEmpty) return 0;
        return a.dates.first.compareTo(b.dates.first);
      });
      
      // Initialize with all categories selected
      _selectedCategories = HolyDayCategory.values.toSet();
      
      _applyFilters();
    } catch (e) {
      debugPrint('Error loading holy days: $e');
      _allHolyDays = [];
      _filteredHolyDays = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggle category filter
  void toggleCategory(HolyDayCategory category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    _applyFilters();
    notifyListeners();
  }

  /// Set search query
  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  /// Clear all filters
  void clearFilters() {
    _selectedCategories = HolyDayCategory.values.toSet();
    _searchQuery = '';
    _applyFilters();
    notifyListeners();
  }

  /// Apply filters to holy days list
  void _applyFilters() {
    _filteredHolyDays = _allHolyDays.where((holyDay) {
      // Filter by category
      if (!_selectedCategories.contains(holyDay.category)) {
        return false;
      }
      
      // Filter by search query
      if (_searchQuery.isNotEmpty) {
        final nameMatch = holyDay.name.toLowerCase().contains(_searchQuery);
        final descMatch = holyDay.description.toLowerCase().contains(_searchQuery);
        return nameMatch || descMatch;
      }
      
      return true;
    }).toList();
  }

  /// Get holy days grouped by category
  Map<HolyDayCategory, List<HolyDay>> getGroupedHolyDays() {
    final grouped = <HolyDayCategory, List<HolyDay>>{};
    
    for (final category in HolyDayCategory.values) {
      final categoryHolyDays = _filteredHolyDays
          .where((hd) => hd.category == category)
          .toList();
      
      if (categoryHolyDays.isNotEmpty) {
        grouped[category] = categoryHolyDays;
      }
    }
    
    return grouped;
  }

  /// Refresh holy days
  Future<void> refresh() async {
    await _loadHolyDays();
  }
}
