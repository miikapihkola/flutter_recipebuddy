import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/ingredient_item.dart';
import '../../data/ingredient_list_manager.dart';
import '../../data/constants.dart';
import '../components/singleComponents/custom_dropdownother.dart';

class InputIngredientView extends StatelessWidget {
  final IngredientItem? item;
  const InputIngredientView({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          item == null ? "Add new ingredient" : "Edit existing ingredient",
        ),
      ),
      body: InputForm(item: item),
    );
  }
}

class InputForm extends StatefulWidget {
  final IngredientItem? item;
  const InputForm({super.key, this.item});

  @override
  State<StatefulWidget> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> categoryList = ["Unspecified", "Fluids"];
  final List<String> subcategoryList = ["Unspecified", "Alcohol", "Dairy"];

  bool isEdit = false;
  int id = 0;
  String name = "";
  String description = "";
  String mainCategory = "";
  String subCategory = "";
  DateTime? expire;
  int status = 3; // [0, 1, 2] = [R, Y, G] , 3 = unknown
  bool inShoppinglist = false;
  bool isStarred = false;
  double amountToBuy = 0;
  String buyUnit = "";
  double currentAmount = 0;
  String unit = "";

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      isEdit = true;
      id = widget.item!.id;
      name = widget.item!.name;
      description = widget.item!.description;
      mainCategory = widget.item!.mainCategory;
      subCategory = widget.item!.subCategory;
      expire = widget.item!.expire;
      status = widget.item!.status;
      inShoppinglist = widget.item!.inShoppinglist;
      isStarred = widget.item!.isStarred;
      amountToBuy = widget.item!.amountToBuy;
      buyUnit = widget.item!.buyUnit;
      currentAmount = widget.item!.currentAmount;
      unit = widget.item!.unit;
    } else {
      mainCategory = categoryList.first;
      subCategory = subcategoryList.first;
    }
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
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(
                  hintText: "Ingredient name",
                  labelText: "Name",
                ),
                onChanged: (value) => {
                  setState(() {
                    name = value;
                  }),
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Give name for the ingredient.";
                  }
                  return null;
                },
              ),
              _DatePicker(
                date: expire,
                onChanged: (value) {
                  setState(() {
                    expire = value;
                  });
                },
              ),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(
                  hintText: "Ingredient description",
                  labelText: "Description",
                ),
                onChanged: (value) => setState(() {
                  description = value;
                }),
                minLines: 1,
                maxLines: 3,
              ),
              Row(
                children: [
                  CustomDropdownOther(
                    options: categoryList,
                    initialValue: mainCategory,
                    onChanged: (value) {
                      setState(() {
                        mainCategory = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value == "") {
                        return "Select main category";
                      }
                      if (value.toLowerCase() == "all") {
                        return "Cannot use value 'all'";
                      }
                    },
                  ),
                  SizedBox(width: 10),
                  CustomDropdownOther(
                    options: subcategoryList,
                    initialValue: subCategory,
                    onChanged: (value) {
                      setState(() {
                        subCategory = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value == "") {
                        return "Select main category";
                      }
                      if (value.toLowerCase() == "all") {
                        return "Cannot use value 'all'";
                      }
                    },
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
                      mainCategory: mainCategory,
                      subCategory: subCategory,
                      description: description,
                      expire: expire,
                      status: status,
                      inShoppinglist: inShoppinglist,
                      isStarred: isStarred,
                      amountToBuy: amountToBuy,
                      buyUnit: buyUnit,
                      currentAmount: currentAmount,
                      unit: unit,
                    );
                    if (isEdit) {
                      Provider.of<IngredientListManager>(
                        context,
                        listen: false,
                      ).update(item);
                    } else {
                      Provider.of<IngredientListManager>(
                        context,
                        listen: false,
                      ).add(item);
                    }
                    Navigator.pop(context);
                  },
                  child: isEdit ? const Text("Edit") : const Text("Add"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DatePicker extends StatefulWidget {
  final DateTime? date;
  final ValueChanged<DateTime?> onChanged;

  const _DatePicker({required this.date, required this.onChanged});

  @override
  State<StatefulWidget> createState() => _DatePickerState();
}

class _DatePickerState extends State<_DatePicker> {
  final formatter = DateFormat("dd.MM.yyyy");
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Expire: "),
        Text(widget.date != null ? formatter.format(widget.date!) : "Not set"),
        TextButton(
          onPressed: () async {
            var newDate = await showDatePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (newDate == null) {
              return;
            }
            widget.onChanged(newDate);
          },
          child: const Text("Edit"),
        ),
        if (widget.date != null)
          TextButton(
            onPressed: () {
              widget.onChanged(null);
            },
            child: const Text("Remove"),
          ),
      ],
    );
  }
}
