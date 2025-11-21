import 'package:flutter/foundation.dart';
import '../../data/models/weton.dart';
import '../../domain/services/weton_service.dart';
import '../../data/repositories/settings_repository.dart';

/// Provider for managing weton checker state
class WetonProvider extends ChangeNotifier {
  final WetonService _wetonService;
  final SettingsRepository _settingsRepository;
  
  DateTime? _selectedBirthDate;
  Weton? _calculatedWeton;
  bool _isCalculating = false;
  DateTime? _savedBirthDate;

  WetonProvider(this._wetonService, this._settingsRepository) {
    _loadSavedBirthDate();
  }

  /// Get selected birth date
  DateTime? get selectedBirthDate => _selectedBirthDate;

  /// Get calculated weton
  Weton? get calculatedWeton => _calculatedWeton;

  /// Check if calculating
  bool get isCalculating => _isCalculating;

  /// Get saved birth date
  DateTime? get savedBirthDate => _savedBirthDate;

  /// Check if weton is saved
  bool get hasSavedWeton => _savedBirthDate != null;

  /// Load saved birth date from repository
  Future<void> _loadSavedBirthDate() async {
    try {
      _savedBirthDate = await _settingsRepository.getUserBirthDate();
      if (_savedBirthDate != null) {
        _selectedBirthDate = _savedBirthDate;
        await calculateWeton();
      }
    } catch (e) {
      debugPrint('Error loading saved birth date: $e');
    }
  }

  /// Set selected birth date
  void setSelectedBirthDate(DateTime date) {
    _selectedBirthDate = DateTime(date.year, date.month, date.day);
    notifyListeners();
  }

  /// Calculate weton for selected birth date
  /// Returns error message if calculation fails, null if successful
  Future<String?> calculateWeton() async {
    if (_selectedBirthDate == null) {
      return 'Please select a birth date';
    }

    _isCalculating = true;
    _calculatedWeton = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 300)); // Simulate calculation
      _calculatedWeton = _wetonService.calculateWeton(_selectedBirthDate!);
      
      if (_calculatedWeton == null) {
        return 'Birth date is out of supported range (1900-2100)';
      }
      
      return null; // Success
    } catch (e) {
      debugPrint('Error calculating weton: $e');
      _calculatedWeton = null;
      return 'Failed to calculate weton: ${e.toString()}';
    } finally {
      _isCalculating = false;
      notifyListeners();
    }
  }

  /// Save weton (birth date) to repository
  Future<bool> saveWeton() async {
    if (_selectedBirthDate == null) return false;

    try {
      await _settingsRepository.saveUserBirthDate(_selectedBirthDate!);
      _savedBirthDate = _selectedBirthDate;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error saving weton: $e');
      return false;
    }
  }

  /// Clear weton calculation
  void clearWeton() {
    _selectedBirthDate = null;
    _calculatedWeton = null;
    notifyListeners();
  }

  /// Get next otonan date
  DateTime? getNextOtonan() {
    if (_calculatedWeton == null) return null;
    return _wetonService.getNextOtonan(_calculatedWeton!.birthDate, DateTime.now());
  }

  /// Get days until next otonan
  int? getDaysUntilOtonan() {
    final nextOtonan = getNextOtonan();
    if (nextOtonan == null) return null;
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return nextOtonan.difference(today).inDays;
  }

  /// Get future otonans
  List<DateTime> getFutureOtonans(int count) {
    if (_calculatedWeton == null) return [];
    return _wetonService.getFutureOtonans(_calculatedWeton!.birthDate, count);
  }
}
