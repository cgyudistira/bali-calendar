/// Model for Pawukon calendar date
/// Pawukon is a 210-day cycle calendar system
class PawukonDate {
  final int dayInCycle; // 0-209
  final Wuku wuku;
  final EkaWara ekaWara;
  final DwiWara dwiWara;
  final TriWara triWara;
  final CaturWara caturWara;
  final PancaWara pancaWara;
  final SadWara sadWara;
  final SaptaWara saptaWara;
  final AstaWara astaWara;
  final SangaWara sangaWara;
  final DasaWara dasaWara;
  final int urip; // Total urip/neptu value (extended calculation)

  const PawukonDate({
    required this.dayInCycle,
    required this.wuku,
    required this.ekaWara,
    required this.dwiWara,
    required this.triWara,
    required this.caturWara,
    required this.pancaWara,
    required this.sadWara,
    required this.saptaWara,
    required this.astaWara,
    required this.sangaWara,
    required this.dasaWara,
    required this.urip,
  });

  /// Basic urip calculation (most common in wariga Bali)
  /// Urip = Sapta Wara + Panca Wara
  int get uripBasic => saptaWara.urip + pancaWara.urip;

  /// Extended urip calculation (for detailed weton/otonan)
  /// Urip = Wuku + Sapta Wara + Panca Wara + Tri Wara
  int get uripExtended => urip;

  @override
  String toString() {
    return 'Wuku ${wuku.name}, ${saptaWara.name}, ${pancaWara.name}, ${triWara.name}';
  }
}

/// Wuku - 30 weeks in Pawukon cycle, each 7 days
class Wuku {
  final int id; // 0-29
  final String name;
  final int urip;

  const Wuku({required this.id, required this.name, required this.urip});

  static const List<Wuku> values = [
    Wuku(id: 0, name: 'Sinta', urip: 7),
    Wuku(id: 1, name: 'Landep', urip: 1),
    Wuku(id: 2, name: 'Ukir', urip: 4),
    Wuku(id: 3, name: 'Kulantir', urip: 6),
    Wuku(id: 4, name: 'Tolu', urip: 5),
    Wuku(id: 5, name: 'Gumbreg', urip: 8),
    Wuku(id: 6, name: 'Wariga', urip: 9),
    Wuku(id: 7, name: 'Warigadean', urip: 3),
    Wuku(id: 8, name: 'Julungwangi', urip: 7),
    Wuku(id: 9, name: 'Sungsang', urip: 1),
    Wuku(id: 10, name: 'Dungulan', urip: 4),
    Wuku(id: 11, name: 'Kuningan', urip: 6),
    Wuku(id: 12, name: 'Langkir', urip: 5),
    Wuku(id: 13, name: 'Medangsia', urip: 8),
    Wuku(id: 14, name: 'Pujut', urip: 9),
    Wuku(id: 15, name: 'Pahang', urip: 3),
    Wuku(id: 16, name: 'Krulut', urip: 7),
    Wuku(id: 17, name: 'Merakih', urip: 1),
    Wuku(id: 18, name: 'Tambir', urip: 4),
    Wuku(id: 19, name: 'Medangkungan', urip: 6),
    Wuku(id: 20, name: 'Matal', urip: 5),
    Wuku(id: 21, name: 'Uye', urip: 8),
    Wuku(id: 22, name: 'Menail', urip: 9),
    Wuku(id: 23, name: 'Prangbakat', urip: 3),
    Wuku(id: 24, name: 'Bala', urip: 7),
    Wuku(id: 25, name: 'Ugu', urip: 1),
    Wuku(id: 26, name: 'Wayang', urip: 4),
    Wuku(id: 27, name: 'Klawu', urip: 6),
    Wuku(id: 28, name: 'Dukut', urip: 5),
    Wuku(id: 29, name: 'Watugunung', urip: 8),
  ];
}

/// SaptaWara - 7-day week cycle
class SaptaWara {
  final int id; // 0-6
  final String name;
  final int urip;

  const SaptaWara({required this.id, required this.name, required this.urip});

  static const List<SaptaWara> values = [
    SaptaWara(id: 0, name: 'Redite', urip: 5),    // Sunday
    SaptaWara(id: 1, name: 'Soma', urip: 4),      // Monday
    SaptaWara(id: 2, name: 'Anggara', urip: 3),   // Tuesday
    SaptaWara(id: 3, name: 'Buda', urip: 7),      // Wednesday
    SaptaWara(id: 4, name: 'Wraspati', urip: 8),  // Thursday
    SaptaWara(id: 5, name: 'Sukra', urip: 6),     // Friday
    SaptaWara(id: 6, name: 'Saniscara', urip: 9), // Saturday
  ];
}

/// AstaWara - 8-day cycle
class AstaWara {
  final int id; // 0-7
  final String name;
  final int urip;

  const AstaWara({required this.id, required this.name, required this.urip});

  static const List<AstaWara> values = [
    AstaWara(id: 0, name: 'Sri', urip: 6),
    AstaWara(id: 1, name: 'Indra', urip: 5),
    AstaWara(id: 2, name: 'Guru', urip: 8),
    AstaWara(id: 3, name: 'Yama', urip: 9),
    AstaWara(id: 4, name: 'Ludra', urip: 3),
    AstaWara(id: 5, name: 'Brahma', urip: 7),
    AstaWara(id: 6, name: 'Kala', urip: 1),
    AstaWara(id: 7, name: 'Uma', urip: 4),
  ];
}

/// SangaWara - 9-day cycle
class SangaWara {
  final int id; // 0-8
  final String name;
  final int urip;

  const SangaWara({required this.id, required this.name, required this.urip});

  static const List<SangaWara> values = [
    SangaWara(id: 0, name: 'Dangu', urip: 9),
    SangaWara(id: 1, name: 'Jangur', urip: 8),
    SangaWara(id: 2, name: 'Gigis', urip: 6),
    SangaWara(id: 3, name: 'Nohan', urip: 7),
    SangaWara(id: 4, name: 'Ogan', urip: 4),
    SangaWara(id: 5, name: 'Erangan', urip: 5),
    SangaWara(id: 6, name: 'Urungan', urip: 7),
    SangaWara(id: 7, name: 'Tulus', urip: 3),
    SangaWara(id: 8, name: 'Dadi', urip: 4),
  ];
}

/// DasaWara - 10-day cycle
class DasaWara {
  final int id; // 0-9
  final String name;
  final int urip;

  const DasaWara({required this.id, required this.name, required this.urip});

  static const List<DasaWara> values = [
    DasaWara(id: 0, name: 'Pandita', urip: 5),
    DasaWara(id: 1, name: 'Pati', urip: 7),
    DasaWara(id: 2, name: 'Suka', urip: 10),
    DasaWara(id: 3, name: 'Duka', urip: 4),
    DasaWara(id: 4, name: 'Sri', urip: 6),
    DasaWara(id: 5, name: 'Manuh', urip: 2),
    DasaWara(id: 6, name: 'Manusa', urip: 3),
    DasaWara(id: 7, name: 'Raja', urip: 8),
    DasaWara(id: 8, name: 'Dewa', urip: 9),
    DasaWara(id: 9, name: 'Raksasa', urip: 1),
  ];
}

/// PancaWara - 5-day cycle
class PancaWara {
  final int id; // 0-4
  final String name;
  final int urip;

  const PancaWara({required this.id, required this.name, required this.urip});

  static const List<PancaWara> values = [
    PancaWara(id: 0, name: 'Umanis', urip: 5),
    PancaWara(id: 1, name: 'Paing', urip: 9),
    PancaWara(id: 2, name: 'Pon', urip: 7),
    PancaWara(id: 3, name: 'Wage', urip: 4),
    PancaWara(id: 4, name: 'Kliwon', urip: 8),
  ];
}

/// SadWara - 6-day cycle
class SadWara {
  final int id; // 0-5
  final String name;
  final int urip;

  const SadWara({required this.id, required this.name, required this.urip});

  static const List<SadWara> values = [
    SadWara(id: 0, name: 'Tungleh', urip: 7),
    SadWara(id: 1, name: 'Aryang', urip: 6),
    SadWara(id: 2, name: 'Urukung', urip: 5),
    SadWara(id: 3, name: 'Paniron', urip: 8),
    SadWara(id: 4, name: 'Was', urip: 9),
    SadWara(id: 5, name: 'Maulu', urip: 3),
  ];
}

/// EkaWara - 1-day cycle
class EkaWara {
  final int id; // 0-1
  final String name;
  final int urip;

  const EkaWara({required this.id, required this.name, required this.urip});

  static const List<EkaWara> values = [
    EkaWara(id: 0, name: '', urip: 0),      // Not Luang (empty)
    EkaWara(id: 1, name: 'Luang', urip: 1), // Luang
  ];
}

/// DwiWara - 2-day cycle
class DwiWara {
  final int id; // 0-1
  final String name;
  final int urip;

  const DwiWara({required this.id, required this.name, required this.urip});

  static const List<DwiWara> values = [
    DwiWara(id: 0, name: 'Menga', urip: 5),
    DwiWara(id: 1, name: 'Pepet', urip: 7),
  ];
}

/// TriWara - 3-day cycle
class TriWara {
  final int id; // 0-2
  final String name;
  final int urip;

  const TriWara({required this.id, required this.name, required this.urip});

  static const List<TriWara> values = [
    TriWara(id: 0, name: 'Pasah', urip: 9),
    TriWara(id: 1, name: 'Beteng', urip: 4),
    TriWara(id: 2, name: 'Kajeng', urip: 7),
  ];
}

/// CaturWara - 4-day cycle
class CaturWara {
  final int id; // 0-3
  final String name;
  final int urip;

  const CaturWara({required this.id, required this.name, required this.urip});

  static const List<CaturWara> values = [
    CaturWara(id: 0, name: 'Sri', urip: 4),
    CaturWara(id: 1, name: 'Laba', urip: 5),
    CaturWara(id: 2, name: 'Jaya', urip: 9),
    CaturWara(id: 3, name: 'Menala', urip: 7),
  ];
}
