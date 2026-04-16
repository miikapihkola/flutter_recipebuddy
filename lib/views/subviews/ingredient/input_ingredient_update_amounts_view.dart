import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/settings_helper.dart';
import '../../../data/ingredient/ingredient_item.dart';
import '../../components/singleComponents/custom_datepicker.dart';
import '../../../data/ingredient/ingredient_list_manager.dart';
import '../../../data/valueconverter.dart';
import '../../components/singleComponents/custom_dropdownunit.dart';
import 'package:provider/provider.dart';

class InputIngredientUpdateAmountsView extends StatelessWidget {
  final IngredientItem item;
  final bool isAddition;
  final double? usageAmount;
  final String? usageUnit;
  const InputIngredientUpdateAmountsView({
    super.key,
    required this.item,
    required this.isAddition,
    this.usageAmount,
    this.usageUnit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isAddition
            ? Text("Adding bought amount")
            : Text("Substracting used amount"),
      ),
      body: InputForm(
        item: item,
        isAddition: isAddition,
        usageAmount: usageAmount,
        usageUnit: usageUnit,
      ),
    );
  }
}

class InputForm extends StatefulWidget {
  final IngredientItem item;
  final bool isAddition;
  final double? usageAmount;
  final String? usageUnit;
  const InputForm({
    super.key,
    required this.item,
    required this.isAddition,
    this.usageAmount,
    this.usageUnit,
  });

  @override
  State<StatefulWidget> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final _formKey = GlobalKey<FormState>();

  bool isAddition = false;
  int id = 0;
  String name = "";
  int status = 0;
  DateTime? expire;
  double currentAmount = 0;
  String unit = "";
  double amountToHandle = 0;
  String amountToHandleUnit = "";

  bool preferOriginalUnit = false;
  double updatedAmount = 0;
  String updatedUnit = "";

  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();

    isAddition = widget.isAddition;
    id = widget.item.id;
    name = widget.item.name;
    status = widget.item.status;
    expire = widget.item.expire;
    currentAmount = widget.item.currentAmount;
    unit = widget.item.unit;
    amountToHandle = isAddition
        ? widget.item.amountToBuy
        : widget.usageAmount != null
        ? widget.usageAmount!
        : 0;
    amountToHandleUnit = isAddition
        ? widget.item.buyUnit
        : widget.usageUnit != null
        ? widget.usageUnit!
        : "";

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
        isAddition,
        currentAmount,
        unit,
        amountToHandle,
        amountToHandleUnit,
        preferOriginalUnit,
      );
      _amountController.text = suggestedValue[0];
      updatedAmount = double.parse(suggestedValue[0]);
      updatedUnit = suggestedValue[1];
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
              SizedBox(height: 5),
              Text(name, textScaler: TextScaler.linear(1.7)),
              CustomDatePicker(
                label: "Expire",
                date: expire,
                onChanged: (value) {
                  setState(() {
                    expire = value;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Current amount: "),
                          Text(
                            isAddition
                                ? "Amount to add: "
                                : "Amount to substract: ",
                          ),
                        ],
                      ),
                      SizedBox(width: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(currentAmount.toString()),
                              SizedBox(width: 4),
                              Text(unit),
                            ],
                          ),
                          Row(
                            children: [
                              Text(amountToHandle.toString()),
                              SizedBox(width: 4),
                              Text(amountToHandleUnit),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (status == 0) {
                          status = 3;
                        } else if (status < 4 && status > 0) {
                          status--;
                        } else {
                          status = 0;
                        }
                      });
                    },
                    icon: Icon(Icons.shelves),
                    color: _getColor(status),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      decoration: InputDecoration(labelText: "Updated amount"),
                      onChanged: (value) => setState(() {
                        if (value.isNotEmpty) {
                          updatedAmount = double.parse(value);
                        } else {
                          updatedAmount = 0.0;
                        }
                      }),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    children: [
                      SizedBox(height: 10),
                      CustomDropdownUnit(
                        value: updatedUnit,
                        onChanged: (value) {
                          setState(() {
                            updatedUnit = value;
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
                      expire: expire,
                      status: status,
                      inShoppinglist: false,
                      isStarred: widget.item.isStarred,
                      amountToBuy: widget.item.amountToBuy,
                      buyUnit: widget.item.buyUnit,
                      currentAmount: updatedAmount,
                      unit: updatedUnit,
                    );
                    Provider.of<IngredientListManager>(
                      context,
                      listen: false,
                    ).update(item);
                    Navigator.pop(context);
                  },
                  child: Text("Update ingredient amount"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<String> getSuggestedValue(
  bool isAddition,
  double firstValue,
  String firstValueUnit,
  double secondValue,
  String secondValueUnit,
  bool preferOriginalUnit,
) {
  double suggestedValue = 0;
  String suggestedUnit = "";

  if (firstValueUnit == secondValueUnit) {
    suggestedUnit = firstValueUnit;
    suggestedValue = isAddition
        ? firstValue + secondValue
        : firstValue - secondValue;
  } else if (firstValueUnit != "" && secondValueUnit == "") {
    suggestedUnit = firstValueUnit;
    suggestedValue = isAddition
        ? firstValue + secondValue
        : firstValue - secondValue;
  } else if (firstValueUnit == "" && secondValueUnit != "") {
    suggestedUnit = secondValueUnit;
    suggestedValue = isAddition
        ? firstValue + secondValue
        : firstValue - secondValue;
  } else if (!preferOriginalUnit) {
    suggestedUnit = secondValueUnit;
    double convertedValue = valueConverter(
      firstValue,
      firstValueUnit,
      secondValueUnit,
    );
    suggestedValue = isAddition
        ? secondValue + convertedValue
        : convertedValue - secondValue;
  } else {
    suggestedUnit = firstValueUnit;
    double convertedValue = valueConverter(
      secondValue,
      secondValueUnit,
      firstValueUnit,
    );
    suggestedValue = isAddition
        ? firstValue + convertedValue
        : firstValue - convertedValue;
  }

  if (suggestedValue < 0) {
    suggestedValue = 0;
  }
  return [suggestedValue.toString(), suggestedUnit];
}

Color _getColor(int state) {
  switch (state) {
    case 0:
      return Colors.red;
    case 1:
      return Colors.amber;
    case 2:
      return Colors.green;
    case 3:
      return Colors.blueGrey;
    default:
      return Colors.black;
  }
}
