import 'package:json_annotation/json_annotation.dart';

part 'holy_day.g.dart';

/// Category of holy day
enum HolyDayCategory {
  @JsonValue('purnama')
  purnama,
  
  @JsonValue('tilem')
  tilem,
  
  @JsonValue('kajengKliwon')
  kajengKliwon,
  
  @JsonValue('tumpek')
  tumpek,
  
  @JsonValue('major')
  major,
  
  @JsonValue('other')
  other,
}

/// Extension for HolyDayCategory display names
extension HolyDayCategoryExtension on HolyDayCategory {
  String get displayName {
    switch (this) {
      case HolyDayCategory.purnama:
        return 'Purnama';
      case HolyDayCategory.tilem:
        return 'Tilem';
      case HolyDayCategory.kajengKliwon:
        return 'Kajeng Kliwon';
      case HolyDayCategory.tumpek:
        return 'Tumpek';
      case HolyDayCategory.major:
        return 'Major Holiday';
      case HolyDayCategory.other:
        return 'Other';
    }
  }
}

/// Model representing a Balinese Hindu holy day
@JsonSerializable()
class HolyDay {
  /// Unique identifier for the holy day
  final String id;
  
  /// Name of the holy day
  final String name;
  
  /// Description of the holy day
  final String description;
  
  /// Category of the holy day
  final HolyDayCategory category;
  
  /// List of dates when this holy day occurs (ISO 8601 format)
  final List<String> dates;
  
  /// Cultural significance and meaning
  final String culturalSignificance;
  
  const HolyDay({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.dates,
    required this.culturalSignificance,
  });
  
  /// Create HolyDay from JSON
  factory HolyDay.fromJson(Map<String, dynamic> json) => _$HolyDayFromJson(json);
  
  /// Convert HolyDay to JSON
  Map<String, dynamic> toJson() => _$HolyDayToJson(this);
  
  /// Get DateTime objects from date strings
  List<DateTime> get dateTimeList {
    return dates.map((dateStr) => DateTime.parse(dateStr)).toList();
  }
  
  /// Check if this holy day occurs on a specific date
  bool occursOn(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return dateTimeList.any((holyDate) {
      final holyDateOnly = DateTime(holyDate.year, holyDate.month, holyDate.day);
      return dateOnly.isAtSameMomentAs(holyDateOnly);
    });
  }
  
  /// Get the next occurrence of this holy day after a given date
  DateTime? getNextOccurrence(DateTime afterDate) {
    final dateOnly = DateTime(afterDate.year, afterDate.month, afterDate.day);
    final futureDates = dateTimeList.where((date) {
      final holyDateOnly = DateTime(date.year, date.month, date.day);
      return holyDateOnly.isAfter(dateOnly);
    }).toList();
    
    if (futureDates.isEmpty) return null;
    
    futureDates.sort();
    return futureDates.first;
  }
  
  @override
  String toString() {
    return 'HolyDay(id: $id, name: $name, category: ${category.displayName}, dates: ${dates.length})';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HolyDay && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
}
