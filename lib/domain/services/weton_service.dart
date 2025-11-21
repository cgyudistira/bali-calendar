import '../../data/models/weton.dart';
import '../../data/models/pawukon_date.dart';
import 'pawukon_service.dart';

/// Service for calculating Weton (Balinese birth day)
class WetonService {
  final PawukonService _pawukonService;

  WetonService(this._pawukonService);

  /// Calculate weton from birth date
  /// Returns null if birth date is out of supported range (1900-2100)
  Weton? calculateWeton(DateTime birthDate) {
    final pawukonDate = _pawukonService.gregorianToPawukon(birthDate);
    
    if (pawukonDate == null) {
      return null;
    }

    // Calculate neptu (total urip value)
    final neptu = pawukonDate.urip;

    // Determine classification based on neptu
    final classification = _getClassification(neptu);

    return Weton(
      birthDate: birthDate,
      pawukonDate: pawukonDate,
      neptu: neptu,
      classification: classification,
    );
  }

  /// Get next otonan date (210-day cycle birthday)
  /// Returns null if dates are out of supported range
  DateTime? getNextOtonan(DateTime birthDate, DateTime currentDate) {
    return _pawukonService.getNextOtonan(birthDate, currentDate);
  }

  /// Get list of future otonan dates
  List<DateTime> getFutureOtonans(DateTime birthDate, int count) {
    return _pawukonService.getFutureOtonans(birthDate, count);
  }

  /// Get weton characteristics based on wuku and day combination
  WetonCharacteristics getCharacteristics(Weton weton) {
    // This is a simplified version. In a real app, you would have
    // a comprehensive database of characteristics for each wuku-day combination
    final wukuId = weton.pawukonDate.wuku.id;
    final saptaWaraId = weton.pawukonDate.saptaWara.id;

    return _getCharacteristicsForCombination(wukuId, saptaWaraId, weton.neptu);
  }

  /// Determine classification based on neptu value
  String _getClassification(int neptu) {
    if (neptu >= 30) {
      return 'Sangat Baik';
    } else if (neptu >= 25) {
      return 'Baik';
    } else if (neptu >= 20) {
      return 'Cukup Baik';
    } else if (neptu >= 15) {
      return 'Sedang';
    } else {
      return 'Perlu Perhatian Khusus';
    }
  }

  /// Get characteristics for specific wuku-saptaWara combination
  /// This is a simplified version with general characteristics
  WetonCharacteristics _getCharacteristicsForCombination(
    int wukuId,
    int saptaWaraId,
    int neptu,
  ) {
    // General characteristics based on neptu range
    if (neptu >= 30) {
      return const WetonCharacteristics(
        personality:
            'Pribadi yang kuat, beruntung, dan memiliki daya tarik spiritual tinggi.',
        strengths:
            ['Kepemimpinan alami', 'kemampuan spiritual', 'keberuntungan dalam usaha'],
        guidance:
            'Gunakan kekuatan Anda untuk membantu orang lain dan jaga keseimbangan spiritual.',
        auspiciousDays: [
          'Purnama',
          'Kajeng Kliwon',
          'Hari kelahiran (Otonan)',
        ],
      );
    } else if (neptu >= 25) {
      return const WetonCharacteristics(
        personality:
            'Pribadi yang seimbang, bijaksana, dan memiliki intuisi yang baik.',
        strengths:
            ['Kebijaksanaan', 'kemampuan berkomunikasi', 'keseimbangan emosional'],
        guidance:
            'Kembangkan potensi spiritual dan jaga hubungan baik dengan sesama.',
        auspiciousDays: [
          'Purnama',
          'Hari kelahiran (Otonan)',
        ],
      );
    } else if (neptu >= 20) {
      return const WetonCharacteristics(
        personality:
            'Pribadi yang stabil, pekerja keras, dan memiliki tekad kuat.',
        strengths: ['Ketekunan', 'loyalitas', 'kemampuan beradaptasi'],
        guidance:
            'Fokus pada pengembangan diri dan jaga kesehatan spiritual melalui persembahyangan.',
        auspiciousDays: [
          'Hari kelahiran (Otonan)',
          'Hari suci keluarga',
        ],
      );
    } else if (neptu >= 15) {
      return const WetonCharacteristics(
        personality:
            'Pribadi yang sederhana, jujur, dan memiliki hati yang baik.',
        strengths: ['Kejujuran', 'ketulusan', 'kemampuan berempati'],
        guidance:
            'Perkuat spiritual melalui persembahyangan rutin dan jaga hubungan dengan keluarga.',
        auspiciousDays: [
          'Hari kelahiran (Otonan)',
          'Purnama',
        ],
      );
    } else {
      return const WetonCharacteristics(
        personality:
            'Pribadi yang memerlukan perhatian khusus dalam pengembangan spiritual.',
        strengths: ['Potensi untuk berkembang', 'kemampuan belajar'],
        guidance:
            'Perbanyak persembahyangan, ikuti upacara keagamaan, dan minta bimbingan spiritual dari pemangku atau sulinggih.',
        auspiciousDays: [
          'Hari kelahiran (Otonan)',
          'Purnama',
          'Tilem',
        ],
      );
    }
  }
}
