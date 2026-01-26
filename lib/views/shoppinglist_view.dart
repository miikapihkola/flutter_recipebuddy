import 'package:flutter/material.dart';

class ShoppinglistView extends StatelessWidget {
  const ShoppinglistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shoppinglist")),
      body: SingleChildScrollView(
        child: Column(children: [Text("placeholder")]),
      ),
    );
  }
}
