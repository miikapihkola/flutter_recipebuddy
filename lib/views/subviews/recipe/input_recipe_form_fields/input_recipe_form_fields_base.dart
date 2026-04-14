import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../data/constants.dart';
import '../../../components/singleComponents/custom_datepicker.dart';
import '../../../components/singleComponents/custom_dropdown.dart';
import '../../../components/singleComponents/custom_dropdownother.dart';

class InputRecipeFieldsBase extends StatelessWidget {
  final String name;
  final String description;
  final String mainCategory;
  final String subCategory;
  final List<String> categoryList;
  final List<String> subcategoryList;
  final String recipeType;
  final int servings;
  final bool isPinned;
  final double rating;
  final bool isStarred;
  final DateTime? timeStamp;

  final Function(String) onNameChanged;
  final Function(String) onDescriptionChanged;
  final Function(String?) onMainCategoryChanged;
  final Function(String?) onSubCategoryChanged;
  final Function(dynamic) onRecipeTypeChanged;
  final Function(int) onServingsChanged;
  final Function() onPinnedToggled;
  final Function() onStarredToggled;
  final Function(double) onRatingChanged;
  final String? Function(String?) categoryValidator;
  final String? Function(String?) subcategoryValidator;
  final Function(DateTime?) onTimeStampChanged;

  const InputRecipeFieldsBase({
    super.key,
    required this.name,
    required this.description,
    required this.mainCategory,
    required this.subCategory,
    required this.categoryList,
    required this.subcategoryList,
    required this.recipeType,
    required this.servings,
    required this.isPinned,
    required this.rating,
    required this.isStarred,
    required this.onNameChanged,
    required this.onDescriptionChanged,
    required this.onMainCategoryChanged,
    required this.onSubCategoryChanged,
    required this.onRecipeTypeChanged,
    required this.onServingsChanged,
    required this.onPinnedToggled,
    required this.onStarredToggled,
    required this.onRatingChanged,
    required this.categoryValidator,
    required this.subcategoryValidator,
    this.timeStamp,
    required this.onTimeStampChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Name
        TextFormField(
          initialValue: name,
          decoration: const InputDecoration(
            hintText: "Recipe name",
            labelText: "Name",
          ),
          onChanged: onNameChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Give name for the recipe.";
            }
            return null;
          },
          minLines: 1,
          maxLines: 3,
        ),

        CustomDatePicker(
          label: "Timestamp",
          date: timeStamp,
          onChanged: onTimeStampChanged,
        ),

        // Description
        TextFormField(
          initialValue: description,
          decoration: const InputDecoration(
            hintText: "Recipe description",
            labelText: "Description",
          ),
          onChanged: onDescriptionChanged,
          minLines: 1,
          maxLines: 30,
        ),

        SizedBox(height: 10),

        // Categories
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [Text("Main Category"), Text("Sub Category")],
        ),
        Row(
          children: [
            CustomDropdownOther(
              options: categoryList,
              initialValue: mainCategory,
              onChanged: onMainCategoryChanged,
              validator: categoryValidator,
            ),
            SizedBox(width: 10),
            CustomDropdownOther(
              options: subcategoryList,
              initialValue: subCategory,
              disabled:
                  mainCategory == categoryList.first || mainCategory.isEmpty,
              onChanged: onSubCategoryChanged,
              validator: subcategoryValidator,
            ),
          ],
        ),

        SizedBox(height: 10),

        // Servings
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Text("Servings: "),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        initialValue: servings.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) =>
                            onServingsChanged(int.tryParse(value) ?? 1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Text("Rating: "),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        initialValue: rating.toString(),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[-0-9.]')),
                        ],
                        onChanged: (value) =>
                            onRatingChanged(double.tryParse(value) ?? 0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        // Rating
        SizedBox(height: 10),

        // Icons
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
              child: Text("Recipe type: "),
            ),
            Flexible(
              child: CustomDropdown(
                value: recipeType,
                list: recipeTypes,
                onChanged: onRecipeTypeChanged,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: IconButton(
                onPressed: onPinnedToggled,
                icon: Icon(
                  Icons.push_pin,
                  color: isPinned ? Colors.deepOrange : Colors.blueGrey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: IconButton(
                onPressed: onStarredToggled,
                icon: Icon(
                  Icons.star,
                  color: isStarred ? Colors.deepOrange : Colors.blueGrey,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
