import 'dart:collection';

import 'package:flutter/material.dart';
import 'recipe_item.dart';

class RecipeListManager extends ChangeNotifier {
  final List<RecipeItem> _items = [];

  RecipeListManager() {
    _items.add(
      RecipeItem(
        id: 0,
        name: "title",
        description: "description",
        mainCategory: "cat1",
        subCategory: "scat1",
      ),
    );
    _items.add(
      RecipeItem(
        id: 1,
        name: "title2",
        description: "description2",
        mainCategory: "cat1",
        subCategory: "scat2",
      ),
    );
  }

  UnmodifiableListView<RecipeItem> get items => UnmodifiableListView(_items);

  void add(RecipeItem item) async {
    if (_items.isEmpty) {
      item.id = 0;
    } else {
      item.id = _items.last.id + 1;
    }
    _items.add(item);
    notifyListeners();
  }
}
