import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  String _currentText = "Hello";

  void _switchText() {
    setState(() {
      _currentText = _currentText == "Hello" ? "World" : "Hello";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Text Switching Animation")),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: Text(
            _currentText,
            // The key is essential for AnimatedSwitcher to identify a change
            key: ValueKey<String>(_currentText),
            style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        isExtended: false,
        onPressed: _switchText,
        child: Icon(Icons.change_circle),
      ),
    );
  }
}
