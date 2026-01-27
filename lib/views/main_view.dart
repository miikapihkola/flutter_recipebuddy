import 'package:flutter/material.dart';
import 'Ingredients_view.dart';
import 'pinned_view.dart';
import 'recipes_view.dart';
import 'shoppinglist_view.dart';
import 'settings_view.dart';

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
      body: Center(
        child: SizedBox(
          width: 250,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NavButton(route: PinnedView(), text: "Pinned"),
              NavButton(route: ShoppinglistView(), text: "Shoppinglist"),
              NavButton(route: RecipesView(), text: "Recipes"),
              NavButton(route: IngredientsView(), text: "Ingredients"),
              SizedBox(height: 150),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: FilledButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => route),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(text, textScaler: TextScaler.linear(1.5)),
        ),
      ),
    );
  }
}
