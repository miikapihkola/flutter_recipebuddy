import 'package:sqflite/sqflite.dart';
import '../recipe_item.dart';

class RecipeIngredientTableHelper {
  static const recipeIngredientTable = 'recipe_ingredients';

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $recipeIngredientTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recipeGroupId INTEGER NOT NULL,
        ingredientId INTEGER NOT NULL,
        amount REAL NOT NULL,
        unit TEXT NOT NULL,
        FOREIGN KEY (recipeGroupId) REFERENCES recipe_ingredient_groups(id)
      )
    ''');
  }

  Future<void> save(Database db, RecipeIngredientGroup group) async {
    for (final ingredient in group.recipeIngredients) {
      ingredient.recipeGroupId = group.id;
      ingredient.id = await db.insert(recipeIngredientTable, {
        'recipeGroupId': ingredient.recipeGroupId,
        'ingredientId': ingredient.ingredientId,
        'amount': ingredient.amount,
        'unit': ingredient.unit,
      });
    }
  }

  Future<void> deleteForGroup(Database db, int groupId) async {
    await db.delete(
      recipeIngredientTable,
      where: 'recipeGroupId = ?',
      whereArgs: [groupId],
    );
  }

  Future<List<RecipeIngredient>> loadForGroup(Database db, int groupId) async {
    final results = await db.query(
      recipeIngredientTable,
      where: 'recipeGroupId = ?',
      whereArgs: [groupId],
    );
    return results
        .map(
          (map) => RecipeIngredient(
            id: map['id'] as int,
            recipeGroupId: map['recipeGroupId'] as int,
            ingredientId: map['ingredientId'] as int,
            amount: map['amount'] as double,
            unit: map['unit'] as String,
          ),
        )
        .toList();
  }
}
