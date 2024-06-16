// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(MyApp());

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IconAnimationDemo(),
    );
  }
}

// ignore: use_key_in_widget_constructors
class IconAnimationDemo extends StatefulWidget {
  @override
  _IconAnimationDemoState createState() => _IconAnimationDemoState();
}

class _IconAnimationDemoState extends State<IconAnimationDemo> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _rotationAnimation;

  final List<IconData> _icons = [
    Icons.star,
    Icons.favorite,
    Icons.thumb_up,
    Icons.ac_unit,
    Icons.cake,
    Icons.flight,
    Icons.alarm,
    Icons.accessibility,
    Icons.beach_access,
    Icons.brightness_5,
  ];

  int? _selectedIndex;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _sizeAnimation = Tween<double>(begin: 50, end: 150).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(begin: Colors.red, end: Colors.blue).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateIcon(int index) {
    setState(() {
      if (_selectedIndex == index) {
        _selectedIndex = null;
        _controller.reverse();
      } else {
        _selectedIndex = index;
        _controller.forward(from: 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Animation App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        centerTitle: true, 
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: _icons.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedIndex == index;
          return GestureDetector(
            onTap: () => _animateIcon(index),
            child: Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: isSelected ? _rotationAnimation.value : 0,
                        child: Icon(
                          _icons[index],
                          size: isSelected ? _sizeAnimation.value : 50,
                          color: isSelected ? _colorAnimation.value : Colors.teal,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}