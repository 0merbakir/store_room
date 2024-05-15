import 'package:flutter/material.dart';
import 'dart:async';

class AddShelfButton extends StatefulWidget {
  final VoidCallback onPressed;

  const AddShelfButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  AddShelfButtonState createState() => AddShelfButtonState();
}

class AddShelfButtonState extends State<AddShelfButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _controller.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPressed() {
    _controller.stop();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80, // Adjust the width as needed
      height: 80, // Adjust the height as needed
      child: GestureDetector(
        onTap: _onPressed,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 +
                  _controller.value *
                      0.1, // Adjust the scale factor for the pop-up effect
              child: child,
            );
          },
          child: RotationTransition(
            turns: _controller,
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(117, 90, 89, 89), // Top color with opacity
                    Color.fromARGB(
                        255, 11, 11, 125), // Bottom color // Bottom color
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(35, 4, 21, 169),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(3,
                        3), // Adjust the offset to control the shadow position
                  ),
                ],
              ),
              child: const Icon(
                Icons.format_shapes,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
