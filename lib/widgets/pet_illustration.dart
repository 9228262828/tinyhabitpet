import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class PetIllustration extends StatefulWidget {
  const PetIllustration({
    super.key,
    this.size = 230,
    this.happiness = 70,
  });

  final double size;
  final int happiness;

  @override
  State<PetIllustration> createState() => _PetIllustrationState();
}

class _PetIllustrationState extends State<PetIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1700),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final offset = math.sin(_controller.value * math.pi) * 4;
        return Transform.translate(
          offset: Offset(0, -offset),
          child: child,
        );
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: CustomPaint(
          painter: _FoxPainter(happiness: widget.happiness),
        ),
      ),
    );
  }
}

class _FoxPainter extends CustomPainter {
  const _FoxPainter({required this.happiness});

  final int happiness;

  @override
  void paint(Canvas canvas, Size size) {
    final orange = Paint()..color = AppColors.orange;
    final dark = Paint()..color = const Color(0xFF4C2C1F);
    final cream = Paint()..color = const Color(0xFFFFE1B5);
    final white = Paint()..color = Colors.white;
    final green = Paint()..color = AppColors.green;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * .88),
        width: size.width * .72,
        height: size.height * .12,
      ),
      Paint()..color = Colors.black.withValues(alpha: .10),
    );

    Path ear(bool left) {
      return Path()
        ..moveTo(
          size.width * (left ? .22 : .78),
          size.height * .42,
        )
        ..lineTo(
          size.width * (left ? .25 : .75),
          size.height * .06,
        )
        ..lineTo(
          size.width * (left ? .47 : .53),
          size.height * .34,
        )
        ..close();
    }

    canvas.drawPath(ear(true), dark);
    canvas.drawPath(ear(false), dark);
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * .34,
      orange,
    );

    final muzzle = Path()
      ..moveTo(size.width * .18, size.height * .55)
      ..quadraticBezierTo(
        size.width * .35,
        size.height * .82,
        size.width * .50,
        size.height * .68,
      )
      ..quadraticBezierTo(
        size.width * .65,
        size.height * .82,
        size.width * .82,
        size.height * .55,
      )
      ..quadraticBezierTo(
        size.width * .65,
        size.height * .67,
        size.width * .50,
        size.height * .61,
      )
      ..quadraticBezierTo(
        size.width * .35,
        size.height * .67,
        size.width * .18,
        size.height * .55,
      )
      ..close();

    canvas.drawPath(muzzle, cream);

    for (final x in [.38, .62]) {
      canvas.drawCircle(
        Offset(size.width * x, size.height * .46),
        size.width * .055,
        white,
      );
      canvas.drawCircle(
        Offset(size.width * x, size.height * .47),
        size.width * .03,
        dark,
      );
    }

    canvas.drawCircle(
      Offset(size.width * .50, size.height * .59),
      size.width * .035,
      dark,
    );

    final mouth = Paint()
      ..color = dark.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * .014
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * .50, size.height * .63),
        width: size.width * .18,
        height: size.height * .12,
      ),
      0,
      math.pi,
      false,
      mouth,
    );

    final scarf = Path()
      ..moveTo(size.width * .30, size.height * .73)
      ..lineTo(size.width * .70, size.height * .73)
      ..lineTo(size.width * .50, size.height * .93)
      ..close();

    canvas.drawPath(scarf, green);
  }

  @override
  bool shouldRepaint(covariant _FoxPainter oldDelegate) =>
      oldDelegate.happiness != happiness;
}
