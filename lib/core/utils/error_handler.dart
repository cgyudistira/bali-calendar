import 'package:flutter/material.dart';
import '../../domain/services/holy_day_service.dart';

/// Utility class for handling and displaying errors
class ErrorHandler {
  /// Show error dialog with user-friendly message
  static Future<void> showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title),
            ),
          ],
        ),
        content: Text(message),
        actions: [
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onAction();
              },
              child: Text(actionLabel),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Show holy day load error dialog
  static Future<void> showHolyDayLoadError(
    BuildContext context,
    HolyDayLoadException exception,
  ) async {
    return showErrorDialog(
      context,
      title: 'Data Loading Error',
      message: exception.getUserMessage(),
    );
  }

  /// Show snackbar with error message
  static void showErrorSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[700],
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show warning snackbar
  static void showWarningSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.orange[700],
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Log error for debugging
  static void logError(String context, dynamic error, [StackTrace? stackTrace]) {
    print('ERROR [$context]: $error');
    if (stackTrace != null) {
      print('Stack trace: $stackTrace');
    }
  }
}
