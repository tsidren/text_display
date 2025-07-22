import 'package:flutter/material.dart';
import 'dart:math' as math; // Import for math.pi

class Fixed extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color bgColor;
  final String font;
  final String orientation;
  final double fontSize;

  const Fixed({
    super.key,
    required this.text,
    required this.textColor,
    required this.bgColor,
    required this.font,
    required this.orientation,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    // Handle empty text immediately by returning an empty SizedBox
    if (text.isEmpty) {
      return const SizedBox.shrink();
    }

    // The base Text widget with specified style
    Widget textContent = Text(
      text,
      style: TextStyle( // Use GoogleFonts for dynamic font loading
        fontFamily: font,
        color: textColor, // Directly use the textColor
        fontSize: fontSize,
        // fontWeight: FontWeight.bold, // Keep bold for visibility
      ),
      maxLines: 1, // Ensure text stays on a single line
      overflow: TextOverflow.visible, // Allow visual overflow
    );

    // Apply rotation if orientation is vertical
    if (orientation == 'Vertical') {
      textContent = Transform.rotate(
        angle: math.pi / 2, // 90 degrees clockwise
        child: textContent,
      );
    }

    // Wrap the text content in an OverflowBox to prevent clipping for long text
    // and center it within the available space.
    return Center(
      child: OverflowBox(
        minWidth: 0.0,
        maxWidth: double.infinity, // Allows the child to be as wide as it needs
        minHeight: 0.0,
        maxHeight: double.infinity, // Allows the child to be as tall as it needs
        alignment: Alignment.center, // Centers the content within the OverflowBox
        child: textContent,
      ),
    );
  }
}
