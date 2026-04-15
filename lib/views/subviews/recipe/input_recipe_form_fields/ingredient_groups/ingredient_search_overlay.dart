import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../data/ingredient/ingredient_item.dart';
import '../../../../../data/ingredient/ingredient_list_manager.dart';

class IngredientSearchOverlay extends StatefulWidget {
  final ValueChanged<IngredientItem> onIngredientSelected;
  final ValueChanged<String> onCreateNew;
  final VoidCallback onCancel;

  const IngredientSearchOverlay({
    super.key,
    required this.onIngredientSelected,
    required this.onCreateNew,
    required this.onCancel,
  });

  @override
  State<IngredientSearchOverlay> createState() =>
      _IngredientSearchOverlayState();
}

class _IngredientSearchOverlayState extends State<IngredientSearchOverlay> {
  final TextEditingController _searchController = TextEditingController();
  String _query = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<IngredientItem> _getFiltered(List<IngredientItem> all) {
    if (_query.isEmpty) return all.take(6).toList();
    final lower = _query.toLowerCase();
    return all
        .where((i) => i.name.toLowerCase().contains(lower))
        .take(6)
        .toList();
  }

  bool _exactMatchExists(List<IngredientItem> all) {
    return all.any((i) => i.name.toLowerCase() == _query.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    // Block all interaction outside the overlay
    return Stack(
      children: [
        // Scrim — blocks scrolling and taps outside
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onCancel,
            child: Container(color: Colors.black45),
          ),
        ),

        // Floating search card — centered
        Center(
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              constraints: const BoxConstraints(maxHeight: 400),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Consumer<IngredientListManager>(
                builder: (context, manager, _) {
                  final filtered = _getFiltered(manager.items);
                  final showCreateNew =
                      _query.isNotEmpty && !_exactMatchExists(manager.items);

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Search field
                      TextField(
                        controller: _searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Search ingredient...",
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _query.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _query = "");
                                  },
                                )
                              : null,
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: (value) => setState(() => _query = value),
                      ),
                      const SizedBox(height: 8),

                      // Results list
                      Flexible(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            // Existing ingredients
                            ...filtered.map(
                              (ingredient) => ListTile(
                                dense: true,
                                leading: const Icon(Icons.kitchen_outlined),
                                title: Text(ingredient.name),
                                subtitle:
                                    ingredient.mainCategory != "Unspecified"
                                    ? Text(
                                        ingredient.mainCategory,
                                        style: const TextStyle(fontSize: 11),
                                      )
                                    : null,
                                onTap: () =>
                                    widget.onIngredientSelected(ingredient),
                              ),
                            ),

                            // "Create new" option
                            if (showCreateNew)
                              ListTile(
                                dense: true,
                                leading: const Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.green,
                                ),
                                title: Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(text: '+ Create "'),
                                      TextSpan(
                                        text: _query,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const TextSpan(text: '" as new'),
                                    ],
                                  ),
                                ),
                                onTap: () => widget.onCreateNew(_query),
                              ),

                            // Empty state
                            if (filtered.isEmpty && !showCreateNew)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Center(
                                  child: Text(
                                    "No ingredients found",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      const Divider(height: 16),

                      // Cancel button
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: widget.onCancel,
                          child: const Text("Cancel"),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
