import 'package:flutter/material.dart';
import '../../../../../data/constants.dart';
import '../../../../../data/recipe/recipe_item.dart';
import '../../../../components/singleComponents/custom_dropdownunit.dart';

class InputRecipeIngredientRow extends StatefulWidget {
  final RecipeIngredient recipeIngredient;
  final ValueChanged<RecipeIngredient> onChanged;
  final VoidCallback onRemove;
  final String ingredientName;

  const InputRecipeIngredientRow({
    super.key,
    required this.recipeIngredient,
    required this.ingredientName,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  State<InputRecipeIngredientRow> createState() =>
      _InputRecipeIngredientRowState();
}

class _InputRecipeIngredientRowState extends State<InputRecipeIngredientRow> {
  late double _amount;
  late String _unit;
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amount = widget.recipeIngredient.amount;
    _unit = widget.recipeIngredient.unit;
    _amountController = TextEditingController(
      text: _amount == 0 ? "" : _amount.toString(),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _notify() {
    widget.onChanged(
      RecipeIngredient(
        id: widget.recipeIngredient.id,
        recipeGroupId: widget.recipeIngredient.recipeGroupId,
        ingredientId: widget.recipeIngredient.ingredientId,
        amount: _amount,
        unit: _unit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Ingredient name
          Expanded(
            flex: 4,
            child: Text(
              widget.ingredientName,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              textScaler: TextScaler.linear(1.2),
            ),
          ),
          const SizedBox(width: 8),

          // Amount field
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                hintText: "Amt.",
                //isDense: true,
                //border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _amount = double.tryParse(value) ?? 0;
                _notify();
              },
            ),
          ),
          const SizedBox(width: 8),

          // Unit dropdown
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CustomDropdownUnit(
                value: _unit,
                list: unitsList,
                onChanged: (value) {
                  setState(() => _unit = value ?? _unit);
                  _notify();
                },
              ),
            ),
          ),
          const SizedBox(width: 2),

          // Remove button
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: widget.onRemove,
            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
