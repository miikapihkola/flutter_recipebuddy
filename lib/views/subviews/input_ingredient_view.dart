import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/ingredient_item.dart';
import '../../data/ingredient_list_manager.dart';
import '../../data/constants.dart';
import '../components/singleComponents/custom_dropdownother.dart';
import '../components/singleComponents/custom_datepicker.dart';
import '../../data/category_list_builder.dart';

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
  List<String> categoryList = [categoryUnspecified];
  List<String> subcategoryList = [categoryUnspecified];

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

    final manager = Provider.of<IngredientListManager>(context, listen: false);

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

    categoryList = CategoryListBuilder.buildInputCategoryList(manager);
    subcategoryList = CategoryListBuilder.buildInputSubcategoryList(
      manager,
      mainCategory,
    );
  }

  void _updateSubcategoryList() {
    final manager = Provider.of<IngredientListManager>(context, listen: false);
    setState(() {
      subcategoryList = CategoryListBuilder.buildInputSubcategoryList(
        manager,
        mainCategory,
      );
      if (!subcategoryList.contains(subCategory)) {
        subCategory = subcategoryList.first;
      }
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
              CustomDatePicker(
                label: "Expire",
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
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [Text("Main Category"), Text("Sub Category")],
              ),
              Row(
                children: [
                  CustomDropdownOther(
                    options: categoryList,
                    initialValue: mainCategory,
                    onChanged: (value) {
                      if (value != dropDownOtherAddNewPlaceholder) {
                        setState(() {
                          mainCategory = value!;
                          subCategory = subcategoryList.first;
                        });
                        _updateSubcategoryList();
                      }
                    },
                    validator: (value) {
                      if (value == null || value == "") {
                        return "Select main category";
                      }
                      if (value.toLowerCase() == categoryAll.toLowerCase()) {
                        return "Cannot use value '$categoryAll'";
                      }
                      return null;
                    },
                  ),
                  SizedBox(width: 10),
                  CustomDropdownOther(
                    options: subcategoryList,
                    initialValue: subCategory,
                    disabled:
                        mainCategory == categoryList.first ||
                        mainCategory.isEmpty,
                    onChanged: (value) {
                      setState(() {
                        subCategory = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value == "") {
                        return "Select main category";
                      }
                      if (value.toLowerCase() == categoryAll.toLowerCase()) {
                        return "Cannot use value '$categoryAll'";
                      }
                      return null;
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsetsGeometry.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    if (mainCategory == dropDownOtherAddNewPlaceholder ||
                        mainCategory.toLowerCase() ==
                            dropDownOtherVisibleText.toLowerCase() ||
                        mainCategory.isEmpty ||
                        mainCategory.toLowerCase() ==
                            categoryAll.toLowerCase()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Please enter valid main category name",
                          ),
                        ),
                      );
                      return;
                    }
                    if (subCategory == dropDownOtherAddNewPlaceholder ||
                        subCategory.toLowerCase() ==
                            dropDownOtherVisibleText.toLowerCase() ||
                        subCategory.isEmpty ||
                        subCategory.toLowerCase() ==
                            categoryAll.toLowerCase()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please enter valid sub category name"),
                        ),
                      );
                      return;
                    }
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
