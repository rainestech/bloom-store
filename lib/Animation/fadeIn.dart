import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

enum AniPropsX { opacity, translateX }
enum AniPropsY { opacity, translateY }

class FadeIn extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeIn(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<AniPropsX>()
      ..add(AniPropsX.opacity, 0.0.tweenTo(1.0), 500.milliseconds)
      ..add(AniPropsX.translateX, (130.0).tweenTo(0.0), 500.milliseconds,
          Curves.easeOut);

    return PlayAnimation<MultiTweenValues<AniPropsX>>(
      delay: Duration(milliseconds: (300 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, value) => Opacity(
        opacity: value.get(AniPropsX.opacity),
        child: Transform.translate(
            offset: Offset(0, value.get(AniPropsX.translateX)), child: child),
      ),
    );
  }
}

class SlideDown extends StatelessWidget {
  final double delay;
  final Widget child;

  SlideDown(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<AniPropsY>()
      ..add(AniPropsY.opacity, 0.0.tweenTo(1.0), 500.milliseconds)
      ..add(AniPropsY.translateY, (130.0).tweenTo(0.0), 500.milliseconds,
          Curves.easeOut);


    return PlayAnimation<MultiTweenValues<AniPropsY>>(
      delay: Duration(milliseconds: (300 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, value) => Opacity(
        opacity: value.get(AniPropsY.opacity),
        child: Transform.translate(
            offset: Offset(0, value.get(AniPropsY.translateY)), child: child),
      ),
    );
  }
}