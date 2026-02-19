import 'dart:collection';

import 'package:flutter/material.dart';
import 'ingredient_item.dart';

class IngredientListManager extends ChangeNotifier {
  final List<IngredientItem> _items = [];

  IngredientListManager() {
    _items.add(
      IngredientItem(
        id: 0,
        name: "Vodka",
        mainCategory: "Fluids",
        subCategory: "Alcohol",
      ),
    );
    _items.add(
      IngredientItem(
        id: 1,
        name: "Milk",
        mainCategory: "Fluids",
        subCategory: "Dairy",
        description: "lactose free",
        expire: DateTime.parse("2026-04-08"),
        status: 2,
        inShoppinglist: true,
        isStarred: true,
        amountToBuy: 10,
        buyUnit: "dl",
        currentAmount: 150,
        unit: "ml",
      ),
    );
  }

  UnmodifiableListView<IngredientItem> get items =>
      UnmodifiableListView(_items);

  void add(IngredientItem item) async {
    if (_items.isEmpty) {
      item.id = 0;
    } else {
      item.id = _items.last.id + 1;
    }
    _items.add(item);
    notifyListeners();
  }

  void delete(IngredientItem item) async {
    _items.remove(item);
    notifyListeners();
  }

  void toggleStarred(IngredientItem item) {
    item.isStarred = !item.isStarred;
    notifyListeners();
  }

  // pitäsköhän olla erilliset add ja remove?
  void toggleShoppinglist(
    IngredientItem item,
    double? amountToBuy,
    String? buyUnit,
  ) {
    item.inShoppinglist = !item.inShoppinglist;
    if (amountToBuy != null) {
      item.amountToBuy = amountToBuy;
      if (buyUnit != null) {
        item.buyUnit = buyUnit;
      }
    }
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

      notifyListeners();
    }
  }
}
