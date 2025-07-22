import 'package:flutter/material.dart';
import 'dart:math' as math; // Import for math.pi

class ScrollAnimation extends StatefulWidget {
  final String text;
  final Color textColor;
  final Color bgColor;
  final String font;
  final double speed;
  final String orientation;
  final String repeat;
  final double fontSize;

  const ScrollAnimation({
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
  _ScrollAnimationState createState() => _ScrollAnimationState();
}

class _ScrollAnimationState extends State<ScrollAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  int _currentRepeatCount = 0;
  int _maxRepeats = 1; // Default to 1 repeat


  // Variables to store the measured intrinsic text dimensions
  late double _measuredTextWidth;
  late double _measuredTextHeight;

  @override
  void initState() {
    super.initState();

    // Handle empty text immediately
    if (widget.text.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) { // Check if widget is still in the tree before popping
          Navigator.pop(context); // Navigate back if text is empty
        }
      });
      return; // Stop further initialization if text is empty
    }

    // Parse the repeat string to an integer. If parsing fails, default to 1.
    _maxRepeats = int.tryParse(widget.repeat == 'Forever' ? '999':widget.repeat) ?? 1;
    if (_maxRepeats < 1) _maxRepeats = 1; // Ensure at least 1 repeat

    // Initialize _controller with a placeholder duration.
    // The actual duration will be set in _setupAnimationParameters.
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1),
      vsync: this,
    );

    // Initialize _animation with placeholder values.
    // The actual begin/end offsets will be set in _setupAnimationParameters.
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(_controller);

    // Add a listener to handle animation status changes (e.g., completion).
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _currentRepeatCount++;
        if (_maxRepeats == 0 || _currentRepeatCount < _maxRepeats) {
          _controller.forward(from: 0.0); // Restart animation from the beginning
        } else {
          if (mounted) { // Check if widget is still in the tree before popping
            Navigator.pop(context); // All repeats completed, navigate back.
          }
        }
      }
    });

    // Use a post-frame callback to set up animation parameters and start the animation.
    // This ensures MediaQuery.of(context) is available for screen dimensions.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _setupAnimationParameters(); // Configure animation with actual dimensions
        _controller.forward(from: 0.0); // Start animation
      }
    });
  }

  // Calculates text size using TextPainter and sets up animation parameters.
  void _setupAnimationParameters() {
    // Define the text style, matching what's used in the build method.
    final TextStyle textStyle = TextStyle(
      fontFamily: widget.font,
      color: widget.textColor,
      fontSize: widget.fontSize, // This should match the font size in the Text widget in build()
      fontWeight: FontWeight.bold,
    );

    // Use TextPainter to measure the intrinsic size of the text.
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: textStyle),
      textDirection: TextDirection.ltr, // TextDirection is required for TextPainter
      maxLines: 1, // Ensure it's measured as a single line
    )..layout(minWidth: 0, maxWidth: 10000.0); // Layout with infinite width to get true intrinsic size

    _measuredTextWidth = textPainter.width;
    _measuredTextHeight = textPainter.height;

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    Offset beginOffset;
    Offset endOffset;

    // Define the start and end offsets for the scrolling animation based on orientation.
    if (widget.orientation == 'Horizontal') {
      beginOffset = Offset(screenWidth + _measuredTextWidth/2, 0.0); // Start from right edge of screen
      endOffset = Offset(-(_measuredTextWidth/2+screenWidth), 0.0); // Move to left, off-screen by its full width
    } else { // Vertical
      // For vertical animation, the text moves along the Y-axis.
      // The `_measuredTextHeight` is used to determine how far it needs to travel vertically.
      beginOffset = Offset(0.0, screenHeight + _measuredTextWidth/2); // Start from bottom edge of screen
      endOffset = Offset(0.0, -(_measuredTextWidth/2+screenHeight)); // Move to top, off-screen by its full height
    }

    double totalTravelDistance;
    if (widget.orientation == 'Horizontal') {
      totalTravelDistance = screenWidth/2 + _measuredTextWidth;
    } else {
      totalTravelDistance = screenHeight/2 + _measuredTextWidth; // Use _measuredTextWidth as it's the effective height when rotated
    }

    // Base duration per pixel/unit of travel, then scale by total distance and speed.
    // This makes the speed more consistent regardless of text length or screen size.
    final double baseDurationPerUnit = 5.0; // milliseconds per unit of travel
    final Duration animationDuration = Duration(milliseconds: (totalTravelDistance * baseDurationPerUnit / widget.speed).round());

    // Update the controller's duration and the animation's tween with the calculated values.
    _controller.duration = animationDuration;
    _animation = Tween<Offset>(
      begin: beginOffset,
      end: endOffset,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller to prevent memory leaks.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The actual Text widget to be displayed and animated.
    Widget textContent = Text(
      widget.text,
      style: TextStyle(
          fontFamily: widget.font,
        color: widget.textColor,
        fontSize: widget.fontSize, // Ensure this matches the fontSize used in TextPainter
        // fontWeight: FontWeight.bold,
      ),
      maxLines: 1, // Keep as single line for scrolling effect
      // overflow: TextOverflow.visible, // Allow visual overflow if parent constraints are tight
    );

    // Apply rotation if orientation is vertical
    if (widget.orientation == 'Vertical') {
      // Rotate the text 90 degrees clockwise for vertical display.
      textContent = Transform.rotate(
        angle: math.pi / 2, // 90 degrees clockwise (in radians)
        child: Center(child: textContent),
      );
    }

    // Use AnimatedBuilder to rebuild the widget tree efficiently as the animation value changes.
    // The text is now always ready to be displayed, no need for a loading indicator.
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _animation.value, // Apply the animated offset to the text.
          child: OverflowBox( // Added OverflowBox here
            minWidth: 0.0,
            maxWidth: double.infinity, // Allow child to be as wide as it wants
            minHeight: 0.0,
            maxHeight: double.infinity, // Allow child to be as tall as it wants
            alignment: Alignment.center, // Align the content within the overflow box
            child: child,
          ),
        );
      },
      child: Center(child: textContent), // Use the potentially rotated textContent as the child
    );
  }
}
