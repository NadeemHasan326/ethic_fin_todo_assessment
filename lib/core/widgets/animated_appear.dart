import 'dart:async';

import 'package:ethic_fin_todo_assessment/exports.dart';

class AnimatedAppear extends StatefulWidget {
  const AnimatedAppear({
    super.key,
    required this.child,
    this.index = 0,
    this.duration = AppDurations.appear,
    this.slide = true,
    this.scale = false,
  });

  final Widget child;
  final int index;
  final Duration duration;
  final bool slide;
  final bool scale;

  @override
  State<AnimatedAppear> createState() => _AnimatedAppearState();
}

class _AnimatedAppearState extends State<AnimatedAppear>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final Animation<double> _scale;
  Timer? _delay;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: AppMotion.appearSlideBegin,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _scale = Tween<double>(begin: AppMotion.appearScaleBegin, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    final delayMs = (widget.index * AppDurations.appearStaggerStepMs)
        .clamp(0, AppDurations.appearStaggerMaxMs);
    if (delayMs == 0) {
      _controller.forward();
    } else {
      _delay = Timer(Duration(milliseconds: delayMs), () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _delay?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child;
    if (widget.scale) {
      child = ScaleTransition(scale: _scale, child: child);
    }
    if (widget.slide) {
      child = SlideTransition(position: _slide, child: child);
    }
    return FadeTransition(opacity: _fade, child: child);
  }
}
