import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/ingredient_item.dart';
import '../../data/ingredient_list_manager.dart';

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
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(vertical: 20),
      child: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text("placeholder"),
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
