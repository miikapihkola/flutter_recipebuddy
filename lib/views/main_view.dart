import 'package:flutter/material.dart';
import '/views/Ingredients_view.dart';
import '/views/pinned_view.dart';
import '/views/recipes_view.dart';
import '/views/shoppinglist_view.dart';
import '/views/settings_view.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipe Buddy"),
        actions: [
          IconButton(
            iconSize: Theme.of(context).iconTheme.size,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsView()),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              NavButton(route: PinnedView(), text: "Pinned"),
              NavButton(route: ShoppinglistView(), text: "Shoppinglist"),
              NavButton(route: RecipesView(), text: "Recipes"),
              NavButton(route: IngredientsView(), text: "Ingredients"),
            ],
          ),
        ),
      ),
    );
  }
}

class NavButton extends StatelessWidget {
  final Widget route;
  final String text;

  const NavButton({super.key, required this.route, required this.text});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => route));
      },
      child: Text(text),
    );
  }
}
