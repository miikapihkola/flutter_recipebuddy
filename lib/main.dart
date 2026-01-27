import 'package:flutter/material.dart';
import 'data/recipe_list_manager.dart';
import 'data/ingredient_list_manager.dart';
import 'views/main_view.dart';
import 'package:provider/provider.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => IngredientListManager()),
      ChangeNotifierProvider(create: (context) => RecipeListManager()),
    ],
    child: const MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Recipe Buddy';
    return MaterialApp(
      title: appTitle,
      home: MainView(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 242, 235, 243),
        ),
        iconTheme: IconThemeData(size: 32.0),
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1.3)),
          child: child!,
        );
      },
    );
  }
}
