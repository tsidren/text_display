import 'package:flutter/material.dart';
import 'package:text_display/animations/fixed.dart';
import 'package:text_display/animations/Dot_Scroll.dart';
import 'package:text_display/animations/scroll_animation.dart';
import 'package:text_display/animations/strobe_animation.dart';
import 'package:text_display/animations/video.dart';
import 'package:video_player/video_player.dart';

class Display extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color bgColor;
  final String font;
  final double speed;
  final String orientation;
  final String repeat;
  final String animationType;
  final double fontSize;

  const Display({
    super.key,
    required this.text,
    required this.textColor,
    required this.bgColor,
    required this.font,
    required this.speed,
    required this.orientation,
    required this.repeat,
    required this.animationType,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    Widget animationWidget;

    switch (animationType) {
      case 'Scroll':
        animationWidget = ScrollAnimation(
          text: text,
          textColor: textColor,
          bgColor: bgColor,
          font: font,
          speed: speed,
          orientation: orientation,
          repeat: repeat,
          fontSize: fontSize,
        );
        break;
      case 'Strobe':
        animationWidget = StrobeAnimation(
          text: text,
          textColor: textColor,
          bgColor: bgColor,
          font: font,
          speed: speed,
          orientation: orientation,
          repeat: repeat,
          fontSize: fontSize,
        );
        break;
      case 'Fixed':
        animationWidget = Fixed(
          text: text,
          textColor: textColor,
          bgColor: bgColor,
          font: font,
          orientation: orientation,
          fontSize: fontSize,
        );
        break;
      case 'Dot_Scroll':
        animationWidget = DotScroll(
          text: text,
          textColor: textColor,
          bgColor: bgColor,
          font: font,
          speed: speed,
          orientation: orientation,
          repeat: repeat,
          fontSize: fontSize,
        );
        break;
      // case 'Video':
      //   // animationWidget = VideoPlayerController.asset('assets/video.mp4');
      //   animationWidget = VideoWithOverlayText(
      //     text: text,
      //     textColor: textColor,
      //     bgColor: bgColor,
      //     font: font,
      //     speed: speed,
      //     orientation: orientation,
      //     repeat: repeat,
      //     fontSize: fontSize,
      //     animation: animationType,
      //   );
      //   break;
    // Add other cases
      default:
        animationWidget = Center(child: Text('Invalid animation type'));
    }
    if (bgColor == Colors.transparent){
      animationWidget = VideoWithOverlayText(
        text: text,
        textColor: textColor,
        bgColor: bgColor,
        font: font,
        speed: speed,
        orientation: orientation,
        repeat: repeat,
        fontSize: fontSize,
        animation: animationType,
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      // appBar: AppBar( // Added AppBar for navigation back
      //   backgroundColor: Colors.black, // Match background color
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: textColor), // Back arrow icon
      //     onPressed: () {
      //       Navigator.pop(context); // Navigate back to the previous screen
      //     },
      //   ),
      //   title: Text(
      //     'Display',
      //     style: TextStyle(color: Colors.white), // Match text color
      //   ),
      // ),
      body: SafeArea(child: animationWidget),
    );
  }
}