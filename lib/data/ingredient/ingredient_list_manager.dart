import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_recipebuddy/data/recipe/tables/recipe_ingredient_db_helper.dart';
import 'ingredient_db_helper.dart';
import 'ingredient_item.dart';
import '../notification_helper.dart';
import '../database_provider.dart';

class IngredientListManager extends ChangeNotifier {
  final List<IngredientItem> _items = [];
  final _db = IngredientDbHelper();

  IngredientListManager() {
    _loadFromDb();
  }

  UnmodifiableListView<IngredientItem> get items =>
      UnmodifiableListView(_items);

  Future<void> _loadFromDb() async {
    final items = await _db.readAll();
    _items.addAll(items);
    await _rescheduleNotifications();
    notifyListeners();
  }

  Future<void> _rescheduleNotifications() async {
    await NotificationHelper.instance.rescheduleAllNotifications(_items);
  }

  // Main features

  Future<int> add(IngredientItem item) async {
    final created = await _db.create(item);
    _items.add(item);
    await _rescheduleNotifications();
    notifyListeners();
    return created.id;
  }

  Future<void> delete(IngredientItem item) async {
    //cascade
    final db = await DatabaseProvider.instance.database;
    await RecipeIngredientTableHelper().deleteByIngredientId(db, item.id);

    //delete
    await _db.delete(item.id);
    _items.remove(item);
    await _rescheduleNotifications();
    notifyListeners();
  }

  Future<void> update(IngredientItem item) async {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index == -1) return;

    await _db.update(item);
    _items[index] = item;
    await _rescheduleNotifications();
    notifyListeners();
  }

  // Shorthand features

  Future<void> toggleStarred(IngredientItem item) async {
    item.isStarred = !item.isStarred;
    await _db.update(item);
    notifyListeners();
  }

  Future<void> bumpStatus(IngredientItem item) async {
    if (item.status == 0) {
      item.status = 3;
    } else if (item.status < 4 && item.status > 0) {
      item.status--;
    } else {
      item.status = 0;
    }
    await _db.update(item);
    notifyListeners();
  }

  Future<void> removeFromShoppinglist(IngredientItem item) async {
    item.inShoppinglist = false;
    await _db.update(item);
    notifyListeners();
  }
}
