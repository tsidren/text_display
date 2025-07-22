import 'package:flutter/material.dart';
import 'package:text_display/display_options.dart';

void main() {
  runApp(TextDisplayBoardApp());
}

class TextDisplayBoardApp extends StatelessWidget {
  const TextDisplayBoardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Display Board',
      theme: ThemeData.dark(),
      home: DisplayBoard(),
    );
  }
}


