import 'package:flutter/material.dart';
import 'dart:math' as math; // Import for math.pi

class DotScroll extends StatefulWidget {
  final String text;
  final Color textColor;
  final Color bgColor;
  final String font; // Font is not directly used for DOT character shapes
  final double speed;
  final String orientation;
  final String repeat;
  final double fontSize; // Controls the size of individual dots

  const DotScroll({
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
  _DotScrollState createState() => _DotScrollState();
}

class _DotScrollState extends State<DotScroll> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  int _currentRepeatCount = 0;
  int _maxRepeats = 1;

  // Measured dimensions of the entire DOT text strip
  late double _measuredDotStripWidth;
  late double _measuredDotStripHeight;
  late double _characterSpacingWidth;


  // Define a simple 5x7 dot matrix font for common characters
  // 0 = off, 1 = on

  static const Map<String, List<List<int>>> _dotFont = {
    ' ': [
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    'H': [
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [1, 1, 1, 1, 1],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [0, 0, 0, 0, 0], // Spacer row
      [0, 0, 0, 0, 0], // Spacer row
    ],
    'E': [
      [1, 1, 1, 1, 1],
      [1, 0, 0, 0, 0],
      [1, 1, 1, 0, 0],
      [1, 0, 0, 0, 0],
      [1, 1, 1, 1, 1],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    'L': [
      [1, 0, 0, 0, 0],
      [1, 0, 0, 0, 0],
      [1, 0, 0, 0, 0],
      [1, 0, 0, 0, 0],
      [1, 1, 1, 1, 1],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    'O': [
      [0, 1, 1, 1, 0],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [0, 1, 1, 1, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    'W': [
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [1, 0, 1, 0, 1],
      [1, 1, 0, 1, 1],
      [1, 0, 0, 0, 1],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    'R': [
      [1, 1, 1, 1, 0],
      [1, 0, 0, 0, 1],
      [1, 1, 1, 1, 0],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    'D': [
      [1, 1, 1, 0, 0],
      [1, 0, 0, 1, 0],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 1, 0],
      [1, 1, 1, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    'I': [
      [1, 1, 1, 1, 1],
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [1, 1, 1, 1, 1],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    'A': [
      [0, 1, 1, 1, 0],
      [1, 0, 0, 0, 1],
      [1, 1, 1, 1, 1],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    'M': [
      [1, 0, 0, 0, 1],
      [1, 1, 0, 1, 1],
      [1, 0, 1, 0, 1],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    'C': [
      [0, 1, 1, 1, 1],
      [1, 0, 0, 0, 0],
      [1, 0, 0, 0, 0],
      [1, 0, 0, 0, 0],
      [0, 1, 1, 1, 1],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    'G': [
      [0, 1, 1, 1, 1],
      [1, 0, 0, 0, 0],
      [1, 0, 1, 1, 1],
      [1, 0, 0, 0, 1],
      [0, 1, 1, 1, 1],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    'N': [
      [1, 0, 0, 0, 1],
      [1, 1, 0, 0, 1],
      [1, 0, 1, 0, 1],
      [1, 0, 0, 1, 1],
      [1, 0, 0, 0, 1],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    'P': [
      [1, 1, 1, 1, 0],
      [1, 0, 0, 0, 1],
      [1, 1, 1, 1, 0],
      [1, 0, 0, 0, 0],
      [1, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    'S': [
      [0, 1, 1, 1, 1],
      [1, 0, 0, 0, 0],
      [0, 1, 1, 1, 0],
      [0, 0, 0, 0, 1],
      [1, 1, 1, 1, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    'T': [
      [1, 1, 1, 1, 1],
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    'U': [
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [0, 1, 1, 1, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    'V': [
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [0, 1, 0, 1, 0],
      [0, 1, 0, 1, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    'X': [
      [1, 0, 0, 0, 1],
      [0, 1, 0, 1, 0],
      [0, 0, 1, 0, 0],
      [0, 1, 0, 1, 0],
      [1, 0, 0, 0, 1],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    'Y': [
      [1, 0, 0, 0, 1],
      [0, 1, 0, 1, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    'Z': [
      [1, 1, 1, 1, 1],
      [0, 0, 0, 1, 0],
      [0, 0, 1, 0, 0],
      [0, 1, 0, 0, 0],
      [1, 1, 1, 1, 1],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    '0': [
      [0, 1, 1, 1, 0],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [0, 1, 1, 1, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    '1': [
      [0, 0, 1, 0, 0],
      [0, 1, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 1, 1, 1, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    '2': [
      [0, 1, 1, 1, 0],
      [1, 0, 0, 0, 1],
      [0, 0, 1, 1, 0],
      [0, 1, 0, 0, 0],
      [1, 1, 1, 1, 1],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    '3': [
      [1, 1, 1, 1, 1],
      [0, 0, 0, 0, 1],
      [0, 1, 1, 1, 0],
      [0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    '4': [
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [1, 1, 1, 1, 1],
      [0, 0, 0, 0, 1],
      [0, 0, 0, 0, 1],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    '5': [
      [1, 1, 1, 1, 1],
      [1, 0, 0, 0, 0],
      [1, 1, 1, 1, 0],
      [0, 0, 0, 0, 1],
      [1, 1, 1, 1, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    '6': [
      [0, 1, 1, 1, 0],
      [1, 0, 0, 0, 0],
      [1, 1, 1, 1, 0],
      [1, 0, 0, 0, 1],
      [0, 1, 1, 1, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    '7': [
      [1, 1, 1, 1, 1],
      [0, 0, 0, 0, 1],
      [0, 0, 0, 1, 0],
      [0, 0, 1, 0, 0],
      [0, 1, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    '8': [
      [0, 1, 1, 1, 0],
      [1, 0, 0, 0, 1],
      [0, 1, 1, 1, 0],
      [1, 0, 0, 0, 1],
      [0, 1, 1, 1, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    '9': [
      [0, 1, 1, 1, 0],
      [1, 0, 0, 0, 1],
      [0, 1, 1, 1, 1],
      [0, 0, 0, 0, 1],
      [0, 1, 1, 1, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    '!': [
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    '.': [
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    '?': [
      [0, 1, 1, 1, 0],
      [1, 0, 0, 0, 1],
      [0, 0, 1, 1, 0],
      [0, 1, 0, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
  };

  // Helper to build a single DOT character from its pattern
  Widget _buildDotCharacter(String char, double dotSize) {
    final List<List<int>>? pattern = _dotFont[char.toUpperCase()]; // Use uppercase for matching

    if (pattern == null) {
      // Return a blank space for unsupported characters
      return SizedBox(width: dotSize * 5, height: dotSize * 7);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: pattern.map((row) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: row.map((pixel) {
            return Container(
              width: dotSize,
              height: dotSize,
              margin: EdgeInsets.all(dotSize * 0.1), // Small margin between dots
              decoration: BoxDecoration(
                color: pixel == 1 ? widget.textColor : widget.bgColor.withOpacity(0), // Dim off-dots
                shape: BoxShape.circle, // Make them circular for DOT look
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  @override
  void initState() {
    super.initState();

    if (widget.text.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pop(context);
        }
      });
      return;
    }

    _maxRepeats = int.tryParse(widget.repeat == 'Forever' ? '999' : widget.repeat) ?? 1;
    if (_maxRepeats < 1) _maxRepeats = 1;

    // Calculate dimensions of the entire Dot strip
    _calculateDotStripDimensions();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1), // Placeholder duration
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _currentRepeatCount++;
        if (_maxRepeats == 0 || _currentRepeatCount < _maxRepeats) {
          _controller.forward(from: 0.0);
        } else {
          if (mounted) {
            Navigator.pop(context);
          }
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _setupAnimationParameters();
        _controller.forward(from: 0.0);
      }
    });
  }

  // Calculates the total width and height of the DOT text strip
  void _calculateDotStripDimensions() {
    // Assuming 5x7 character matrix + 1 dot spacing between characters horizontally
    // and 1 dot spacing between rows vertically (handled by margin)
    final double dotSize = widget.fontSize / 7; // Base dot size from font size
    final double charWidth = (dotSize * 5) + (dotSize * 0.1 * 2); // 5 dots + margins
    final double charHeight = (dotSize * 7) + (dotSize * 0.1 * 2); // 7 dots + margins

    _characterSpacingWidth = dotSize/2;

    // _measuredDotStripWidth = widget.text.length * charWidth;
    _measuredDotStripWidth = (widget.text.length * charWidth);
    // Add spacing for all but the last character
    if (widget.text.length > 1) {
      _measuredDotStripWidth += (widget.text.length - 1) * _characterSpacingWidth;
    }
    _measuredDotStripHeight = charHeight; // Height of a single row of characters
  }

  // Sets up the AnimationController's duration and the Tween based on DOT strip dimensions.
  void _setupAnimationParameters() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    Offset beginOffset;
    Offset endOffset;

    if (widget.orientation == 'Horizontal') {
      beginOffset = Offset(_measuredDotStripWidth, 0.0); // Start from right edge of screen
      endOffset = Offset(-(_measuredDotStripWidth), 0.0); // Move to left, off-screen by its full width
    } else { // Vertical
      // For vertical animation, the strip is rotated, so its effective height is _measuredDotStripWidth
      beginOffset = Offset(0.0, _measuredDotStripWidth); // Start from bottom edge of screen
      endOffset = Offset(0.0, -(_measuredDotStripWidth)); // Move to top, off-screen by its effective height
    }

    // Adjust duration based on the actual travel distance.
    double totalTravelDistance;
    if (widget.orientation == 'Horizontal') {
      totalTravelDistance = screenWidth/2 + _measuredDotStripWidth;
    } else {
      totalTravelDistance = screenHeight/2 + _measuredDotStripWidth;
    }

    final double baseDurationPerUnit = 5.0; // milliseconds per unit of travel
    final Duration animationDuration = Duration(milliseconds: (totalTravelDistance * baseDurationPerUnit / widget.speed).round());

    _controller.duration = animationDuration;
    _animation = Tween<Offset>(
      begin: beginOffset,
      end: endOffset,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double dotSize = widget.fontSize / 10; // Calculate dot size based on fontSize

    List<Widget> charactersWithSpacing = [];
    for (int i = 0; i < widget.text.length; i++) {
      charactersWithSpacing.add(_buildDotCharacter(widget.text[i], dotSize));
      if (i < widget.text.length - 1) {
        charactersWithSpacing.add(SizedBox(width: _characterSpacingWidth)); // Add defined spacing
      }
    }
    Widget dotTextContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: charactersWithSpacing,
    );
    // Build the entire DOT text strip
    // Widget dotTextContent = Row(
    //   mainAxisSize: MainAxisSize.min,
    //   children: widget.text.split('').map((char) {
    //     return _buildDotCharacter(char, dotSize);
    //   }).toList(),
    // );

    // Apply rotation if orientation is vertical
    if (widget.orientation == 'Vertical') {
      dotTextContent = Transform.rotate(
        angle: math.pi / 2, // 90 degrees clockwise
        child: Center(child: dotTextContent),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _animation.value,
          child: OverflowBox(
            minWidth: 0.0,
            maxWidth: double.infinity,
            minHeight: 0.0,
            maxHeight: double.infinity,
            alignment: Alignment.center,
            child: child,
          ),
        );
      },
      child: Center(child: dotTextContent), // Center the DOT content
    );
  }
}
