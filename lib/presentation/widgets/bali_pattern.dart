import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

/// Widget that displays a subtle Balinese pattern background
/// Can be used across screens for consistent cultural aesthetics
class BaliPattern extends StatelessWidget {
  /// Opacity of the pattern (default: 0.1 for subtle effect)
  final double opacity;
  
  /// Color of the pattern (default: primary color)
  final Color? color;
  
  /// Child widget to display on top of the pattern
  final Widget? child;
  
  const BaliPattern({
    super.key,
    this.opacity = 0.1,
    this.color,
    this.child,
  });
  
  @override
  Widget build(BuildContext context) {
    final patternColor = color ?? AppColors.primary;
    
    return Stack(
      children: [
        // Background pattern
        Positioned.fill(
          child: Opacity(
            opacity: opacity,
            child: CustomPaint(
              painter: _BaliPatternPainter(color: patternColor),
            ),
          ),
        ),
        // Child content
        if (child != null) child!,
      ],
    );
  }
}

/// Custom painter for Balinese-inspired geometric patterns
class _BaliPatternPainter extends CustomPainter {
  final Color color;
  
  _BaliPatternPainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    // Pattern spacing
    const double spacing = 60.0;
    const double patternSize = 40.0;
    
    // Draw repeating pattern across the canvas
    for (double x = 0; x < size.width + spacing; x += spacing) {
      for (double y = 0; y < size.height + spacing; y += spacing) {
        _drawBaliMotif(canvas, paint, Offset(x, y), patternSize);
      }
    }
  }
  
  /// Draw a single Balinese-inspired motif
  void _drawBaliMotif(Canvas canvas, Paint paint, Offset center, double size) {
    final halfSize = size / 2;
    
    // Draw diamond shape (common in Balinese patterns)
    final diamondPath = Path()
      ..moveTo(center.dx, center.dy - halfSize)
      ..lineTo(center.dx + halfSize, center.dy)
      ..lineTo(center.dx, center.dy + halfSize)
      ..lineTo(center.dx - halfSize, center.dy)
      ..close();
    
    canvas.drawPath(diamondPath, paint);
    
    // Draw inner diamond
    final innerSize = size * 0.5;
    final innerHalf = innerSize / 2;
    final innerDiamond = Path()
      ..moveTo(center.dx, center.dy - innerHalf)
      ..lineTo(center.dx + innerHalf, center.dy)
      ..lineTo(center.dx, center.dy + innerHalf)
      ..lineTo(center.dx - innerHalf, center.dy)
      ..close();
    
    canvas.drawPath(innerDiamond, paint);
    
    // Draw decorative dots at cardinal points
    final dotRadius = 2.0;
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    // Top dot
    canvas.drawCircle(
      Offset(center.dx, center.dy - halfSize - 5),
      dotRadius,
      dotPaint,
    );
    
    // Right dot
    canvas.drawCircle(
      Offset(center.dx + halfSize + 5, center.dy),
      dotRadius,
      dotPaint,
    );
    
    // Bottom dot
    canvas.drawCircle(
      Offset(center.dx, center.dy + halfSize + 5),
      dotRadius,
      dotPaint,
    );
    
    // Left dot
    canvas.drawCircle(
      Offset(center.dx - halfSize - 5, center.dy),
      dotRadius,
      dotPaint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Alternative pattern widget with floral motifs
class BaliFloralPattern extends StatelessWidget {
  final double opacity;
  final Color? color;
  final Widget? child;
  
  const BaliFloralPattern({
    super.key,
    this.opacity = 0.1,
    this.color,
    this.child,
  });
  
  @override
  Widget build(BuildContext context) {
    final patternColor = color ?? AppColors.primary;
    
    return Stack(
      children: [
        Positioned.fill(
          child: Opacity(
            opacity: opacity,
            child: CustomPaint(
              painter: _BaliFloralPainter(color: patternColor),
            ),
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
}

/// Custom painter for floral Balinese patterns
class _BaliFloralPainter extends CustomPainter {
  final Color color;
  
  _BaliFloralPainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    const double spacing = 80.0;
    const double flowerSize = 30.0;
    
    // Draw repeating floral pattern
    for (double x = 0; x < size.width + spacing; x += spacing) {
      for (double y = 0; y < size.height + spacing; y += spacing) {
        _drawFlower(canvas, paint, Offset(x, y), flowerSize);
      }
    }
  }
  
  /// Draw a simple flower motif
  void _drawFlower(Canvas canvas, Paint paint, Offset center, double size) {
    final petalRadius = size / 3;
    final centerRadius = size / 6;
    
    // Draw 8 petals around center
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (math.pi / 180);
      final petalCenter = Offset(
        center.dx + (petalRadius * 1.5) * math.cos(angle),
        center.dy + (petalRadius * 1.5) * math.sin(angle),
      );
      
      canvas.drawCircle(petalCenter, petalRadius, paint);
    }
    
    // Draw center circle
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, centerRadius, fillPaint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
