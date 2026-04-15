import 'package:flutter/material.dart';
import '../../subviews/recipe/input_recipe_view.dart';
import '../../subviews/recipe/single_recipe_view.dart';
import 'package:intl/intl.dart';
import '../../../data/recipe/recipe_list_manager.dart';
import '../../../data/recipe/recipe_item.dart';

Center recipeCard(
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
                //trailing:
                title: Text(
                  item.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Type: ${item.recipeType}"),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SingleRecipeView(item: item),
                              ),
                            );
                          },
                          icon: Icon(Icons.menu_book),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.push_pin_rounded,
                            color: item.isPinned
                                ? Colors.deepOrange
                                : Colors.blueGrey,
                          ),
                        ),
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
                                builder: (context) =>
                                    InputRecipeView(item: item),
                              ),
                            );
                          },
                          icon: Icon(Icons.edit),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsGeometry.fromLTRB(15, 0, 0, 5),
                child: Column(children: [_set(item)]),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Column _set(RecipeItem item) {
  return Column(
    children: [
      // Commons
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              item.timeStamp != null
                  ? DateFormat("dd.MM.yyyy").format(item.timeStamp!)
                  : "",
            ),
          ),
          //Text(item.recipeType),
          item.servings != 0 ? Text("Servings: ${item.servings}") : Container(),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Text("Rating: ${item.rating}"),
          ),
        ],
      ),

      // Type specific fields
      if (item is FoodRecipe) ...[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            item.prepTimeMinutes != 0
                ? Text("Prep time: ${item.prepTimeMinutes} min")
                : Container(),
            Icon(
              item.requiresDeepBowl ? Icons.ramen_dining : Icons.dinner_dining,
            ),
          ],
        ),
      ],

      if (item is CocktailRecipe) ...[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            item.glassType != ""
                ? Text("Glass: ${item.glassType}")
                : Container(),
            item.method != "" ? Text("Method: ${item.method}") : Container(),
            Row(
              children: [
                Icon(item.isAlcoholic ? Icons.local_bar : Icons.no_drinks),
                item.isAlcoholic ? Text("Abv: ${item.abv}") : Container(),
              ],
            ),
          ],
        ),
      ],

      if (item is FermentRecipe) ...[
        Text("Ferment Time in Days: ${item.fermentTimeDays}"),
        Text(
          "Fermenting Started: ${item.fermentingStarted != null ? DateFormat("dd.MM.yyyy").format(item.fermentingStarted!) : "Not set"}",
        ),
        Text(
          "Ferment is Ready Date: ${item.fermentReadyDate != null ? DateFormat("dd.MM.yyyy").format(item.fermentReadyDate!) : "Not set"}",
        ),
      ],

      // Description
      Padding(
        padding: const EdgeInsetsGeometry.symmetric(vertical: 10),
        child: item.description != ""
            ? SizedBox(width: double.infinity, child: Text(item.description))
            : Container(),
      ),
    ],
  );
}
