import 'package:sqflite/sqflite.dart';
import '../database_provider.dart';
import 'recipe_item.dart';
import 'tables/recipe_base_db_helper.dart';
import 'tables/recipe_cookstep_db_helper.dart';
import 'tables/recipe_ingredient_db_helper.dart';
import 'tables/recipe_ingredientgroup_db_helper.dart';

class RecipeTableHelper {
  final _baseHelper = RecipeBaseTableHelper();
  final _groupHelper = RecipeIngredientGroupTableHelper();
  final _cookStepHelper = RecipeCookStepTableHelper();

  static Future<void> createTable(Database db) async {
    await RecipeBaseTableHelper.createTable(db);
    await RecipeIngredientGroupTableHelper.createTable(db);
    await RecipeIngredientTableHelper.createTable(db);
    await RecipeCookStepTableHelper.createTable(db);
  }

  Future<RecipeItem> create(RecipeItem recipe) async {
    final db = await DatabaseProvider.instance.database;
    recipe.id = await _baseHelper.insert(db, recipe);
    await _groupHelper.save(db, recipe);
    await _cookStepHelper.save(db, recipe);
    return recipe;
  }

  Future<List<RecipeItem>> readAll() async {
    final db = await DatabaseProvider.instance.database;
    final maps = await _baseHelper.readAll(db);
    final recipes = <RecipeItem>[];
    for (final map in maps) {
      final id = map['id'] as int;
      final groups = await _groupHelper.loadForRecipe(db, id);
      final steps = await _cookStepHelper.loadForRecipe(db, id);
      recipes.add(_fromMap(map, groups, steps));
    }
    return recipes;
  }

  Future<void> update(RecipeItem recipe) async {
    final db = await DatabaseProvider.instance.database;
    await _baseHelper.update(db, recipe);
    await _groupHelper.deleteForRecipe(db, recipe.id);
    await _cookStepHelper.deleteForRecipe(db, recipe.id);
    await _groupHelper.save(db, recipe);
    await _cookStepHelper.save(db, recipe);
  }

  Future<void> delete(int recipeId) async {
    final db = await DatabaseProvider.instance.database;
    await _cookStepHelper.deleteForRecipe(db, recipeId);
    await _groupHelper.deleteForRecipe(db, recipeId);
    await _baseHelper.delete(db, recipeId);
  }

  RecipeItem _fromMap(
    Map<String, dynamic> map,
    List<RecipeIngredientGroup> groups,
    List<CookStep> steps,
  ) {
    final type = map['recipeType'] as String;

    switch (type) {
      case 'Food':
        return FoodRecipe(
            id: map['id'] as int,
            name: map['name'] as String,
            description: map['description'] as String,
            mainCategory: map['mainCategory'] as String,
            subCategory: map['subCategory'] as String,
            prepTimeMinutes: map['prepTimeMinutes'] as int? ?? 0,
            requiresDeepBowl: map['requiresDeepBowl'] == 1,
            cookSteps: steps,
          )
          ..ingredientGroups = groups
          ..isPinned = map['isPinned'] == 1
          ..isStarred = map['isStarred'] == 1
          ..rating = (map['rating'] as num).toDouble()
          ..timeStamp = map['timeStamp'] != null
              ? DateTime.parse(map['timeStamp'] as String)
              : null;

      case 'Cocktail':
        return CocktailRecipe(
            id: map['id'] as int,
            name: map['name'] as String,
            description: map['description'] as String,
            mainCategory: map['mainCategory'] as String,
            subCategory: map['subCategory'] as String,
            isAlcoholic: map['isAlcoholic'] == 1,
            abv: (map['abv'] as num?)?.toDouble() ?? 0,
            glassType: map['glassType'] as String? ?? '',
            method: map['method'] as String? ?? '',
          )
          ..ingredientGroups = groups
          ..isPinned = map['isPinned'] == 1
          ..isStarred = map['isStarred'] == 1
          ..rating = (map['rating'] as num).toDouble()
          ..timeStamp = map['timeStamp'] != null
              ? DateTime.parse(map['timeStamp'] as String)
              : null;

      case 'Ferment':
        return FermentRecipe(
            id: map['id'] as int,
            name: map['name'] as String,
            description: map['description'] as String,
            mainCategory: map['mainCategory'] as String,
            subCategory: map['subCategory'] as String,
            fermentTimeDays: map['fermentTimeDays'] as int? ?? 0,
            fermentingStarted: map['fermentingStarted'] != null
                ? DateTime.parse(map['fermentingStarted'] as String)
                : null,
            notifyWhenReady: map['notifyWhenReady'] == 1,
            cooksteps: steps,
          )
          ..ingredientGroups = groups
          ..isPinned = map['isPinned'] == 1
          ..isStarred = map['isStarred'] == 1
          ..rating = (map['rating'] as num).toDouble()
          ..timeStamp = map['timeStamp'] != null
              ? DateTime.parse(map['timeStamp'] as String)
              : null;

      default:
        return RecipeItem(
            id: map['id'] as int,
            name: map['name'] as String,
            description: map['description'] as String,
            mainCategory: map['mainCategory'] as String,
            subCategory: map['subCategory'] as String,
          )
          ..ingredientGroups = groups
          ..isPinned = map['isPinned'] == 1
          ..isStarred = map['isStarred'] == 1
          ..rating = (map['rating'] as num).toDouble()
          ..timeStamp = map['timeStamp'] != null
              ? DateTime.parse(map['timeStamp'] as String)
              : null;
    }
  }
}
