import 'package:flutter/material.dart';

class TemperatureArcPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final Color progressColor;
  final double sensitivity; // New parameter to control sensitivity

  TemperatureArcPainter({
    required this.progress,
    required this.progressColor,
    this.sensitivity = 2.0, // Default sensitivity factor
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Define the arc angles (in radians)
    // We want the arc to go from bottom left to bottom right
    // -135° to 135° in radians
    const startAngle = -2.35; // -135°
    const sweepAngle = 4.7; // 270°

    // Amplify the progress with sensitivity factor
    // Ensure the result doesn't exceed 1.0
    final adjustedProgress = (progress * sensitivity).clamp(0.0, 1.0);

    // Draw the progress arc
    final progressPaint =
        Paint()
          ..color = progressColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 30
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle * adjustedProgress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant TemperatureArcPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.sensitivity != sensitivity;
  }
}
