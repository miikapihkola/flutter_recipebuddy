import 'package:flutter/material.dart';

class ShoppinglistView extends StatelessWidget {
  const ShoppinglistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shoppinglist"),
        actions: [
          IconButton(
            iconSize: Theme.of(context).iconTheme.size,
            onPressed: () {},
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [Text("placeholder")]),
      ),
    );
  }
}
