import '../../data/models/bali_calendar_date.dart';
import '../../data/models/weton.dart';
import '../../data/models/holy_day.dart';
import 'bali_calendar_service.dart';

/// Recommendation result with score and reasoning
class DayRecommendation {
  final DateTime date;
  final BaliCalendarDate calendarDate;
  final int score; // 0-100
  final List<String> positiveFactors;
  final List<String> considerations;
  
  const DayRecommendation({
    required this.date,
    required this.calendarDate,
    required this.score,
    required this.positiveFactors,
    required this.considerations,
  });
}

/// AI-powered day recommender based on Dewasa Ayu principles
class AIRecommenderService {
  final BaliCalendarService _calendarService;
  
  AIRecommenderService(this._calendarService);

  /// Analyze a specific date and return score with reasoning
  DayRecommendation analyzeDate(DateTime date, {Weton? userWeton}) {
    final calendarDate = _calendarService.getCalendarForDate(date);
    final positiveFactors = <String>[];
    final considerations = <String>[];
    int score = 50; // Base score

    // 1. Saka phase scoring (Penanggal is better than Pangelong)
    if (calendarDate.sakaDate.dayInfo.name == 'penanggal') {
      score += 15;
      positiveFactors.add('Penanggal phase (waxing moon) - auspicious for new beginnings');
    } else if (calendarDate.sakaDate.dayInfo.name == 'pangelong') {
      score -= 10;
      considerations.add('Pangelong phase (waning moon) - better for completion than starting');
    }

    // 2. Purnama (Full Moon) - very auspicious
    if (calendarDate.isPurnama) {
      score += 20;
      positiveFactors.add('Purnama (Full Moon) - highly auspicious day');
    }

    // 3. Tilem (New Moon) - less favorable
    if (calendarDate.isTilem) {
      score -= 15;
      considerations.add('Tilem (New Moon) - traditionally avoided for major activities');
    }

    // 4. Kajeng Kliwon - spiritually powerful but requires caution
    if (calendarDate.isKajengKliwon) {
      score += 5;
      positiveFactors.add('Kajeng Kliwon - spiritually powerful day');
      considerations.add('Requires proper offerings and spiritual preparation');
    }

    // 5. Wuku scoring (certain wuku are more auspicious)
    final auspiciousWuku = ['Sinta', 'Landep', 'Wariga', 'Kuningan', 'Pujut'];
    if (auspiciousWuku.contains(calendarDate.pawukonDate.wuku.name)) {
      score += 10;
      positiveFactors.add('Wuku ${calendarDate.pawukonDate.wuku.name} - favorable week');
    }

    // 6. Saptawara (day of week) scoring
    final favorableDays = ['Wraspati', 'Sukra', 'Redite']; // Thursday, Friday, Sunday
    if (favorableDays.contains(calendarDate.pawukonDate.saptaWara.name)) {
      score += 8;
      positiveFactors.add('${calendarDate.pawukonDate.saptaWara.name} - favorable day of week');
    }

    // 7. Pancawara scoring
    final favorablePancawara = ['Umanis', 'Paing', 'Pon'];
    if (favorablePancawara.contains(calendarDate.pawukonDate.pancaWara.name)) {
      score += 5;
      positiveFactors.add('${calendarDate.pawukonDate.pancaWara.name} - favorable market day');
    }

    // 8. Major holy days - avoid for personal activities
    final hasMajorHoliday = calendarDate.holyDays.any((hd) => 
      hd.category == HolyDayCategory.major
    );
    if (hasMajorHoliday) {
      score -= 20;
      considerations.add('Major holy day - reserved for religious ceremonies');
    }

    // 9. Tumpek days - good for specific activities
    final hasTumpek = calendarDate.holyDays.any((hd) => 
      hd.category == HolyDayCategory.tumpek
    );
    if (hasTumpek) {
      score += 10;
      positiveFactors.add('Tumpek day - auspicious for blessings and offerings');
    }

    // 10. User weton compatibility (if provided)
    if (userWeton != null) {
      final compatibility = _calculateWetonCompatibility(
        calendarDate.pawukonDate.dayInCycle,
        userWeton.pawukonDate.dayInCycle,
      );
      score += compatibility;
      if (compatibility > 0) {
        positiveFactors.add('Good compatibility with your weton (+$compatibility)');
      } else if (compatibility < 0) {
        considerations.add('Moderate compatibility with your weton ($compatibility)');
      }
    }

    // 11. Urip/Neptu scoring (higher urip is generally better)
    if (calendarDate.pawukonDate.urip >= 25) {
      score += 8;
      positiveFactors.add('High spiritual energy (urip: ${calendarDate.pawukonDate.urip})');
    } else if (calendarDate.pawukonDate.urip <= 15) {
      score -= 5;
      considerations.add('Lower spiritual energy (urip: ${calendarDate.pawukonDate.urip})');
    }

    // 12. Special combinations
    if (calendarDate.isAnggaraKasih) {
      score += 12;
      positiveFactors.add('Anggara Kasih - auspicious combination');
    }
    if (calendarDate.isBudaCemeng) {
      score += 12;
      positiveFactors.add('Buda Cemeng - auspicious combination');
    }

    // Ensure score is within 0-100 range
    score = score.clamp(0, 100);

    return DayRecommendation(
      date: date,
      calendarDate: calendarDate,
      score: score,
      positiveFactors: positiveFactors,
      considerations: considerations,
    );
  }

  /// Calculate weton compatibility score
  int _calculateWetonCompatibility(int dayInCycle1, int dayInCycle2) {
    final diff = (dayInCycle1 - dayInCycle2).abs();
    
    // Same day or very close
    if (diff == 0) return 15;
    if (diff <= 7) return 10;
    
    // Harmonious intervals (multiples of 35, 70, 105)
    if (diff % 35 == 0) return 12;
    if (diff % 70 == 0) return 10;
    
    // Moderate compatibility
    if (diff <= 30) return 5;
    if (diff <= 60) return 0;
    
    // Less favorable
    return -5;
  }

  /// Recommend top N days within a date range
  List<DayRecommendation> recommendDays({
    required DateTime startDate,
    int daysToSearch = 90,
    int topN = 3,
    Weton? userWeton,
  }) {
    final recommendations = <DayRecommendation>[];
    final endDate = startDate.add(Duration(days: daysToSearch));
    
    // Analyze each day in the range
    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      final recommendation = analyzeDate(currentDate, userWeton: userWeton);
      
      // Only include days with score >= 60 (good or better)
      if (recommendation.score >= 60) {
        recommendations.add(recommendation);
      }
      
      currentDate = currentDate.add(const Duration(days: 1));
    }
    
    // Sort by score (highest first)
    recommendations.sort((a, b) => b.score.compareTo(a.score));
    
    // Return top N recommendations
    return recommendations.take(topN).toList();
  }

  /// Get score interpretation
  String getScoreInterpretation(int score) {
    if (score >= 85) return 'Excellent - Highly Auspicious';
    if (score >= 70) return 'Very Good - Favorable';
    if (score >= 60) return 'Good - Suitable';
    if (score >= 50) return 'Fair - Acceptable';
    if (score >= 40) return 'Moderate - Consider Alternatives';
    return 'Not Recommended';
  }

  /// Get activity-specific recommendations
  String getActivityGuidance(String activityType, int score) {
    if (score < 60) {
      return 'Consider choosing a more auspicious date for this important activity.';
    }
    
    switch (activityType.toLowerCase()) {
      case 'wedding':
      case 'marriage':
        return 'This date shows favorable conditions for wedding ceremonies. '
            'Ensure proper offerings and blessings are prepared.';
      
      case 'business':
      case 'opening':
        return 'Good day for business openings and new ventures. '
            'The spiritual energy supports new beginnings.';
      
      case 'travel':
      case 'journey':
        return 'Favorable conditions for travel and journeys. '
            'Safe travels are indicated by the calendar alignment.';
      
      case 'ceremony':
      case 'ritual':
        return 'Excellent day for religious ceremonies and rituals. '
            'The spiritual alignment is strong.';
      
      case 'construction':
      case 'building':
        return 'Suitable for construction and building projects. '
            'Foundation work is well-supported.';
      
      default:
        return 'This date shows favorable spiritual conditions for your planned activity.';
    }
  }
}
