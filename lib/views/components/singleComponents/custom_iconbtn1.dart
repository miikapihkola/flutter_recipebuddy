import 'package:flutter/material.dart';

class CustomIconBtn1 extends StatelessWidget {
  final Icon icon;
  final bool bgOn;
  final VoidCallback onPressed;

  const CustomIconBtn1({
    super.key,
    required this.icon,
    required this.bgOn,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          bgOn ? const Color.fromARGB(255, 161, 227, 230) : Colors.white70,
        ),
      ),
    );
  }
}
