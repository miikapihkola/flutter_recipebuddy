import 'package:flutter/material.dart';

class RecipesView extends StatelessWidget {
  const RecipesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recipes")),
      body: SingleChildScrollView(
        child: Column(children: [Text("placeholder")]),
      ),
    );
  }
}
