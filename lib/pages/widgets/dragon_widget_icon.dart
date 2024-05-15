import 'package:flutter/material.dart';

class DragonIconWidget extends StatefulWidget {
  final String imagePath;
  final String text;

  const DragonIconWidget({
    super.key,
    required this.imagePath,
    required this.text,
  });

  @override
  _DragonIconWidgetState createState() => _DragonIconWidgetState();
}

class _DragonIconWidgetState extends State<DragonIconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 248, 249, 250).withOpacity(0.12),
              spreadRadius: 2,
              blurRadius: 20,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 75,
              backgroundColor: Colors.transparent,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  const Color.fromARGB(206, 4, 46, 216).withOpacity(0.2),
                  BlendMode.srcATop,
                ),
                child: Image.asset(widget.imagePath),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.text,
              style: const TextStyle(
                color: Color.fromARGB(245, 255, 255, 255),
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
