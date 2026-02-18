import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final List<double> ltrb;

  const CustomDivider({super.key, required this.ltrb});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(ltrb[0], ltrb[1], ltrb[2], ltrb[3]),
      child: Divider(height: 1, thickness: 2, color: Colors.black),
    );
  }
}
