import 'package:sqflite/sqflite.dart';
import '../recipe_item.dart';
import 'recipe_ingredient_db_helper.dart';

class RecipeIngredientGroupTableHelper {
  static const ingredientGroupTable = 'recipe_ingredient_groups';
  final _ingredientHelper = RecipeIngredientTableHelper();

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $ingredientGroupTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recipeId INTEGER NOT NULL,
        groupName TEXT NOT NULL,
        optional INTEGER NOT NULL,
        FOREIGN KEY (recipeId) REFERENCES recipes(id)
      )
    ''');
  }

  Future<void> save(Database db, RecipeItem recipe) async {
    for (final group in recipe.ingredientGroups) {
      group.recipeId = recipe.id;
      group.id = await db.insert(ingredientGroupTable, {
        'recipeId': group.recipeId,
        'groupName': group.groupName,
        'optional': group.optional ? 1 : 0,
      });
      await _ingredientHelper.save(db, group);
    }
  }

  Future<void> deleteForRecipe(Database db, int recipeId) async {
    final groups = await db.query(
      ingredientGroupTable,
      where: 'recipeId = ?',
      whereArgs: [recipeId],
    );
    for (final group in groups) {
      await _ingredientHelper.deleteForGroup(db, group['id'] as int);
    }
    await db.delete(
      ingredientGroupTable,
      where: 'recipeId = ?',
      whereArgs: [recipeId],
    );
  }

  Future<List<RecipeIngredientGroup>> loadForRecipe(
    Database db,
    int recipeId,
  ) async {
    final groupResults = await db.query(
      ingredientGroupTable,
      where: 'recipeId = ?',
      whereArgs: [recipeId],
    );
    final groups = <RecipeIngredientGroup>[];
    for (final gMap in groupResults) {
      final ingredients = await _ingredientHelper.loadForGroup(
        db,
        gMap['id'] as int,
      );
      groups.add(
        RecipeIngredientGroup(
          id: gMap['id'] as int,
          recipeId: gMap['recipeId'] as int,
          groupName: gMap['groupName'] as String,
          optional: gMap['optional'] == 1,
          recipeIngredients: ingredients,
        ),
      );
    }
    return groups;
  }
}
