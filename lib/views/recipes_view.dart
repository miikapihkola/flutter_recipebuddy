import 'package:flutter/material.dart';

class RecipesView extends StatelessWidget {
  const RecipesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipes"),
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
