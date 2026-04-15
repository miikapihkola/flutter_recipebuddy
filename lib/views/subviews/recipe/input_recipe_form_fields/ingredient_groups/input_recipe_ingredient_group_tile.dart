import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../data/ingredient/ingredient_list_manager.dart';
import '../../../../../data/recipe/recipe_item.dart';
import '../../../../../data/ingredient/ingredient_item.dart';
import 'input_recipe_ingredient_row.dart';
import 'ingredient_search_overlay.dart';

class InputRecipeIngredientGroupTile extends StatefulWidget {
  final RecipeIngredientGroup group;
  final ValueChanged<RecipeIngredientGroup> onChanged;
  final VoidCallback onRemove;
  final IngredientItem Function(String name) onCreatePendingIngredient;

  const InputRecipeIngredientGroupTile({
    super.key,
    required this.group,
    required this.onChanged,
    required this.onRemove,
    required this.onCreatePendingIngredient,
  });

  @override
  State<InputRecipeIngredientGroupTile> createState() =>
      _InputRecipeIngredientGroupTileState();
}

class _InputRecipeIngredientGroupTileState
    extends State<InputRecipeIngredientGroupTile> {
  final Map<int, String> _ingredientNames = {};
  late String _groupName;
  late bool _optional;
  late List<RecipeIngredient> _ingredients;
  bool _isExpanded = true;

  // Overlay state
  OverlayEntry? _overlayEntry;
  bool _searchOpen = false;

  // Temp counter for RecipeIngredient ids (0 until saved)
  int _tempRiId = 0;

  bool _namesInitialized = false;

  @override
  void initState() {
    super.initState();
    _groupName = widget.group.groupName;
    _optional = widget.group.optional;
    _ingredients = List.from(widget.group.recipeIngredients);

    final manager = Provider.of<IngredientListManager>(context, listen: false);
    for (final ri in _ingredients) {
      final match = manager.items.where((i) => i.id == ri.ingredientId);
      if (match.isNotEmpty) {
        _ingredientNames[ri.ingredientId] = match.first.name;
      } else {
        _ingredientNames[ri.ingredientId] = "Unknown";
      }
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _notify() {
    widget.onChanged(
      RecipeIngredientGroup(
        id: widget.group.id,
        recipeId: widget.group.recipeId,
        groupName: _groupName,
        optional: _optional,
        recipeIngredients: _ingredients,
      ),
    );
  }

  void _openSearch() {
    if (_searchOpen) return;
    setState(() => _searchOpen = true);

    _overlayEntry = OverlayEntry(
      builder: (context) => IngredientSearchOverlay(
        onIngredientSelected: (ingredient) {
          _closeSearch();
          _addIngredient(ingredient);
        },
        onCreateNew: (name) {
          _closeSearch();
          final pending = widget.onCreatePendingIngredient(name);
          _addIngredient(pending);
        },
        onCancel: _closeSearch,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeSearch() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted && _searchOpen) setState(() => _searchOpen = false);
  }

  void _addIngredient(IngredientItem ingredient) {
    setState(() {
      _ingredientNames[ingredient.id] = ingredient.name;
      _ingredients.add(
        RecipeIngredient(
          id: _tempRiId++,
          recipeGroupId: widget.group.id,
          ingredientId: ingredient.id,
          amount: 0,
          unit: ingredient.unit, // defaults to ingredient's own unit
        ),
      );
    });
    _notify();
  }

  void _removeIngredient(int index) {
    setState(() => _ingredients.removeAt(index));
    _notify();
  }

  void _updateIngredient(int index, RecipeIngredient updated) {
    setState(() => _ingredients[index] = updated);
    _notify();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_namesInitialized) {
      final manager = Provider.of<IngredientListManager>(
        context,
        listen: false,
      );
      for (final ri in _ingredients) {
        final match = manager.items.where((i) => i.id == ri.ingredientId);
        _ingredientNames[ri.ingredientId] = match.isNotEmpty
            ? match.first.name
            : "Unknown";
      }
      _namesInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          // --- Group header ---
          ListTile(
            leading: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () => setState(() => _isExpanded = !_isExpanded),
            ),
            title: TextFormField(
              initialValue: _groupName,
              decoration: const InputDecoration(
                hintText: "Group Name",
                border: InputBorder.none,
              ),
              onChanged: (value) {
                _groupName = value;
                _notify();
              },
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Opt."),
                Checkbox(
                  value: _optional,
                  onChanged: (value) {
                    setState(() => _optional = value ?? false);
                    _notify();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: widget.onRemove,
                ),
              ],
            ),
          ),

          // --- Ingredient list + add button ---
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                children: [
                  if (_ingredients.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "No ingredients yet",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ..._ingredients.asMap().entries.map((entry) {
                    final index = entry.key;
                    final ri = entry.value;
                    return InputRecipeIngredientRow(
                      key: ValueKey(index),
                      recipeIngredient: ri,
                      ingredientName:
                          _ingredientNames[ri.ingredientId] ?? "Unkown",
                      onChanged: (updated) => _updateIngredient(index, updated),
                      onRemove: () => _removeIngredient(index),
                    );
                  }),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: _searchOpen ? _closeSearch : _openSearch,
                      icon: Icon(_searchOpen ? Icons.close : Icons.add),
                      label: Text(_searchOpen ? "Cancel" : "Add Ingredient"),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
