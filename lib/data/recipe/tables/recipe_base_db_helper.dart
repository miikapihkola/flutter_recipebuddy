import 'package:sqflite/sqflite.dart';
import '../recipe_item.dart';

class RecipeBaseTableHelper {
  static const recipeTable = 'recipes';

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $recipeTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        mainCategory TEXT NOT NULL,
        subCategory TEXT NOT NULL,
        recipeType TEXT NOT NULL,
        servings INTEGER NOT NULL,
        isPinned INTEGER NOT NULL,
        rating REAL NOT NULL,
        isStarred INTEGER NOT NULL,
        timeStamp TEXT,
        prepTimeMinutes INTEGER,
        requiresDeepBowl INTEGER,
        isAlcoholic INTEGER,
        abv REAL,
        glassType TEXT,
        method TEXT,
        fermentTimeDays INTEGER,
        fermentingStarted TEXT,
        notifyWhenReady INTEGER
      )
    ''');
  }

  Future<int> insert(Database db, RecipeItem recipe) async {
    return await db.insert(recipeTable, _toMap(recipe));
  }

  Future<void> update(Database db, RecipeItem recipe) async {
    await db.update(
      recipeTable,
      _toMap(recipe),
      where: 'id = ?',
      whereArgs: [recipe.id],
    );
  }

  Future<void> delete(Database db, int recipeId) async {
    await db.delete(recipeTable, where: 'id = ?', whereArgs: [recipeId]);
  }

  Future<List<Map<String, dynamic>>> readAll(Database db) async {
    return await db.query(recipeTable);
  }

  Map<String, dynamic> _toMap(RecipeItem recipe) {
    final map = <String, dynamic>{
      'name': recipe.name,
      'description': recipe.description,
      'mainCategory': recipe.mainCategory,
      'subCategory': recipe.subCategory,
      'recipeType': recipe.recipeType,
      'servings': recipe.servings,
      'isPinned': recipe.isPinned ? 1 : 0,
      'rating': recipe.rating,
      'isStarred': recipe.isStarred ? 1 : 0,
      'timeStamp': recipe.timeStamp?.toIso8601String(),
      'prepTimeMinutes': null,
      'requiresDeepBowl': null,
      'isAlcoholic': null,
      'abv': null,
      'glassType': null,
      'method': null,
      'fermentTimeDays': null,
      'fermentingStarted': null,
      'notifyWhenReady': null,
    };

    if (recipe is FoodRecipe) {
      map['prepTimeMinutes'] = recipe.prepTimeMinutes;
      map['requiresDeepBowl'] = recipe.requiresDeepBowl ? 1 : 0;
    } else if (recipe is CocktailRecipe) {
      map['isAlcoholic'] = recipe.isAlcoholic ? 1 : 0;
      map['abv'] = recipe.abv;
      map['glassType'] = recipe.glassType;
      map['method'] = recipe.method;
    } else if (recipe is FermentRecipe) {
      map['fermentTimeDays'] = recipe.fermentTimeDays;
      map['fermentingStarted'] = recipe.fermentingStarted?.toIso8601String();
      map['notifyWhenReady'] = recipe.notifyWhenReady ? 1 : 0;
    }

    return map;
  }
}
