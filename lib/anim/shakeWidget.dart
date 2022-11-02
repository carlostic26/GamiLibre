import 'package:flutter/material.dart';

//clase de  animacion de movimiento de formato horizontal en bucle de las flechas y el banner
class ShakeWidgetX extends StatefulWidget {
  const ShakeWidgetX({
    Key? key,
    this.duration = const Duration(milliseconds: 8000),
    this.deltaX = 10,
    this.curve = Curves.bounceOut,
    required this.child,
  }) : super(key: key);

  final Duration duration;
  final double deltaX;
  final Widget child;
  final Curve curve;

  @override
  _ShakeWidgetXState createState() => _ShakeWidgetXState();
}

class _ShakeWidgetXState extends State<ShakeWidgetX>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )
      ..forward()
      ..addListener(() {
        if (controller.isCompleted) {
          controller.repeat();
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// convert 0-1 to 0-1-0
  double shake(double value) =>
      2 * (0.5 - (0.5 - widget.curve.transform(value)).abs());

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(widget.deltaX * shake(controller.value), 0),
        child: child,
      ),
      child: widget.child,
    );
  }
}

//Este widget tipo Shake proporcioina un movimiento en loop

class ShakeWidgetY extends StatefulWidget {
  const ShakeWidgetY({
    Key? key,
    this.duration = const Duration(milliseconds: 5000),
    this.deltaY = 18,
    this.curve = Curves.bounceOut,
    required this.child,
  }) : super(key: key);

  final Duration duration;
  final double deltaY;
  final Widget child;
  final Curve curve;

  @override
  _ShakeWidgetYState createState() => _ShakeWidgetYState();
}

class _ShakeWidgetYState extends State<ShakeWidgetY>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )
      ..forward()
      ..addListener(() {
        if (controller.isCompleted) {
          controller.repeat();
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// convert 0-1 to 0-1-0
  double shakeY(double value) =>
      2 * (0.5 - (0.5 - widget.curve.transform(value)).abs());

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, widget.deltaY * shakeY(controller.value)),
        child: child,
      ),
      child: widget.child,
    );
  }
}
