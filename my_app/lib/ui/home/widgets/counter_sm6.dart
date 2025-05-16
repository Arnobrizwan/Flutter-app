import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Home());
  }
}

// 1. Create InheritedWidget subclass
class AppStateInheritedWidget extends InheritedWidget {
  final Color textColor;
  final double textSize;
  final Function(Color) updateColor;
  final Function(double) updateSize;

  const AppStateInheritedWidget({
    super.key,
    required this.textColor,
    required this.textSize,
    required this.updateColor,
    required this.updateSize,
    required super.child,
  });

  static AppStateInheritedWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppStateInheritedWidget>()!;
  }

  @override
  bool updateShouldNotify(AppStateInheritedWidget oldWidget) {
    return textColor != oldWidget.textColor || textSize != oldWidget.textSize;
  }
}

// 2. StatefulWidget to manage state
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Color _color = Colors.black;
  double _size = 50.0;

  void _updateColor(Color newColor) {
    setState(() {
      _color = (_color == newColor) ? Colors.black : newColor;
    });
  }

  void _updateSize(double newSize) {
    setState(() {
      _size = newSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppStateInheritedWidget(
      textColor: _color,
      textSize: _size,
      updateColor: _updateColor,
      updateSize: _updateSize,
      child: const _HomeScaffold(),
    );
  }
}

// 3. Stateless widget tree that consumes inherited widget
class _HomeScaffold extends StatelessWidget {
  const _HomeScaffold();

  @override
  Widget build(BuildContext context) {
    final appState = AppStateInheritedWidget.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: Text(
          'Hello world!',
          style: TextStyle(
            fontSize: appState.textSize,
            color: appState.textColor,
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () => appState.updateColor(Colors.blue),
            backgroundColor: Colors.blue,
            child: const Icon(Icons.access_alarm),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () => appState.updateColor(Colors.red),
            backgroundColor: Colors.red,
            child: const Icon(Icons.access_time),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomSheet: SizedBox(
        height: 100,
        child: Slider(
          value: appState.textSize,
          min: 10,
          max: 100,
          onChanged: appState.updateSize,
        ),
      ),
    );
  }
}