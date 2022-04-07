import 'package:flutter/material.dart';

// Animation when user likes a post.
class LikeAnimation extends StatefulWidget {
  const LikeAnimation({
    Key? key,
    required this.child,
    required this.shouldAnimate,
    this.duration = const Duration(milliseconds: 150),
    this.onEnd,
    this.likeButtonHasBeenClicked = false,
  }) : super(key: key);

  // The widget to be transformed in the animation.
  final Widget child;

  // Whether the animation should be occurring.
  final bool shouldAnimate;

  // How long should the animation last.
  final Duration duration;

  // Function to be called at the end of the animation.
  final VoidCallback? onEnd;

  // Whether the like button has been clicked; we need to start the like
  // animation either when the user double-clicks on a post, or when he clicks
  // the like button.
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
        // Animation increases the heart icon's size then decreases it, so each
        // way accounts for half the whole duration of the animation.
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

  // Called whenever the widget configuration changes. In this case, when the
  // ScaleTransition class is called in the build method, we need to start the
  // animation through this method.
  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.shouldAnimate != oldWidget.shouldAnimate) {
      startAnimation();
    }
  }

  void startAnimation() async {
    // If the widget should start animating.
    if (widget.shouldAnimate || widget.likeButtonHasBeenClicked) {
      // The animation should increase the size of the white heart icon, then
      // decrease it.
      // Increase size of white heart icon.
      await controller.forward();
      // Decrease size of white heart icon.
      await controller.reverse();
      // Wait for a bit before the heart icon disappears.
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
