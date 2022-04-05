import 'package:flutter/material.dart';

// Animation when user likes a post.
class LikeAnimation extends StatefulWidget {
  const LikeAnimation({
    Key? key,
    required this.child,
    required this.isAnimating,
    this.duration = const Duration(milliseconds: 150),
    this.onEnd,
    this.likeButtonHasBeenClicked = false,
  }) : super(key: key);

  // The widget present at the end of the animation.
  final Widget child;

  // Whether the animation is occurring.
  final bool isAnimating;

  // How long should the animation last.
  final Duration duration;

  // Function to be called at the end of the animation.
  final VoidCallback? onEnd;

  // Whether the like button has already been clicked.
  final bool likeButtonHasBeenClicked;

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  // Controller for the animation, allows us to start and stop the animation
  // (along with other features).
  late AnimationController controller;

  // The animation that controls the scale of the child. If the current value
  // of the scale animation is v, the child will be painted v times its normal
  // size.
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: widget.duration.inMilliseconds ~/ 2,
      ),
    );
    scale = Tween<double>(begin: 1.0, end: 1.2).animate(controller);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  // Called whenever the current widget is replaced by another widget (i.e.
  // when the animation ends).
  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isAnimating != oldWidget.isAnimating) {
      startAnimation();
    }
  }

  startAnimation() async {
    // If the widget is still animating,
    if (widget.isAnimating || widget.likeButtonHasBeenClicked) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(const Duration(milliseconds: 200));

      // If there is a function that needs to be called at the end of animation,
      // we can call it here.
      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
