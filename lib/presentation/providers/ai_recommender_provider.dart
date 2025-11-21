import 'package:flutter/foundation.dart';
import '../../domain/services/ai_recommender_service.dart';
import '../../data/models/weton.dart';

/// Provider for managing AI recommender state
class AIRecommenderProvider extends ChangeNotifier {
  final AIRecommenderService _recommenderService;
  
  String _activityType = '';
  Weton? _userWeton;
  int _searchPeriod = 90; // days
  List<DayRecommendation> _recommendations = [];
  bool _isGenerating = false;
  String? _errorMessage;

  AIRecommenderProvider(this._recommenderService);

  /// Get activity type
  String get activityType => _activityType;

  /// Get user weton
  Weton? get userWeton => _userWeton;

  /// Get search period
  int get searchPeriod => _searchPeriod;

  /// Get recommendations
  List<DayRecommendation> get recommendations => _recommendations;

  /// Check if generating
  bool get isGenerating => _isGenerating;

  /// Get error message
  String? get errorMessage => _errorMessage;

  /// Set activity type
  void setActivityType(String type) {
    _activityType = type;
    notifyListeners();
  }

  /// Set user weton
  void setUserWeton(Weton? weton) {
    _userWeton = weton;
    notifyListeners();
  }

  /// Set search period
  void setSearchPeriod(int days) {
    _searchPeriod = days;
    notifyListeners();
  }

  /// Generate recommendations
  /// Returns error message if validation fails, null if successful
  Future<String?> generateRecommendations() async {
    // Validate inputs
    if (_activityType.isEmpty) {
      _errorMessage = 'Please select an activity type';
      notifyListeners();
      return _errorMessage;
    }
    
    if (_searchPeriod < 1 || _searchPeriod > 365) {
      _errorMessage = 'Search period must be between 1 and 365 days';
      notifyListeners();
      return _errorMessage;
    }

    _isGenerating = true;
    _errorMessage = null;
    _recommendations = [];
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate processing
      
      final startDate = DateTime.now().add(const Duration(days: 1)); // Start from tomorrow
      
      // Validate start date is in range
      if (startDate.year < 1900 || startDate.year > 2100) {
        _errorMessage = 'Cannot generate recommendations for dates outside 1900-2100 range';
        _isGenerating = false;
        notifyListeners();
        return _errorMessage;
      }
      
      _recommendations = _recommenderService.recommendDays(
        startDate: startDate,
        daysToSearch: _searchPeriod,
        topN: 3,
        userWeton: _userWeton,
      );

      if (_recommendations.isEmpty) {
        _errorMessage = 'No suitable dates found in the selected period. Try extending the search period.';
      }
      
      return null; // Success
    } catch (e) {
      debugPrint('Error generating recommendations: $e');
      _errorMessage = 'Failed to generate recommendations: ${e.toString()}';
      return _errorMessage;
    } finally {
      _isGenerating = false;
      notifyListeners();
    }
  }

  /// Clear recommendations
  void clearRecommendations() {
    _recommendations = [];
    _errorMessage = null;
    notifyListeners();
  }

  /// Reset all inputs
  void reset() {
    _activityType = '';
    _userWeton = null;
    _searchPeriod = 90;
    _recommendations = [];
    _errorMessage = null;
    notifyListeners();
  }
}
