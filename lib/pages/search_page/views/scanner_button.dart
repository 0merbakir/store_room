import 'dart:async';
import 'package:flutter/material.dart';

class ScannerButton extends StatefulWidget {
  final VoidCallback onPressed;

  const ScannerButton({super.key, required this.onPressed});

  @override
  ScannerButtonState createState() => ScannerButtonState();
}

class ScannerButtonState extends State<ScannerButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPressed() {
    _controller.forward(from: 0.0);
    Timer(const Duration(milliseconds: 250), widget.onPressed);
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
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade700,
                  Colors.blue.shade500,
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
                BoxShadow(
                  color:const  Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.qr_code_scanner,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
