import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/ingredient/ingredient_item.dart';
import '../../../data/ingredient/ingredient_list_manager.dart';
import '../../components/singleComponents/custom_dropdownunit.dart';
import 'package:provider/provider.dart';

class InputIngredientToshoppinglistView extends StatelessWidget {
  final IngredientItem item;
  final bool alreadyInList;
  final bool fromRecipe;
  final double valueFromRecipe;
  final String unitFromRecipe;
  const InputIngredientToshoppinglistView({
    super.key,
    required this.item,
    this.fromRecipe = false,
    this.alreadyInList = false,
    this.valueFromRecipe = 0,
    this.unitFromRecipe = "",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Adding to shoppinglist")),
      body: InputForm(item: item),
    );
  }
}

class InputForm extends StatefulWidget {
  final IngredientItem item;
  const InputForm({super.key, required this.item});

  @override
  State<StatefulWidget> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final _formKey = GlobalKey<FormState>();
  int id = 0;
  String name = "";
  double amountToBuy = 0;
  String buyUnit = "";
  double currentAmount = 0;
  String unit = "";

  @override
  void initState() {
    super.initState();

    id = widget.item.id;
    name = widget.item.name;
    amountToBuy = widget.item.amountToBuy;
    buyUnit = widget.item.buyUnit;
    currentAmount = widget.item.currentAmount;
    unit = widget.item.unit;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 20),
      child: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(name, textScaler: TextScaler.linear(1.7)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: currentAmount.toString(),
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'),
                            ),
                          ],
                          decoration: InputDecoration(
                            labelText: "Current amount",
                          ),
                          onChanged: (value) => setState(() {
                            if (value.isNotEmpty) {
                              currentAmount = double.parse(value);
                            } else {
                              currentAmount = 0.0;
                            }
                          }),
                        ),
                        TextFormField(
                          initialValue: amountToBuy.toString(),
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'),
                            ),
                          ],
                          decoration: InputDecoration(
                            labelText: "Amount to buy",
                          ),
                          onChanged: (value) => setState(() {
                            if (value.isNotEmpty) {
                              amountToBuy = double.parse(value);
                            } else {
                              currentAmount = 0.0;
                            }
                          }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    children: [
                      SizedBox(height: 10),
                      CustomDropdownUnit(
                        value: unit,
                        onChanged: (value) {
                          setState(() {
                            unit = value;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      CustomDropdownUnit(
                        value: buyUnit,
                        onChanged: (value) {
                          setState(() {
                            buyUnit = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsetsGeometry.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: () {
                    IngredientItem item = IngredientItem(
                      id: id,
                      name: name,
                      mainCategory: widget.item.mainCategory,
                      subCategory: widget.item.subCategory,
                      description: widget.item.description,
                      expire: widget.item.expire,
                      status: widget.item.status,
                      inShoppinglist: true,
                      isStarred: widget.item.isStarred,
                      amountToBuy: amountToBuy,
                      buyUnit: buyUnit,
                      currentAmount: currentAmount,
                      unit: unit,
                    );
                    Provider.of<IngredientListManager>(
                      context,
                      listen: false,
                    ).update(item);
                    Navigator.pop(context);
                  },
                  child: Text("Add To Shoppinglist"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
