import 'package:flutter/material.dart';
import '../../../data/constants.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../data/recipe/recipe_item.dart';
import '../../../data/recipe/recipe_list_manager.dart';
import '../../../data/ingredient/ingredient_list_manager.dart';
import 'input_recipe_view.dart';
import 'single_recipe_view_widgets/info_row.dart';
import 'single_recipe_view_widgets/ingredient_group_section.dart';
import 'single_recipe_view_widgets/cook_step_tile.dart';

class SingleRecipeView extends StatelessWidget {
  final RecipeItem item;
  const SingleRecipeView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeListManager>(
      builder: (context, manager, _) {
        final updatedItem = manager.items.firstWhere(
          (i) => i.id == item.id,
          orElse: () => item,
        );

        return Scaffold(
          appBar: AppBar(
            title: Text("View Recipe"),
            actions: [
              IconButton(
                iconSize: Theme.of(context).iconTheme.size,
                onPressed: () async {
                  final deleted = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InputRecipeView(
                        item: updatedItem,
                        popTwiceOnDelete: true,
                      ),
                    ),
                  );
                  if (deleted == true && context.mounted) {
                    Navigator.pop(context);
                  }
                },
                icon: Icon(Icons.edit),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: SingleRecipeStatefulView(item: updatedItem),
          ),
        );
      },
    );
  }
}

class SingleRecipeStatefulView extends StatefulWidget {
  final RecipeItem item;
  const SingleRecipeStatefulView({super.key, required this.item});

  @override
  State<StatefulWidget> createState() => _SingleRecipeViewState();
}

class _SingleRecipeViewState extends State<SingleRecipeStatefulView> {
  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final manager = Provider.of<IngredientListManager>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // Name + icons row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Icon(
                  Icons.push_pin_rounded,
                  color: item.isPinned ? Colors.deepOrange : Colors.blueGrey,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Icon(
                  Icons.star,
                  color: item.isStarred ? Colors.deepOrange : Colors.blueGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Categories + type row
          Wrap(
            spacing: 8,
            children: [
              item.mainCategory != categoryUnspecified
                  ? Chip(label: Text(item.mainCategory))
                  : Container(),
              item.subCategory != categoryUnspecified
                  ? Chip(label: Text(item.subCategory))
                  : Container(),
              item.recipeType != categoryUnspecified
                  ? Chip(label: Text(item.recipeType))
                  : Container(),
            ],
          ),
          const SizedBox(height: 8),

          // Description
          if (item.description.isNotEmpty) ...[
            Text(
              item.description,
              //style: const TextStyle(color: Colors.blueGrey),
            ),
            const SizedBox(height: 8),
          ],
          const Divider(height: 24),

          // Servings + rating + timestamp
          item.servings != 0
              ? InfoRow(label: "Servings", value: item.servings.toString())
              : Container(),
          InfoRow(label: "Rating", value: item.rating.toString()),
          if (item.timeStamp != null)
            InfoRow(
              label: "Timestamp",
              value: DateFormat("dd.MM.yyyy").format(item.timeStamp!),
            ),

          const Divider(height: 24),

          // Type specific
          if (item is FoodRecipe) ...[
            InfoRow(label: "Prep time", value: "${item.prepTimeMinutes} min"),
            Row(
              children: [
                const Text("Requires deep bowl: "),
                Icon(
                  item.requiresDeepBowl
                      ? Icons.ramen_dining
                      : Icons.dinner_dining,
                  color: item.requiresDeepBowl
                      ? Colors.deepOrange
                      : Colors.blueGrey,
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],

          if (item is CocktailRecipe) ...[
            Row(
              children: [
                const Text("Alcoholic: "),
                Icon(
                  item.isAlcoholic ? Icons.local_bar : Icons.no_drinks,
                  color: item.isAlcoholic ? Colors.deepOrange : Colors.blueGrey,
                ),
              ],
            ),
            InfoRow(label: "ABV", value: "${item.abv}%"),
            if (item.glassType.isNotEmpty)
              InfoRow(label: "Glass", value: item.glassType),
            if (item.method.isNotEmpty)
              InfoRow(label: "Method", value: item.method),
            const SizedBox(height: 8),
          ],

          if (item is FermentRecipe) ...[
            InfoRow(
              label: "Ferment time",
              value: "${item.fermentTimeDays} days",
            ),
            if (item.fermentingStarted != null)
              InfoRow(
                label: "Started",
                value: DateFormat("dd.MM.yyyy").format(item.fermentingStarted!),
              ),
            if (item.fermentReadyDate != null)
              InfoRow(
                label: "Ready date",
                value: DateFormat("dd.MM.yyyy").format(item.fermentReadyDate!),
              ),
            const SizedBox(height: 8),
          ],

          // Ingredient groups
          if (item.ingredientGroups.isNotEmpty) ...[
            const Text(
              "Ingredients",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...item.ingredientGroups.map(
              (group) => IngredientGroupSection(group: group, manager: manager),
            ),
            const Divider(height: 24),
          ],

          // Cook steps
          if (item is FoodRecipe && item.cookSteps.isNotEmpty) ...[
            const Text(
              "Cook Steps",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...item.cookSteps.map((step) => CookStepTile(step: step)),
            const Divider(height: 24),
          ],

          if (item is FermentRecipe && item.cooksteps.isNotEmpty) ...[
            const Text(
              "Steps",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...item.cooksteps.map((step) => CookStepTile(step: step)),
            const Divider(height: 24),
          ],

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
