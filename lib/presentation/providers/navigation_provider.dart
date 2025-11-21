import 'package:flutter/foundation.dart';

/// Provider for managing bottom navigation state
class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  /// Get current tab index
  int get currentIndex => _currentIndex;

  /// Set current tab index
  void setCurrentIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  /// Navigate to Home tab
  void goToHome() => setCurrentIndex(0);

  /// Navigate to Holy Days tab
  void goToHolyDays() => setCurrentIndex(1);

  /// Navigate to Weton tab
  void goToWeton() => setCurrentIndex(2);

  /// Navigate to AI Recommender tab
  void goToAIRecommender() => setCurrentIndex(3);
}
