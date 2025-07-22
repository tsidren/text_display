import 'package:flutter/material.dart';
import 'package:text_display/animations/Dot_Scroll.dart';
import 'package:text_display/animations/fixed.dart';
import 'package:text_display/animations/strobe_animation.dart';
import 'package:video_player/video_player.dart';
import 'scroll_animation.dart'; // Import your ScrollAnimation widget
import 'package:flutter/services.dart';

class VideoWithOverlayText extends StatefulWidget {
  final String text;
  final Color textColor;
  final Color bgColor;
  final String font;
  final double speed;
  final String orientation;
  final String repeat;
  final double fontSize;
  final String animation;

  const VideoWithOverlayText({
    super.key,
    required this.text,
    required this.textColor,
    required this.bgColor,
    required this.font,
    required this.speed,
    required this.orientation,
    required this.repeat,
    required this.fontSize,
    required this.animation
  });

  @override
  State<VideoWithOverlayText> createState() => _VideoWithOverlayTextState();
}

class _VideoWithOverlayTextState extends State<VideoWithOverlayText> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _controller = VideoPlayerController.asset('assets/video.mp4')
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget animationWidget;

    switch (widget.animation){
      case 'Scroll':
        animationWidget = ScrollAnimation(
          text: widget.text,
          textColor: widget.textColor,
          bgColor: Colors.transparent,
          font: widget.font,
          speed: widget.speed,
          orientation: widget.orientation,
          repeat: widget.repeat,
          fontSize: widget.fontSize,
        );
        break;
      case 'Strobe':
        animationWidget = StrobeAnimation(
          text: widget.text,
          textColor: widget.textColor,
          bgColor: widget.bgColor,
          font: widget.font,
          speed: widget.speed,
          orientation: widget.orientation,
          repeat: widget.repeat,
          fontSize: widget.fontSize,
        );
        break;
      case 'Dot_Scroll':
        animationWidget = DotScroll(
          text: widget.text,
          textColor: widget.textColor,
          bgColor: widget.bgColor,
          font: widget.font,
          speed: widget.speed,
          orientation: widget.orientation,
          repeat: widget.repeat,
          fontSize: widget.fontSize,
        );
        break;
      case 'Fixed':
        animationWidget = Fixed(
          text: widget.text,
          textColor: widget.textColor,
          bgColor: widget.bgColor,
          font: widget.font,
          orientation: widget.orientation,
          fontSize: widget.fontSize,
        );
        break;
      default:
        animationWidget = ScrollAnimation(
          text: widget.text,
          textColor: widget.textColor,
          bgColor: Colors.transparent,
          font: widget.font,
          speed: widget.speed,
          orientation: widget.orientation,
          repeat: widget.repeat,
          fontSize: widget.fontSize,
        );
    }
    return Scaffold(
      backgroundColor: widget.bgColor,
      body: _controller.value.isInitialized
          ? Stack(
        fit: StackFit.expand,
        children: [
          // Video background
          // MediaQuery.removePadding(
          //   context: context,
          //   removeTop: true,
          //   child:
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          // ),
          animationWidget,
          // ScrollAnimation(
          //     text: widget.text,
          //     textColor: widget.textColor,
          //     bgColor: Colors.transparent,
          //     font: widget.font,
          //     speed: widget.speed,
          //     orientation: widget.orientation,
          //     repeat: widget.repeat,
          //     fontSize: widget.fontSize,
          //   ),



          // Scrolling text animation overlay
          // Positioned.fill(
          //   child: ScrollAnimation(
          //     text: widget.text,
          //     textColor: widget.textColor,
          //     bgColor: Colors.transparent,
          //     font: widget.font,
          //     speed: widget.speed,
          //     orientation: widget.orientation,
          //     repeat: widget.repeat,
          //     fontSize: widget.fontSize,
          //   ),
          // ),
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
