import 'package:flutter/material.dart';
import '/views/main_view.dart';
import 'package:provider/provider.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (context) {
      //var model = TodoListManager();
      //return model;
    },
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
        buttonTheme: ButtonThemeData(height: 70, minWidth: 40),
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1.2)),
          child: child!,
        );
      },
    );
  }
}
