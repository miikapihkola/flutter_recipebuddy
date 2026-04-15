import 'package:flutter/material.dart';
import 'package:flutter_recipebuddy/views/subviews/recipe/input_recipe_view.dart';
import 'package:intl/intl.dart';
import '../../../data/recipe/recipe_list_manager.dart';
import '../../../data/recipe/recipe_item.dart';

Center recipeCardTest(
  RecipeItem item,
  BuildContext context,
  RecipeListManager manager,
) {
  return Center(
    child: Card(
      child: Column(
        children: <Widget>[
          Column(
            children: [
              ListTile(
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        manager.toggleStarred(item);
                      },
                      icon: Icon(
                        Icons.star,
                        color: item.isStarred
                            ? Colors.deepOrange
                            : Colors.blueGrey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InputRecipeView(item: item),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),
                title: Text(
                  item.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
              Padding(
                padding: const EdgeInsetsGeometry.fromLTRB(15, 0, 0, 5),
                child: Column(children: [_placeholderSet(item)]),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Column _placeholderSet(RecipeItem item) {
  return Column(
    children: [
      Text("desc: ${item.description}"),
      Text("maincat: ${item.mainCategory}"),
      Text("subcat: ${item.subCategory}"),
      Text("id: ${item.id}"),
      Text("recipetype: ${item.recipeType}"),
      Text("pinned: ${item.isPinned}"),
      Text("starred: ${item.isStarred}"),
      Text("rating: ${item.rating}"),
      Text("servings: ${item.servings}"),
      Text(
        "timestamp: ${item.timeStamp != null ? DateFormat("dd.MM.yyyy").format(item.timeStamp!) : "Not set"}",
      ),

      // Ingredient groups
      Text("--- Ingredient Groups ---"),
      ...item.ingredientGroups.map(
        (group) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Group: ${group.groupName} (optional: ${group.optional})"),
            ...group.recipeIngredients.map(
              (ingredient) => Text(
                "  ingredientId: ${ingredient.ingredientId} "
                "amount: ${ingredient.amount} "
                "unit: ${ingredient.unit}",
              ),
            ),
          ],
        ),
      ),

      // Type specific fields
      if (item is FoodRecipe) ...[
        Text("--- Food ---"),
        Text("prepTime: ${item.prepTimeMinutes}"),
        Text("requiresDeepBowl: ${item.requiresDeepBowl}"),
        Text("--- Cook Steps ---"),
        ...item.cookSteps.map(
          (step) => Text(
            "order: ${step.order} "
            "type: ${step.type} "
            "duration: ${step.durationMinutes}min "
            "desc: ${step.description}",
          ),
        ),
      ],

      if (item is CocktailRecipe) ...[
        Text("--- Cocktail ---"),
        Text("isAlcoholic: ${item.isAlcoholic}"),
        Text("abv: ${item.abv}"),
        Text("glassType: ${item.glassType}"),
        Text("method: ${item.method}"),
      ],

      if (item is FermentRecipe) ...[
        Text("--- Ferment ---"),
        Text("fermentTimeDays: ${item.fermentTimeDays}"),
        Text(
          "fermentingStarted: ${item.fermentingStarted != null ? DateFormat("dd.MM.yyyy").format(item.fermentingStarted!) : "Not set"}",
        ),
        Text("notifyWhenReady: ${item.notifyWhenReady}"),
        Text(
          "fermentReadyDate: ${item.fermentReadyDate != null ? DateFormat("dd.MM.yyyy").format(item.fermentReadyDate!) : "Not set"}",
        ),
        Text("--- Cook Steps ---"),
        ...item.cooksteps.map(
          (step) => Text(
            "order: ${step.order} "
            "type: ${step.type} "
            "duration: ${step.durationMinutes}min "
            "desc: ${step.description}",
          ),
        ),
      ],
    ],
  );
}
