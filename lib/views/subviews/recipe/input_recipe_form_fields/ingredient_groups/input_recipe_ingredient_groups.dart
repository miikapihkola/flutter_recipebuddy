import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../data/recipe/recipe_item.dart';
import '../../../../../data/ingredient/ingredient_item.dart';
import '../../../../../data/ingredient/ingredient_list_manager.dart';
import '../../../../../data/constants.dart';
import 'input_recipe_ingredient_group_tile.dart';

class InputRecipeIngredientGroups extends StatefulWidget {
  final List<RecipeIngredientGroup> ingredientGroups;
  final ValueChanged<List<RecipeIngredientGroup>> onChanged;

  const InputRecipeIngredientGroups({
    super.key,
    required this.ingredientGroups,
    required this.onChanged,
  });

  @override
  State<InputRecipeIngredientGroups> createState() =>
      InputRecipeIngredientGroupsState();
}

class InputRecipeIngredientGroupsState
    extends State<InputRecipeIngredientGroups> {
  int _groupKeyCounter = 0;
  final Map<RecipeIngredientGroup, int> _groupKeys = {};

  late List<RecipeIngredientGroup> _groups;

  // Pending new ingredients: keyed by a temporary negative id
  // so we can identify them before DB insert
  final List<IngredientItem> _pendingNewIngredients = [];
  int _tempIdCounter = -1;

  @override
  void initState() {
    super.initState();
    _groups = List.from(widget.ingredientGroups);
    for (final group in _groups) {
      _groupKeys[group] = _groupKeyCounter++;
    }
  }

  void _notify() {
    widget.onChanged(_groups);
  }

  void _addGroup() {
    final newGroup = RecipeIngredientGroup(
      id: 0,
      recipeId: 0,
      groupName: "",
      optional: false,
      recipeIngredients: [],
    );
    setState(() {
      _groupKeys[newGroup] = _groupKeyCounter++;
      _groups.add(newGroup);
    });
    _notify();
  }

  void _removeGroup(int index) {
    setState(() {
      _groupKeys.remove(_groups[index]);
      _groups.removeAt(index);
    });
    _notify();
  }

  void _updateGroup(int index, RecipeIngredientGroup updated) {
    setState(() {
      final oldGroup = _groups[index];
      _groupKeys[updated] = _groupKeys[oldGroup]!;
      _groupKeys.remove(oldGroup);
      _groups[index] = updated;
    });
    _notify();
  }

  /// Called when user picks "+ Create X as new" in search
  /// Returns a temp IngredientItem with a negative id
  IngredientItem _createPendingIngredient(String name) {
    final temp = IngredientItem(
      id: _tempIdCounter--,
      name: name,
      mainCategory: categoryUnspecified,
      subCategory: categoryUnspecified,
    );
    _pendingNewIngredients.add(temp);
    return temp;
  }

  /// Call this before saving the recipe.
  /// Inserts all pending ingredients, updates RecipeIngredient refs with real ids.
  Future<void> flushPendingIngredients(BuildContext context) async {
    if (_pendingNewIngredients.isEmpty) return;

    final manager = Provider.of<IngredientListManager>(context, listen: false);

    // Map tempId -> realId
    final Map<int, int> idMap = {};
    for (final pending in _pendingNewIngredients) {
      final tempId = pending.id;
      final realId = await manager.add(pending);
      idMap[tempId] = realId;
    }

    // Patch all RecipeIngredients that reference a temp id
    for (final group in _groups) {
      for (final ri in group.recipeIngredients) {
        if (idMap.containsKey(ri.ingredientId)) {
          ri.ingredientId = idMap[ri.ingredientId]!;
        }
      }
    }

    _pendingNewIngredients.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: Text(
              "Ingredient Groups:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        ..._groups.asMap().entries.map((entry) {
          final index = entry.key;
          final group = entry.value;
          return InputRecipeIngredientGroupTile(
            key: ValueKey(_groupKeys[group]),
            group: group,
            onChanged: (updated) => _updateGroup(index, updated),
            onRemove: () => _removeGroup(index),
            onCreatePendingIngredient: _createPendingIngredient,
          );
        }),
        const SizedBox(height: 8),
        Center(
          child: OutlinedButton.icon(
            onPressed: _addGroup,
            icon: const Icon(Icons.add),
            label: const Text("Add Ingredient Group"),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
