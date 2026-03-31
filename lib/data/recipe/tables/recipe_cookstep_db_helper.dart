import 'package:sqflite/sqflite.dart';
import '../recipe_item.dart';

class RecipeCookStepTableHelper {
  static const cookStepTable = 'recipe_cook_steps';

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $cookStepTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recipeId INTEGER NOT NULL,
        "order" INTEGER NOT NULL,
        durationMinutes INTEGER NOT NULL,
        type TEXT NOT NULL,
        description TEXT NOT NULL,
        FOREIGN KEY (recipeId) REFERENCES recipes(id)
      )
    ''');
  }

  Future<void> save(Database db, RecipeItem recipe) async {
    List<CookStep> steps = [];
    if (recipe is FoodRecipe) steps = recipe.cookSteps;
    if (recipe is FermentRecipe) steps = recipe.cooksteps;

    for (final step in steps) {
      step.recipeId = recipe.id;
      step.id = await db.insert(cookStepTable, {
        'recipeId': step.recipeId,
        'order': step.order,
        'durationMinutes': step.durationMinutes,
        'type': step.type,
        'description': step.description,
      });
    }
  }

  Future<void> deleteForRecipe(Database db, int recipeId) async {
    await db.delete(
      cookStepTable,
      where: 'recipeId = ?',
      whereArgs: [recipeId],
    );
  }

  Future<List<CookStep>> loadForRecipe(Database db, int recipeId) async {
    final results = await db.query(
      cookStepTable,
      where: 'recipeId = ?',
      whereArgs: [recipeId],
      orderBy: '"order" ASC',
    );
    return results
        .map(
          (map) => CookStep(
            id: map['id'] as int,
            recipeId: map['recipeId'] as int,
            order: map['order'] as int,
            durationMinutes: map['durationMinutes'] as int,
            type: map['type'] as String,
            description: map['description'] as String,
          ),
        )
        .toList();
  }
}
