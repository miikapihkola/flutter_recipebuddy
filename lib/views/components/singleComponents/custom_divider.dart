import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final List<double> tb;

  const CustomDivider({super.key, required this.tb});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, tb[0], 5, tb[1]),
      child: Divider(height: 1, thickness: 2, color: Colors.black),
    );
  }
}
