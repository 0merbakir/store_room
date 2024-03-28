import 'package:flutter/material.dart';
import 'dart:async';

class AddShelfButton extends StatefulWidget {
  final VoidCallback onPressed;

  const AddShelfButton({super.key, required this.onPressed});

  @override
  AddShelfButtonState createState() => AddShelfButtonState();
}

class AddShelfButtonState extends State<AddShelfButton> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPressed() {
    _controller.forward(from: 0.0);
    Timer(const Duration(milliseconds: 500), widget.onPressed);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: GestureDetector(
        onTap: _onPressed,
        child: RotationTransition(
          turns: _controller,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(183, 4, 40, 131),
                  Color.fromARGB(179, 5, 80, 193),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.add_chart_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
