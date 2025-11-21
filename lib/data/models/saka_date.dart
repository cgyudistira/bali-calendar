/// Model for Saka calendar date (Lunar calendar)
class SakaDate {
  final int year;
  final Sasih sasih;
  final int day; // 1-15
  final SasihDayInfo dayInfo; // Penanggal, Pangelong, Purnama, Tilem
  final bool isNgunaratri;

  const SakaDate({
    required this.year,
    required this.sasih,
    required this.day,
    required this.dayInfo,
    required this.isNgunaratri,
  });

  bool get isPenanggal => dayInfo == SasihDayInfo.penanggal || dayInfo == SasihDayInfo.purnama;
  bool get isPangelong => dayInfo == SasihDayInfo.pangelong || dayInfo == SasihDayInfo.tilem;
  bool get isPurnama => dayInfo == SasihDayInfo.purnama;
  bool get isTilem => dayInfo == SasihDayInfo.tilem;

  @override
  String toString() {
    String phase = isPenanggal ? 'Penanggal' : 'Pangelong';
    String special = '';
    if (isPurnama) special = ' (Purnama)';
    if (isTilem) special = ' (Tilem)';
    return 'Saka $year, Sasih ${sasih.name}, $phase $day$special';
  }
}

/// Sasih - Lunar months in Saka calendar
class Sasih {
  final int id; // 0-11 for normal, 12-19 for nampih/mala
  final String name;
  final int refId; // Reference to normal sasih

  const Sasih({required this.id, required this.name, required this.refId});

  Sasih get reference => values[refId];
  bool get isNampih => id >= 12;

  static const List<Sasih> values = [
    // Normal Sasih (0-11)
    Sasih(id: 0, name: 'Kasa', refId: 0),
    Sasih(id: 1, name: 'Karo', refId: 1),
    Sasih(id: 2, name: 'Katiga', refId: 2),
    Sasih(id: 3, name: 'Kapat', refId: 3),
    Sasih(id: 4, name: 'Kalima', refId: 4),
    Sasih(id: 5, name: 'Kanem', refId: 5),
    Sasih(id: 6, name: 'Kapitu', refId: 6),
    Sasih(id: 7, name: 'Kawolu', refId: 7),
    Sasih(id: 8, name: 'Kasanga', refId: 8),
    Sasih(id: 9, name: 'Kadasa', refId: 9),
    Sasih(id: 10, name: 'Destha', refId: 10),
    Sasih(id: 11, name: 'Sadha', refId: 11),
    // Mala/Nampih Sasih (12-19)
    Sasih(id: 12, name: 'Mala Destha', refId: 10),
    Sasih(id: 13, name: 'Mala Sadha', refId: 11),
    Sasih(id: 14, name: 'Nampih Destha', refId: 10),
    Sasih(id: 15, name: 'Nampih Katiga', refId: 2),
    Sasih(id: 16, name: 'Nampih Kasa', refId: 0),
    Sasih(id: 17, name: 'Nampih Kadasa', refId: 9),
    Sasih(id: 18, name: 'Nampih Karo', refId: 1),
    Sasih(id: 19, name: 'Nampih Sadha', refId: 11),
  ];
}

/// Day info in Sasih (lunar phase)
enum SasihDayInfo {
  penanggal,  // Waxing moon (1-14)
  purnama,    // Full moon (day 15 of penanggal)
  pangelong,  // Waning moon (1-14)
  tilem,      // New moon (day 15 of pangelong)
}

extension SasihDayInfoExtension on SasihDayInfo {
  String get displayName {
    switch (this) {
      case SasihDayInfo.penanggal:
        return 'Penanggal';
      case SasihDayInfo.purnama:
        return 'Purnama';
      case SasihDayInfo.pangelong:
        return 'Pangelong';
      case SasihDayInfo.tilem:
        return 'Tilem';
    }
  }
}
