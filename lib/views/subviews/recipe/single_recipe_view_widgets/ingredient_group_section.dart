import 'package:flutter/material.dart';
import '../../../../data/ingredient/ingredient_list_manager.dart';
import '../../../../data/recipe/recipe_item.dart';

class IngredientGroupSection extends StatelessWidget {
  final RecipeIngredientGroup group;
  final IngredientListManager manager;
  const IngredientGroupSection({
    super.key,
    required this.group,
    required this.manager,
  });

  String _resolveName(int ingredientId) {
    final match = manager.items.where((i) => i.id == ingredientId);
    return match.isNotEmpty ? match.first.name : "Unknown";
  }

  @override
  Widget build(BuildContext context) {
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
                    Expanded(child: Text("• ${_resolveName(ri.ingredientId)}")),
                    Text(
                      ri.amount == 0 ? ri.unit : "${ri.amount} ${ri.unit}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        color: Color.fromARGB(255, 160, 0, 0),
                      ),
                      onPressed: () {
                        // TODO: reduce ingredient amount
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
  }
}
