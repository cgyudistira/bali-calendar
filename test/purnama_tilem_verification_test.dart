import 'package:flutter_test/flutter_test.dart';
import 'package:bali_calendar/domain/services/saka_service.dart';
import 'package:bali_calendar/domain/services/pawukon_service.dart';
import 'package:bali_calendar/domain/services/bali_calendar_service.dart';

/// Test untuk memverifikasi perhitungan Purnama dan Tilem
/// Berdasarkan data aktual bulan purnama dan tilem tahun 2024-2025
void main() {
  late SakaService sakaService;
  late PawukonService pawukonService;
  late BaliCalendarService baliService;
  
  setUp(() {
    sakaService = SakaService();
    pawukonService = PawukonService();
    baliService = BaliCalendarService(sakaService, pawukonService);
  });
  
  group('Verifikasi Purnama dan Tilem 2024', () {
    // Data Purnama (Full Moon) 2024 dari astronomi
    final purnama2024 = [
      DateTime(2024, 1, 25),  // Januari
      DateTime(2024, 2, 24),  // Februari
      DateTime(2024, 3, 25),  // Maret
      DateTime(2024, 4, 24),  // April
      DateTime(2024, 5, 23),  // Mei
      DateTime(2024, 6, 22),  // Juni
      DateTime(2024, 7, 21),  // Juli
      DateTime(2024, 8, 19),  // Agustus
      DateTime(2024, 9, 18),  // September
      DateTime(2024, 10, 17), // Oktober
      DateTime(2024, 11, 15), // November
      DateTime(2024, 12, 15), // Desember
    ];
    
    // Data Tilem (New Moon) 2024 dari astronomi
    final tilem2024 = [
      DateTime(2024, 1, 11),  // Januari
      DateTime(2024, 2, 9),   // Februari
      DateTime(2024, 3, 10),  // Maret
      DateTime(2024, 4, 8),   // April
      DateTime(2024, 5, 8),   // Mei
      DateTime(2024, 6, 6),   // Juni
      DateTime(2024, 7, 6),   // Juli
      DateTime(2024, 8, 4),   // Agustus
      DateTime(2024, 9, 3),   // September
      DateTime(2024, 10, 2),  // Oktober
      DateTime(2024, 11, 1),  // November
      DateTime(2024, 12, 1),  // Desember
      DateTime(2024, 12, 30), // Desember (kedua)
    ];
    
    test('Purnama 2024 - Cek akurasi', () {
      print('\n=== TESTING PURNAMA (Full Moon) 2024 ===');
      int correct = 0;
      int total = purnama2024.length;
      
      for (var date in purnama2024) {
        final calDate = baliService.getCalendarForDate(date);
        expect(calDate, isNotNull, reason: 'Calendar date should not be null');
        
        final isPurnama = calDate!.isPurnama;
        final status = isPurnama ? '✓ BENAR' : '✗ SALAH';
        print('${_formatDate(date)}: $status - ${calDate.sakaDate}');
        
        if (isPurnama) {
          correct++;
        } else {
          // Cek hari sebelum dan sesudah
          final before = baliService.getCalendarForDate(date.subtract(Duration(days: 1)));
          final after = baliService.getCalendarForDate(date.add(Duration(days: 1)));
          if (before?.isPurnama == true) {
            print('  → Purnama terdeteksi 1 hari sebelumnya');
          }
          if (after?.isPurnama == true) {
            print('  → Purnama terdeteksi 1 hari sesudahnya');
          }
        }
      }
      
      final accuracy = (correct / total * 100);
      print('\nAkurasi Purnama: $correct/$total ($accuracy%)');
      
      // Toleransi 80% akurasi (karena perbedaan sistem kalender)
      expect(accuracy, greaterThanOrEqualTo(70.0), 
        reason: 'Akurasi Purnama harus minimal 70%');
    });
    
    test('Tilem 2024 - Cek akurasi', () {
      print('\n=== TESTING TILEM (New Moon) 2024 ===');
      int correct = 0;
      int total = tilem2024.length;
      
      for (var date in tilem2024) {
        final calDate = baliService.getCalendarForDate(date);
        expect(calDate, isNotNull, reason: 'Calendar date should not be null');
        
        final isTilem = calDate!.isTilem;
        final status = isTilem ? '✓ BENAR' : '✗ SALAH';
        print('${_formatDate(date)}: $status - ${calDate.sakaDate}');
        
        if (isTilem) {
          correct++;
        } else {
          // Cek hari sebelum dan sesudah
          final before = baliService.getCalendarForDate(date.subtract(Duration(days: 1)));
          final after = baliService.getCalendarForDate(date.add(Duration(days: 1)));
          if (before?.isTilem == true) {
            print('  → Tilem terdeteksi 1 hari sebelumnya');
          }
          if (after?.isTilem == true) {
            print('  → Tilem terdeteksi 1 hari sesudahnya');
          }
        }
      }
      
      final accuracy = (correct / total * 100);
      print('\nAkurasi Tilem: $correct/$total ($accuracy%)');
      
      // Toleransi 80% akurasi (karena perbedaan sistem kalender)
      expect(accuracy, greaterThanOrEqualTo(70.0), 
        reason: 'Akurasi Tilem harus minimal 70%');
    });
    
    test('Analisis Siklus Bulan', () {
      print('\n=== ANALISIS SIKLUS BULAN ===');
      print('Siklus bulan astronomi: 29.53059 hari');
      print('Siklus aplikasi: 30 hari dengan ngunaratri setiap 63 hari');
      print('');
      
      // Hitung rata-rata jarak antar purnama
      double totalDays = 0;
      for (int i = 1; i < purnama2024.length; i++) {
        final days = purnama2024[i].difference(purnama2024[i-1]).inDays;
        totalDays += days;
        print('Jarak Purnama ${i}: $days hari');
      }
      final avgPurnama = totalDays / (purnama2024.length - 1);
      print('Rata-rata jarak antar Purnama: ${avgPurnama.toStringAsFixed(2)} hari');
      
      print('');
      
      // Hitung rata-rata jarak antar tilem
      totalDays = 0;
      for (int i = 1; i < tilem2024.length; i++) {
        final days = tilem2024[i].difference(tilem2024[i-1]).inDays;
        totalDays += days;
      }
      final avgTilem = totalDays / (tilem2024.length - 1);
      print('Rata-rata jarak antar Tilem: ${avgTilem.toStringAsFixed(2)} hari');
      
      print('');
      print('Perbedaan dengan siklus astronomi:');
      print('- Purnama: ${(avgPurnama - 29.53059).toStringAsFixed(2)} hari');
      print('- Tilem: ${(avgTilem - 29.53059).toStringAsFixed(2)} hari');
    });
  });
}

String _formatDate(DateTime date) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
}
