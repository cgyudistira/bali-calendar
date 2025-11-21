import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bali_calendar/core/constants/colors.dart';
import 'package:bali_calendar/core/utils/accessibility.dart';

void main() {
  group('Accessibility - Color Contrast', () {
    test('Primary color on white background meets WCAG AA', () {
      final ratio = AccessibilityUtils.getContrastRatio(
        AppColors.primary,
        Colors.white,
      );
      print('Primary on white contrast ratio: ${ratio.toStringAsFixed(2)}:1');
      expect(ratio, greaterThanOrEqualTo(4.5));
    });

    test('Secondary color on white background meets WCAG AA', () {
      final ratio = AccessibilityUtils.getContrastRatio(
        AppColors.secondary,
        Colors.white,
      );
      print('Secondary on white contrast ratio: ${ratio.toStringAsFixed(2)}:1');
      expect(ratio, greaterThanOrEqualTo(4.5));
    });

    test('Text on primary background meets WCAG AA', () {
      final ratio = AccessibilityUtils.getContrastRatio(
        Colors.white,
        AppColors.primary,
      );
      print('White on primary contrast ratio: ${ratio.toStringAsFixed(2)}:1');
      expect(ratio, greaterThanOrEqualTo(4.5));
    });

    test('Success color on white background meets WCAG AA', () {
      final ratio = AccessibilityUtils.getContrastRatio(
        AppColors.success,
        Colors.white,
      );
      print('Success on white contrast ratio: ${ratio.toStringAsFixed(2)}:1');
      expect(ratio, greaterThanOrEqualTo(4.5));
    });

    test('Error color on white background meets WCAG AA', () {
      final ratio = AccessibilityUtils.getContrastRatio(
        AppColors.error,
        Colors.white,
      );
      print('Error on white contrast ratio: ${ratio.toStringAsFixed(2)}:1');
      expect(ratio, greaterThanOrEqualTo(4.5));
    });

    test('Warning color on white background meets WCAG AA', () {
      final ratio = AccessibilityUtils.getContrastRatio(
        AppColors.warning,
        Colors.white,
      );
      print('Warning on white contrast ratio: ${ratio.toStringAsFixed(2)}:1');
      expect(ratio, greaterThanOrEqualTo(4.5));
    });

    test('Info color on white background meets WCAG AA', () {
      final ratio = AccessibilityUtils.getContrastRatio(
        AppColors.info,
        Colors.white,
      );
      print('Info on white contrast ratio: ${ratio.toStringAsFixed(2)}:1');
      expect(ratio, greaterThanOrEqualTo(4.5));
    });
  });

  group('Accessibility - Touch Targets', () {
    test('Minimum touch target size is 48dp', () {
      expect(AccessibilityUtils.minTouchTargetSize, equals(48.0));
    });

    test('meetsMinTouchTarget returns true for 48x48', () {
      expect(AccessibilityUtils.meetsMinTouchTarget(48, 48), isTrue);
    });

    test('meetsMinTouchTarget returns false for 40x40', () {
      expect(AccessibilityUtils.meetsMinTouchTarget(40, 40), isFalse);
    });

    test('meetsMinTouchTarget returns true for larger sizes', () {
      expect(AccessibilityUtils.meetsMinTouchTarget(60, 60), isTrue);
    });
  });

  group('Accessibility - Semantic Labels', () {
    test('getDateSemanticLabel formats date correctly', () {
      final date = DateTime(2024, 3, 15);
      final label = AccessibilityUtils.getDateSemanticLabel(date);
      expect(label, contains('March 15, 2024'));
      expect(label, contains('Friday'));
    });

    test('getDateSemanticLabel without weekday', () {
      final date = DateTime(2024, 3, 15);
      final label = AccessibilityUtils.getDateSemanticLabel(
        date,
        includeWeekday: false,
      );
      expect(label, equals('March 15, 2024'));
      expect(label, isNot(contains('Friday')));
    });

    test('getHolyDaySemanticLabel formats correctly', () {
      final label = AccessibilityUtils.getHolyDaySemanticLabel('Galungan');
      expect(label, equals('Holy day: Galungan'));
    });

    test('getCalendarDateSemanticLabel with holy days', () {
      final date = DateTime(2024, 3, 15);
      final label = AccessibilityUtils.getCalendarDateSemanticLabel(
        date,
        ['Galungan', 'Purnama'],
      );
      expect(label, contains('March 15, 2024'));
      expect(label, contains('Holy days: Galungan, Purnama'));
    });

    test('getCalendarDateSemanticLabel without holy days', () {
      final date = DateTime(2024, 3, 15);
      final label = AccessibilityUtils.getCalendarDateSemanticLabel(date, []);
      expect(label, contains('March 15, 2024'));
      expect(label, isNot(contains('Holy days')));
    });

    test('getScoreSemanticLabel formats correctly', () {
      final label = AccessibilityUtils.getScoreSemanticLabel(85, 100);
      expect(label, equals('Score: 85 out of 100'));
    });

    test('getSwitchSemanticLabel for enabled state', () {
      final label = AccessibilityUtils.getSwitchSemanticLabel(
        'Dark Mode',
        true,
      );
      expect(label, equals('Dark Mode: enabled'));
    });

    test('getSwitchSemanticLabel for disabled state', () {
      final label = AccessibilityUtils.getSwitchSemanticLabel(
        'Dark Mode',
        false,
      );
      expect(label, equals('Dark Mode: disabled'));
    });
  });
}
