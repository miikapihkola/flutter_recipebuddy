import 'package:flutter/material.dart';

class IngredientsView extends StatelessWidget {
  const IngredientsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ingredients"),
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
