import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/settings_helper.dart';
import 'input_ingredient_update_amounts.dart';
import '../../../data/ingredient/ingredient_item.dart';
import '../../../data/ingredient/ingredient_list_manager.dart';
import '../../components/singleComponents/custom_dropdownunit.dart';
import 'package:provider/provider.dart';

class InputIngredientToshoppinglistView extends StatelessWidget {
  final IngredientItem item;
  final bool fromRecipe;
  final double valueFromRecipe;
  final String unitFromRecipe;
  const InputIngredientToshoppinglistView({
    super.key,
    required this.item,
    this.fromRecipe = false,
    this.valueFromRecipe = 0,
    this.unitFromRecipe = "",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Adding to shoppinglist")),
      body: InputForm(
        item: item,
        fromRecipe: fromRecipe,
        valueFromRecipe: valueFromRecipe,
        unitFromRecipe: unitFromRecipe,
      ),
    );
  }
}

class InputForm extends StatefulWidget {
  final IngredientItem item;
  final bool fromRecipe;
  final double valueFromRecipe;
  final String unitFromRecipe;
  const InputForm({
    super.key,
    required this.item,
    required this.fromRecipe,
    required this.valueFromRecipe,
    required this.unitFromRecipe,
  });

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
  double valueFromRecipe = 0;
  String unitFromRecipe = "";
  double suggestionValue = 0;
  String suggestionUnit = "";
  bool preferOriginalUnit = true;

  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();

    id = widget.item.id;
    name = widget.item.name;
    amountToBuy = widget.item.amountToBuy;
    buyUnit = widget.item.buyUnit;
    currentAmount = widget.item.currentAmount;
    unit = widget.item.unit;
    valueFromRecipe = widget.valueFromRecipe;
    unitFromRecipe = widget.unitFromRecipe;

    _amountController = TextEditingController(text: "0");
    _loadSettings();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final preferOriginalUnitValue = await SettingsHelper.instance
        .getPreferOriginalUnit();
    setState(() {
      preferOriginalUnit = preferOriginalUnitValue;

      List<String> suggestedValue = getSuggestedValue(
        true,
        amountToBuy,
        buyUnit,
        valueFromRecipe,
        unitFromRecipe,
        preferOriginalUnit,
      );
      _amountController.text = suggestedValue[0];
      suggestionValue = double.parse(suggestedValue[0]);
      suggestionUnit = suggestedValue[1];
    });
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
                        !widget.fromRecipe
                            ? TextFormField(
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
                                    amountToBuy = 0.0;
                                  }
                                }),
                              )
                            : Container(),
                        widget.fromRecipe && !widget.item.inShoppinglist
                            ? TextFormField(
                                initialValue: valueFromRecipe.toString(),
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
                                    valueFromRecipe = double.parse(value);
                                  } else {
                                    valueFromRecipe = 0.0;
                                  }
                                }),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: CustomDropdownUnit(
                          value: unit,
                          onChanged: (value) {
                            setState(() {
                              unit = value;
                            });
                          },
                        ),
                      ),
                      !widget.fromRecipe
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: CustomDropdownUnit(
                                value: buyUnit,
                                onChanged: (value) {
                                  setState(() {
                                    buyUnit = value;
                                  });
                                },
                              ),
                            )
                          : Container(),
                      widget.fromRecipe && !widget.item.inShoppinglist
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: CustomDropdownUnit(
                                value: unitFromRecipe,
                                onChanged: (value) {
                                  setState(() {
                                    unitFromRecipe = value;
                                  });
                                },
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ],
              ),
              widget.fromRecipe && widget.item.inShoppinglist
                  ? Column(
                      children: [
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Amount in shopping list:"),
                                Text("Required by recipe:"),
                              ],
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(amountToBuy.toString()),
                                    SizedBox(width: 4),
                                    Text(buyUnit),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(valueFromRecipe.toString()),
                                    SizedBox(width: 4),
                                    Text(unitFromRecipe),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _amountController,
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]'),
                                  ),
                                ],
                                decoration: InputDecoration(
                                  labelText: "Suggested new amount to buy",
                                ),
                                onChanged: (value) => setState(() {
                                  if (value.isNotEmpty) {
                                    suggestionValue = double.parse(value);
                                  } else {
                                    suggestionValue = 0.0;
                                  }
                                }),
                              ),
                            ),
                            SizedBox(width: 10),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: CustomDropdownUnit(
                                value: suggestionUnit,
                                onChanged: (value) {
                                  setState(() {
                                    suggestionUnit = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ), //buttons
                      ],
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsetsGeometry.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: () {
                    double newValue = 0;
                    String newUnit = "";
                    if (!widget.fromRecipe) {
                      newValue = amountToBuy;
                      newUnit = buyUnit;
                    } else if (widget.fromRecipe &&
                        !widget.item.inShoppinglist) {
                      newValue = valueFromRecipe;
                      newUnit = unitFromRecipe;
                    } else {
                      newValue = suggestionValue;
                      newUnit = suggestionUnit;
                    }
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
                      amountToBuy: newValue,
                      buyUnit: newUnit,
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
