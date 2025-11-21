import 'pawukon_date.dart';

/// Weton - Balinese birth day calculation
class Weton {
  final DateTime birthDate;
  final PawukonDate pawukonDate;
  final int neptu;
  final String classification;
  final WetonCharacteristics? characteristics;

  const Weton({
    required this.birthDate,
    required this.pawukonDate,
    required this.neptu,
    required this.classification,
    this.characteristics,
  });

  /// Get weton name (combination of Wuku, Saptawara, Pancawara)
  String get wetonName =>
      '${pawukonDate.wuku.name} ${pawukonDate.saptaWara.name} ${pawukonDate.pancaWara.name}';

  @override
  String toString() {
    return 'Weton: $wetonName (Neptu: $neptu, $classification)';
  }
}

/// Weton characteristics based on traditional Balinese beliefs
class WetonCharacteristics {
  final String personality;
  final List<String> strengths;
  final String guidance;
  final List<String> auspiciousDays;

  const WetonCharacteristics({
    required this.personality,
    required this.strengths,
    required this.guidance,
    required this.auspiciousDays,
  });
}
