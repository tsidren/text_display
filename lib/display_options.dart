import 'package:flutter/material.dart';
import 'package:text_display/display.dart';

class DisplayBoard extends StatefulWidget {
  const DisplayBoard({super.key});

  @override
  _DisplayBoardState createState() => _DisplayBoardState();
}

class _DisplayBoardState extends State<DisplayBoard> {
  final TextEditingController _controller = TextEditingController();
  String _displayText = "";
  Color _textColor = Colors.white;
  Color _bgColor = Colors.black;
  String _fontFamily = 'Roboto';
  double _speed = 1.0;
  String _orientation = 'Horizontal';
  String _repeat = '1';
  String _selectedAnimation = 'Scroll';
  double _fontSize = 48.0;
  String error = '';

  final List<String> _fonts = [
    'Roboto',
    'Montserrat',
    'Poppins',
    'Caveat',
    'Dancing_Script',
    'Pacifico',
    'Pangolin',
  ];

  final Map<String, Color> colorMap = {
    'White': Colors.white,
    'Black': Colors.black,
    'Red': Colors.red,
    'Green': Colors.green,
    'Blue': Colors.blue,
    'video': Colors.transparent,
  };

  final List<String> selectedAnimationOptions = ['Scroll', 'Strobe', 'Dot_Scroll', 'Fixed'];
  final List<String> orientationOptions = ['Horizontal', 'Vertical'];
  final List<String> repeatOptions = ['1', '2', '3', '4', '5', '6', 'Forever'];
  // String selectedValue = 'Strobe';
  // String selectedColorName = 'Black';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Text Display Board'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input Field
            TextField(
              controller: _controller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter text to display',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
            Text(
                error,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.0,
                )
            ),
            SizedBox(height: 12),

            // Font Selector
            DropdownButton<String>(
              value: _fontFamily,
              onChanged: (val) => setState(() => _fontFamily = val!),
              items: _fonts
                  .map((font) => DropdownMenuItem(
                value: font,
                child: Text(font, style: TextStyle(fontFamily: font)),
              ))
                  .toList(),
            ),

            // Text Color
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Text Color'),
                DropdownButton<String>(
                  value: colorMap.entries.firstWhere((entry) => entry.value == _textColor).key,
                  items: colorMap.entries.where((entry) => entry.key != 'video') // Filter out 'video' option
                                  .map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.key),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _textColor = colorMap[value!]!;
                      // Use selectedColor where needed
                    });
                  },
                ),
              ],
            ),

            // Background Color
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Background'),
                DropdownButton<String>(
                  value: colorMap.entries.firstWhere((entry) => entry.value == _bgColor).key,
                  items: colorMap.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.key),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _bgColor = colorMap[value!]!;

                      // Use selectedColor where needed
                    });
                  },
                ),
              ],
            ),
            // Text orientation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Text Orientation'),
                DropdownButton<String>(
                  value: _orientation,
                  // decoration: InputDecoration(labelText: 'Text Orientation'),
                  items: orientationOptions
                      .map((o) => DropdownMenuItem<String>(value: o, child: Text(o)))
                      .toList(),
                  onChanged: (val) => setState(() => _orientation = val!),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Repeat Display'),
                DropdownButton<String>(
                  value: _repeat,
                  hint: const Text('Choose an option'),
                  underline: const SizedBox(),
                  items: repeatOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value), // Display the integer value as text
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _repeat = newValue;
                      });
                    }
                  },
                ),
              ],
            ),

            // Speed Slider
            Row(
              children: [
                Text('Speed'),
                Expanded(
                  child: Slider(
                    value: _speed,
                    min: 0.2,
                    max: 3.0,
                    divisions: 14,
                    label: _speed.toStringAsFixed(1),
                    onChanged: (val) => setState(() => _speed = val),
                  ),
                )
              ],
            ),
            Row(
              children: [
                const Text('Font Size', style: TextStyle(color: Colors.white)),
                Expanded(
                  child: Slider(
                    value: _fontSize,
                    min: 10.0,
                    max: 200.0, // Allow for very large fonts
                    divisions: 190, // (200-10)/1 = 190 divisions
                    label: _fontSize.toStringAsFixed(0),
                    onChanged: (val) => setState(() => _fontSize = val),
                  ),
                )
              ],
            ),
            // Animated Display Text
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text('Animation Type'),
            //     DropdownButton<String>(
            //       value: _selectedAnimation,
            //       // decoration: InputDecoration(labelText: 'Text Orientation'),
            //       items: selectedAnimationOptions
            //           .map((o) => DropdownMenuItem<String>(value: o, child: Text(o)))
            //           .toList(),
            //       onChanged: (val) => setState(() => _selectedAnimation = val!),
            //     ),
            //   ],
            // ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Animation Type'),
                DropdownButton<String>(
                  value: _selectedAnimation,
                  items: [
                    DropdownMenuItem(
                      value: 'Scroll',
                      child: SizedBox(
                        // width: 150, // Provide fixed width to avoid unbounded constraints
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Scroll'),
                            // Spacer(),
                            Image.asset(
                              'assets/scroll.gif',
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Strobe',
                      child: SizedBox(
                        // width: 150, // Provide fixed width to avoid unbounded constraints
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Strobe'),
                            // Spacer(),
                            Image.asset(
                              'assets/strobe.gif',
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Dot_Scroll',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Dot_Scroll'),
                          Image.asset(
                            'assets/Dot_Scroll.gif',
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Fixed',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Fixed'),
                          Image.asset(
                            'assets/fixed.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (val) {
                    setState(() => _selectedAnimation = val!);
                  },
                ),
              ],
            ),

            SizedBox(height: 12),
            // Buttons
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  setState(() {
                    error = '';
                    _displayText = _controller.text;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                        Display(
                          text: _displayText,
                          textColor: _textColor,
                          bgColor: _bgColor,
                          font: _fontFamily,
                          speed: _speed,
                          orientation: _orientation,
                          repeat: _repeat,
                          animationType: _selectedAnimation,
                          fontSize: _fontSize,
                        ),
                    ),
                  );
                } else{
                  setState(() {
                    error = 'Text cannot be empty';
                  });
                }
              },
              child: Text('Display'),
            ),
          ],
        ),
      ),
    );
  }
}