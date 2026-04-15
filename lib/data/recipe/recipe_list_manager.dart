import 'dart:collection';
import 'package:flutter/material.dart';
import 'recipe_item.dart';
import 'recipe_db_helper.dart';

class RecipeListManager extends ChangeNotifier {
  final List<RecipeItem> _items = [];
  final _db = RecipeTableHelper();

  RecipeListManager() {
    _loadFromDb();
  }

  UnmodifiableListView<RecipeItem> get items => UnmodifiableListView(_items);

  Future<void> _loadFromDb() async {
    final items = await _db.readAll();
    _items.addAll(items);
    notifyListeners();
  }

  // Main features

  Future<void> add(RecipeItem item) async {
    await _db.create(item);
    _items.add(item);
    notifyListeners();
  }

  Future<void> delete(RecipeItem item) async {
    await _db.delete(item.id);
    _items.remove(item);
    notifyListeners();
  }

  Future<void> update(RecipeItem item) async {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index == -1) return;

    await _db.update(item);
    _items[index] = item;
    notifyListeners();
  }

  // Shorthand features

  Future<void> toggleStarred(RecipeItem item) async {
    item.isStarred = !item.isStarred;
    await _db.update(item);
    notifyListeners();
  }

  Future<void> togglePinned(RecipeItem item) async {
    item.isPinned = !item.isPinned;
    await _db.update(item);
    notifyListeners();
  }

  /*
  // example how to modify nested objects as shorthand
  Future<void> clearCookStepDescriptionExample(RecipeItem recipe, CookStep step) async{
    step.description = "";
    await _db.update(recipe);
    notifyListeners();
  }
  */
}
