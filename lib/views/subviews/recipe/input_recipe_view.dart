import 'package:flutter/material.dart';
import 'package:flutter_recipebuddy/data/category_list_builder.dart';
import 'package:flutter_recipebuddy/data/recipe/recipe_list_manager.dart';
import 'package:provider/provider.dart';
import '../../../data/constants.dart';
import '../../../data/recipe/recipe_item.dart';

class InputRecipeView extends StatelessWidget {
  final RecipeItem? item;
  const InputRecipeView({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item == null ? "Add new recipe" : "Edit existing recipe"),
      ),
      body: InputForm(item: item),
    );
  }
}

class InputForm extends StatefulWidget {
  final RecipeItem? item;
  const InputForm({super.key, this.item});

  @override
  State<StatefulWidget> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final _formkey = GlobalKey<FormState>();
  List<String> categoryList = [categoryUnspecified];
  List<String> subcategoryList = [categoryUnspecified];

  bool isEdit = false;
  int id = 0;
  String name = "";
  String mainCategory = "";
  String subCategory = "";
  String recipeType = "";
  int servings = 1;
  bool isPinned = false;
  double rating = 0;
  bool isStarred = false;
  DateTime? timeStamp;
  List<RecipeIngredientGroup> ingredientGroups = [];

  @override
  void initState() {
    super.initState();

    final manager = Provider.of<RecipeListManager>(context, listen: false);

    if (widget.item != null) {
      isEdit = true;
      id = widget.item!.id;
      name = widget.item!.name;
      mainCategory = widget.item!.mainCategory;
      subCategory = widget.item!.subCategory;
      recipeType = widget.item!.recipeType;
      servings = widget.item!.servings;
      isPinned = widget.item!.isPinned;
      rating = widget.item!.rating;
      isStarred = widget.item!.isStarred;
      timeStamp = widget.item!.timeStamp;
      ingredientGroups = widget.item!.ingredientGroups;
    } else {
      mainCategory = categoryList.first;
      subCategory = categoryList.first;
    }

    /*
    categoryList = CategoryListBuilder.buildInputCategoryList(manager);
    subcategoryList = CategoryListBuilder.buildInputSubcategoryList(
      manager,
      mainCategory,
    );
    */
  }

  /*
   void _updateSubcategoryList() {
    final manager = Provider.of<RecipeListManager>(context, listen: false);
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
  */

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
