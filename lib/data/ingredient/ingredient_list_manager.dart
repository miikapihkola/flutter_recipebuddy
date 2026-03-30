import 'dart:collection';

import 'package:flutter/material.dart';
import 'ingredient_db_helper.dart';
import 'ingredient_item.dart';
import '../notification_helper.dart';

class IngredientListManager extends ChangeNotifier {
  final List<IngredientItem> _items = [];
  final _db = IngredientDbHelper();

  IngredientListManager() {
    _loadFromDb();
  }

  Future<void> _loadFromDb() async {
    final items = await _db.readAll();
    _items.addAll(items);
    await _rescheduleNotifications();
    notifyListeners();
  }

  Future<void> _rescheduleNotifications() async {
    await NotificationHelper.instance.rescheduleAllNotifications(_items);
  }

  UnmodifiableListView<IngredientItem> get items =>
      UnmodifiableListView(_items);

  void add(IngredientItem item) async {
    await _db.create(item);
    _items.add(item);
    await _rescheduleNotifications();
    notifyListeners();
  }

  void delete(IngredientItem item) async {
    await _db.delete(item.id);
    _items.remove(item);
    await _rescheduleNotifications();
    notifyListeners();
  }

  void toggleStarred(IngredientItem item) async {
    item.isStarred = !item.isStarred;
    await _db.update(item);
    notifyListeners();
  }

  void bumpStatus(IngredientItem item) async {
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

  void removeFromShoppinglist(IngredientItem item) async {
    item.inShoppinglist = false;
    await _db.update(item);
    notifyListeners();
  }

  void update(IngredientItem item) async {
    IngredientItem? oldItem;

    for (IngredientItem i in _items) {
      if (i.id == item.id) {
        oldItem = i;
        break;
      }
    }

    if (oldItem != null) {
      oldItem.name = item.name;
      oldItem.mainCategory = item.mainCategory;
      oldItem.subCategory = item.subCategory;
      oldItem.description = item.description;
      oldItem.expire = item.expire;
      oldItem.status = item.status;
      oldItem.inShoppinglist = item.inShoppinglist;
      oldItem.isStarred = item.isStarred;
      oldItem.currentAmount = item.currentAmount;
      oldItem.unit = item.unit;
      oldItem.amountToBuy = item.amountToBuy;
      oldItem.buyUnit = item.buyUnit;

      await _db.update(oldItem);
      await _rescheduleNotifications();
      notifyListeners();
    }
  }
}
