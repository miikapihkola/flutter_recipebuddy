import 'package:flutter/material.dart';
import '../../components/singleComponents/custom_deletebtn.dart';
import '../../../data/category_list_builder.dart';
import '../../../data/recipe/recipe_list_manager.dart';
import 'package:provider/provider.dart';
import '../../../data/constants.dart';
import '../../../data/recipe/recipe_item.dart';
import 'input_recipe_form_fields/ingredient_groups/input_recipe_ingredient_groups.dart';
import 'input_recipe_form_fields/input_recipe_form_fields_base.dart';

class InputRecipeView extends StatelessWidget {
  final RecipeItem? item;
  final bool popTwiceOnDelete;
  const InputRecipeView({super.key, this.item, this.popTwiceOnDelete = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item == null ? "Add new recipe" : "Edit existing recipe"),
      ),
      body: SingleChildScrollView(
        child: InputForm(item: item, popTwiceOnDelete: popTwiceOnDelete),
      ),
    );
  }
}

class InputForm extends StatefulWidget {
  final RecipeItem? item;
  final bool popTwiceOnDelete;
  const InputForm({super.key, this.item, required this.popTwiceOnDelete});

  @override
  State<StatefulWidget> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final _formkey = GlobalKey<FormState>();
  List<String> categoryList = [categoryUnspecified];
  List<String> subcategoryList = [categoryUnspecified];
  final _ingredientGroupsKey = GlobalKey<InputRecipeIngredientGroupsState>();

  // Base
  bool isEdit = false;
  int id = 0;
  String name = "";
  String mainCategory = "";
  String subCategory = "";
  String recipeType = "";
  String description = "";
  int servings = 1;
  bool isPinned = false;
  double rating = 0;
  bool isStarred = false;
  DateTime? timeStamp;
  List<RecipeIngredientGroup> ingredientGroups = [];

  // Type specific
  // -- Commons
  List<CookStep> cookSteps = [];

  // -- Food
  int prepTimeMinutes = 0;
  bool requiresDeepBowl = false;

  // -- Cocktail
  bool isAlcoholic = true;
  double abv = 0;
  String glassType = "";
  String method = "";

  // -- Ferment
  int fermentTimeDays = 0;
  DateTime? fermentingStarted;
  bool notifyWhenReady = false;

  @override
  void initState() {
    super.initState();

    final manager = Provider.of<RecipeListManager>(context, listen: false);

    if (widget.item != null) {
      isEdit = true;
      id = widget.item!.id;
      name = widget.item!.name;
      description = widget.item!.description;
      mainCategory = widget.item!.mainCategory;
      subCategory = widget.item!.subCategory;
      recipeType = widget.item!.recipeType;
      servings = widget.item!.servings;
      isPinned = widget.item!.isPinned;
      rating = widget.item!.rating;
      isStarred = widget.item!.isStarred;
      timeStamp = widget.item!.timeStamp;
      ingredientGroups = widget.item!.ingredientGroups;

      if (widget.item is FoodRecipe) {
        final food = widget.item as FoodRecipe;
        prepTimeMinutes = food.prepTimeMinutes;
        cookSteps = food.cookSteps;
        requiresDeepBowl = food.requiresDeepBowl;
      } else if (widget.item is CocktailRecipe) {
        final cocktail = widget.item as CocktailRecipe;
        isAlcoholic = cocktail.isAlcoholic;
        abv = cocktail.abv;
        glassType = cocktail.glassType;
        method = cocktail.method;
      } else if (widget.item is FermentRecipe) {
        final ferment = widget.item as FermentRecipe;
        fermentTimeDays = ferment.fermentTimeDays;
        fermentingStarted = ferment.fermentingStarted;
        notifyWhenReady = ferment.notifyWhenReady;
        cookSteps = ferment.cooksteps;
      }
    } else {
      mainCategory = categoryList.first;
      subCategory = categoryList.first;
      recipeType = recipeTypes.last;
    }

    categoryList = CategoryListBuilder.buildInputCategoryListRecipe(manager);
    subcategoryList = CategoryListBuilder.buildInputSubcategoryListRecipe(
      manager,
      mainCategory,
    );
  }

  void _updateSubcategoryList() {
    final manager = Provider.of<RecipeListManager>(context, listen: false);
    setState(() {
      subcategoryList = CategoryListBuilder.buildInputSubcategoryListRecipe(
        manager,
        mainCategory,
      );
      if (!subcategoryList.contains(subCategory)) {
        subCategory = subcategoryList.first;
      }
    });
  }

  RecipeItem _buildItem() {
    switch (recipeType) {
      case "Food":
        return FoodRecipe(
            id: id,
            name: name,
            description: description,
            mainCategory: mainCategory,
            subCategory: subCategory,
            servings: servings,
            prepTimeMinutes: prepTimeMinutes,
            cookSteps: cookSteps,
            requiresDeepBowl: requiresDeepBowl,
          )
          ..isPinned = isPinned
          ..isStarred = isStarred
          ..rating = rating
          ..timeStamp = timeStamp
          ..ingredientGroups = ingredientGroups;

      case "Cocktail":
        return CocktailRecipe(
            id: id,
            name: name,
            description: description,
            mainCategory: mainCategory,
            subCategory: subCategory,
            servings: servings,
            isAlcoholic: isAlcoholic,
            abv: abv,
            glassType: glassType,
            method: method,
          )
          ..isPinned = isPinned
          ..isStarred = isStarred
          ..rating = rating
          ..timeStamp = timeStamp
          ..ingredientGroups = ingredientGroups;

      case "Ferment":
        return FermentRecipe(
            id: id,
            name: name,
            description: description,
            mainCategory: mainCategory,
            subCategory: subCategory,
            servings: servings,
            fermentTimeDays: fermentTimeDays,
            fermentingStarted: fermentingStarted,
            notifyWhenReady: notifyWhenReady,
            cooksteps: cookSteps,
          )
          ..isPinned = isPinned
          ..isStarred = isStarred
          ..rating = rating
          ..timeStamp = timeStamp
          ..ingredientGroups = ingredientGroups;

      default:
        return RecipeItem(
            id: id,
            name: name,
            description: description,
            mainCategory: mainCategory,
            subCategory: subCategory,
            servings: servings,
          )
          ..isPinned = isPinned
          ..isStarred = isStarred
          ..rating = rating
          ..timeStamp = timeStamp
          ..ingredientGroups = ingredientGroups;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 20),
      child: Center(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              InputRecipeFieldsBase(
                name: name,
                description: description,
                mainCategory: mainCategory,
                subCategory: subCategory,
                categoryList: categoryList,
                subcategoryList: subcategoryList,
                recipeType: recipeType,
                servings: servings,
                isPinned: isPinned,
                rating: rating,
                isStarred: isStarred,
                timeStamp: timeStamp,
                onNameChanged: (value) => setState(() => name = value),
                onDescriptionChanged: (value) =>
                    setState(() => description = value),
                onMainCategoryChanged: (value) {
                  if (value != dropDownOtherAddNewPlaceholder) {
                    setState(() {
                      mainCategory = value!;
                      subCategory = subcategoryList.first;
                    });
                    _updateSubcategoryList();
                  }
                },
                onSubCategoryChanged: (value) =>
                    setState(() => subCategory = value!),
                onRecipeTypeChanged: (value) =>
                    setState(() => recipeType = value ?? categoryUnspecified),
                onServingsChanged: (value) => setState(() => servings = value),
                onPinnedToggled: () => setState(() => isPinned = !isPinned),
                onStarredToggled: () => setState(() => isStarred = !isStarred),
                onRatingChanged: (value) => setState(() => rating = value),
                onTimeStampChanged: (value) =>
                    setState(() => timeStamp = value),
                categoryValidator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Select main category";
                  }
                  if (value.toLowerCase() == categoryAll.toLowerCase()) {
                    return "Cannot use value '$categoryAll'";
                  }
                  return null;
                },
                subcategoryValidator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Select sub category";
                  }
                  if (value.toLowerCase() == categoryAll.toLowerCase()) {
                    return "Cannot use value '$categoryAll'";
                  }
                  return null;
                },
              ),
              InputRecipeIngredientGroups(
                key: _ingredientGroupsKey,
                ingredientGroups: ingredientGroups,
                onChanged: (groups) =>
                    setState(() => ingredientGroups = groups),
              ),

              /*
              if (recipeType == "Food")
                InputRecipeFormFood(
                  prepTimeMinutes: prepTimeMinutes,
                  cookSteps: cookSteps,
                  requiresDeepBowl: requiresDeepBowl,
                  onChanged: (prep, steps, deepBowl) => setState(() {
                    prepTimeMinutes = prep;
                    cookSteps = steps;
                    requiresDeepBowl = deepBowl;
                  }),
                ),
              if (recipeType == "Cocktail")
                InputRecipeFormCocktail(
                  isAlcoholic: isAlcoholic,
                  abv: abv,
                  glassType: glassType,
                  method: method,
                  onChanged: (alcoholic, abvVal, glass, meth) => setState(() {
                    isAlcoholic = alcoholic;
                    abv = abvVal;
                    glassType = glass;
                    method = meth;
                  }),
                ),
              if (recipeType == "Ferment")
                InputRecipeFormFerment(
                  fermentTimeDays: fermentTimeDays,
                  fermentingStarted: fermentingStarted,
                  notifyWhenReady: notifyWhenReady,
                  cookSteps: cookSteps,
                  onChanged: (days, started, notify, steps) => setState(() {
                    fermentTimeDays = days;
                    fermentingStarted = started;
                    notifyWhenReady = notify;
                    fermentCookSteps = steps;
                  }),
                ),
              */
              Padding(
                padding: const EdgeInsetsGeometry.symmetric(
                  vertical: 40,
                  horizontal: 40,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (!_formkey.currentState!.validate()) {
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
                              content: Text(
                                "Please enter valid sub category name",
                              ),
                            ),
                          );
                          return;
                        }

                        final manager = Provider.of<RecipeListManager>(
                          context,
                          listen: false,
                        );
                        final navigator = Navigator.of(context);

                        await _ingredientGroupsKey.currentState!
                            .flushPendingIngredients(context);

                        final item = _buildItem();

                        if (isEdit) {
                          manager.update(item);
                        } else {
                          manager.add(item);
                        }
                        navigator.pop();
                      },
                      child: isEdit ? const Text("Edit") : const Text("Add"),
                    ),
                    isEdit
                        ? ElevatedButton(
                            onPressed: () async {
                              final manager = Provider.of<RecipeListManager>(
                                context,
                                listen: false,
                              );
                              if (!context.mounted) return;

                              CustomDeleteBtn.show(
                                context: context,
                                itemName: "recipe",
                                onDelete: () async {
                                  manager.delete(widget.item!);
                                  if (widget.popTwiceOnDelete) {
                                    Navigator.pop(context);
                                  }
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: Text("DELETE"),
                          )
                        : Container(),
                  ],
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
