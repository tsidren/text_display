import 'package:flutter/material.dart';
import 'dart:math' as math; // Import for math.pi

class StrobeAnimation extends StatefulWidget {
  final String text;
  final Color textColor;
  final Color bgColor;
  final String font;
  final double speed;
  final String orientation; // Not directly used for strobing, but kept for consistency
  final String repeat;
  final double fontSize;

  const StrobeAnimation({
    super.key,
    required this.text,
    required this.textColor,
    required this.bgColor,
    required this.font,
    required this.speed,
    required this.orientation,
    required this.repeat,
    required this.fontSize,
  });

  @override
  _StrobeAnimationState createState() => _StrobeAnimationState();
}

class _StrobeAnimationState extends State<StrobeAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  int _currentRepeatCount = 0;
  int _maxRepeats = 1; // Default to 1 repeat

  @override
  void initState() {
    super.initState();

    // Handle empty text immediately
    if (widget.text.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pop(context); // Navigate back if text is empty
        }
      });
      return;
    }

    _maxRepeats = int.tryParse(widget.repeat == 'Forever' ? '999':widget.repeat) ?? 1;
    if (_maxRepeats < 1) _maxRepeats = 1;

    // Calculate animation duration based on speed.
    // A higher speed means a shorter duration for each strobe cycle.
    // We want a full cycle (textColor -> bgColor -> textColor) to complete within this duration.
    // Base duration for one full strobe cycle (e.g., 500ms).
    final double baseStrobeDurationMs = 250.0;
    final Duration animationDuration = Duration(milliseconds: (baseStrobeDurationMs / widget.speed).round());

    _controller = AnimationController(
      duration: animationDuration,
      vsync: this,
    );

    // Animate between textColor and bgColor.
    // The animation will go from textColor to bgColor and then back to textColor.
    _colorAnimation = ColorTween(
      begin: widget.textColor,
      end: widget.bgColor,
    ).animate(_controller);

    // Add a listener to handle animation status changes (e.g., completion).
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // When the animation completes (reaches bgColor), reverse it to go back to textColor.
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        // When the animation reverses and returns to textColor, increment repeat count.
        _currentRepeatCount++;
        if (_maxRepeats == 0 || _currentRepeatCount < _maxRepeats) {
          // If more repeats are needed, start forward again.
          _controller.forward();
        } else {
          // All repeats completed, navigate back to the previous screen.
          if (mounted) {
            Navigator.pop(context);
          }
        }
      }
    });

    // Start the animation.
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller to prevent memory leaks.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // The Text widget and its style (including the animated color)
        // are now created inside the builder, ensuring they rebuild on each tick.
        Widget textContent = Text(
          widget.text,
          style: TextStyle(
            fontFamily: widget.font,
            color: _colorAnimation.value, // This is now correctly updated on each tick
            fontSize: widget.fontSize,
            // fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.visible,
        );

        // Apply rotation if orientation is vertical
        if (widget.orientation == 'Vertical') {
          textContent = Transform.rotate(
            angle: math.pi / 2, // 90 degrees clockwise
            child: textContent,
          );
        }

        return Center(
          child: OverflowBox( // Added OverflowBox here
            minWidth: 0.0,
            maxWidth: double.infinity, // Allow child to be as wide as it wants
            minHeight: 0.0,
            maxHeight: double.infinity, // Allow child to be as tall as it wants
            alignment: Alignment.center, // Align the content within the overflow box
            child: textContent, // Use the potentially rotated textContent as the child
          ), // Use the potentially rotated textContent
        );
      },
      // No 'child' parameter passed to AnimatedBuilder here, as content is built directly.
    );
  }
}
