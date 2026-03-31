import 'package:sqflite/sqflite.dart';
import '../database_provider.dart';
import 'ingredient_item.dart';

class IngredientDbHelper {
  static const ingredientsTable = "ingredients";

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $ingredientsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        mainCategory TEXT NOT NULL,
        subCategory TEXT NOT NULL,
        expire TEXT,
        status INTEGER NOT NULL,
        inShoppinglist INTEGER NOT NULL,
        isStarred INTEGER NOT NULL,
        amountToBuy REAL NOT NULL,
        buyUnit TEXT NOT NULL,
        currentAmount REAL NOT NULL,
        unit TEXT NOT NULL
        )
      ''');
  }

  Future<IngredientItem> create(IngredientItem item) async {
    final db = await DatabaseProvider.instance.database;
    final id = await db.insert(ingredientsTable, _toMap(item));
    item.id = id;
    return item;
  }

  Future<List<IngredientItem>> readAll() async {
    final db = await DatabaseProvider.instance.database;
    final result = await db.query(ingredientsTable);
    return result.map((map) => _fromMap(map)).toList();
  }

  Future<void> update(IngredientItem item) async {
    final db = await DatabaseProvider.instance.database;
    await db.update(
      ingredientsTable,
      _toMap(item),
      where: "id = ?",
      whereArgs: [item.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await DatabaseProvider.instance.database;
    await db.delete(ingredientsTable, where: "id = ?", whereArgs: [id]);
  }

  Future<void> clearIngredientsDb() async {
    final db = await DatabaseProvider.instance.database;
    await db.delete(ingredientsTable);
  }

  Map<String, dynamic> _toMap(IngredientItem item) => {
    "name": item.name,
    "description": item.description,
    "mainCategory": item.mainCategory,
    "subCategory": item.subCategory,
    "expire": item.expire?.toIso8601String(),
    "status": item.status,
    "inShoppinglist": item.inShoppinglist ? 1 : 0,
    "isStarred": item.isStarred ? 1 : 0,
    "amountToBuy": item.amountToBuy,
    "buyUnit": item.buyUnit,
    "currentAmount": item.currentAmount,
    "unit": item.unit,
  };

  IngredientItem _fromMap(Map<String, dynamic> map) => IngredientItem(
    id: map["id"],
    name: map["name"],
    description: map["description"],
    mainCategory: map["mainCategory"],
    subCategory: map["subCategory"],
    expire: map["expire"] != null ? DateTime.parse(map["expire"]) : null,
    status: map["status"],
    inShoppinglist: map["inShoppinglist"] == 1,
    isStarred: map["isStarred"] == 1,
    amountToBuy: map["amountToBuy"],
    buyUnit: map["buyUnit"],
    currentAmount: map["currentAmount"],
    unit: map["unit"],
  );
}
