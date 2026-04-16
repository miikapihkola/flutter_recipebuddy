import 'package:flutter/material.dart';
import 'package:flutter_recipebuddy/views/subviews/ingredient/input_ingredient_update_amounts_view.dart';
import 'package:provider/provider.dart';
import '../../../../data/ingredient/ingredient_item.dart';
import '../../../../data/ingredient/ingredient_list_manager.dart';
import '../../../../data/recipe/recipe_item.dart';
import '../../ingredient/input_ingredient_toshoppinglist_view.dart';

class IngredientGroupSection extends StatelessWidget {
  final RecipeIngredientGroup group;
  const IngredientGroupSection({super.key, required this.group});

  String _resolveName(int ingredientId, IngredientListManager manager) {
    final match = manager.items.where((i) => i.id == ingredientId);
    return match.isNotEmpty ? match.first.name : "Unknown";
  }

  IngredientItem _resolveItem(int ingredientId, IngredientListManager manager) {
    return manager.items.firstWhere((i) => i.id == ingredientId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IngredientListManager>(
      builder: (context, manager, _) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Group header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    group.groupName.isNotEmpty
                        ? Text(
                            group.groupName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        : Container(),
                    if (group.optional) ...[
                      const SizedBox(width: 8),
                      const Chip(
                        label: Text("Optional", style: TextStyle(fontSize: 11)),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),

                // Ingredients
                ...group.recipeIngredients.map(
                  (ri) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "• ${_resolveName(ri.ingredientId, manager)}",
                          ),
                        ),
                        Text(
                          ri.amount == 0 ? ri.unit : "${ri.amount} ${ri.unit}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(
                            Icons.add_shopping_cart,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    InputIngredientToshoppinglistView(
                                      item: _resolveItem(
                                        ri.ingredientId,
                                        manager,
                                      ),
                                      fromRecipe: true,
                                      valueFromRecipe: ri.amount,
                                      unitFromRecipe: ri.unit,
                                    ),
                              ),
                            );
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 28,
                            minHeight: 28,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Color.fromARGB(255, 160, 0, 0),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    InputIngredientUpdateAmountsView(
                                      item: _resolveItem(
                                        ri.ingredientId,
                                        manager,
                                      ),
                                      isAddition: false,
                                      usageAmount: ri.amount,
                                      usageUnit: ri.unit,
                                    ),
                              ),
                            );
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 28,
                            minHeight: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
