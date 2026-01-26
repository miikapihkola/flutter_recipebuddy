import 'package:flutter/material.dart';

class PinnedView extends StatelessWidget {
  const PinnedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pinned")),
      body: SingleChildScrollView(
        child: Column(children: [Text("placeholder")]),
      ),
    );
  }
}
