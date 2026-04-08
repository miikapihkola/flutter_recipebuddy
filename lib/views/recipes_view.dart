import 'package:flutter/material.dart';
import 'package:flutter_recipebuddy/views/components/cards/ingredient_card.dart';
import 'package:flutter_recipebuddy/views/components/filter/filter_bar.dart';
import '../data/category_list_builder.dart';
import 'components/cards/recipe_card.dart';
import 'components/singleComponents/custom_divider.dart';
import 'package:provider/provider.dart';
import '../data/recipe/recipe_list_manager.dart';
import '../data/constants.dart';
import '../data/recipe/recipe_item.dart';

class RecipesView extends StatefulWidget {
  const RecipesView({super.key});

  @override
  State<RecipesView> createState() => _RecipesViewState();
}

class _RecipesViewState extends State<RecipesView> {
  final List<String> sortByList = ["Alphabetical", "Recent"];

  List<bool> selectedIncludeStarred = [true, true]; // no, yes

  bool showSearchBar = false;
  String selectedCategory = categoryAll;
  String selectedSubcategory = categoryAll;
  String selectedTextSearch = "";
  String selectedSortBy = "";
  bool selectedSortByAsc = true;

  // Filtered list
  List<RecipeItem> _getFilteredList(List<RecipeItem> items) {
    return items.where((item) {
      // Text search
      if (selectedTextSearch.isNotEmpty &&
          !item.name.toLowerCase().contains(selectedTextSearch.toLowerCase()) &&
          !item.description.toLowerCase().contains(
            selectedTextSearch.toLowerCase(),
          )) {
        return false;
      }

      // Category
      if (selectedCategory != categoryAll &&
          item.mainCategory != selectedCategory) {
        return false;
      }

      // Subcategory
      if (selectedSubcategory != categoryAll &&
          item.subCategory != selectedSubcategory) {
        return false;
      }

      // Starred [false, true]
      if (!selectedIncludeStarred[item.isStarred ? 1 : 0]) {
        return false;
      }

      return true;
    }).toList();
  }

  List<RecipeItem> _getSortedList(List<RecipeItem> items) {
    final sorted = List<RecipeItem>.from(items);
    sorted.sort((a, b) {
      int compare;
      switch (selectedSortBy) {
        case "Alphabetical":
          compare = a.name.compareTo(b.name);
          break;
        case "Recent":
          compare = a.id.compareTo(b.id);
          break;
        default:
          compare = 0;
      }
      return selectedSortByAsc ? compare : -compare;
    });
    return sorted;
  }

  @override
  void initState() {
    super.initState();
    selectedSortBy = sortByList.first;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeListManager>(
      builder: (context, listManager, child) {
        final displayList = _getSortedList(_getFilteredList(listManager.items));
        /*final categoryList = CategoryListBuilder.buildFilterCategoryList(listManager)
        final subcategoryList = CategoryListBuilder.buildFilterSubcategoryList(listManager, selectedCategory);
        if (!subcategoryList.contains(selectedSubcategory)) {
          selectedSubcategory = subcategoryList.first;
        }*/
        return Scaffold(
          appBar: AppBar(
            title: const Text("Recipes"),
            actions: [
              IconButton(
                iconSize: Theme.of(context).iconTheme.size,
                onPressed: () {
                  /*
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InputRecipeView(),
                    ),
                  );
                  */
                },
                icon: Icon(Icons.add),
              ),
              IconButton(
                iconSize: Theme.of(context).iconTheme.size,
                onPressed: () {
                  setState(() {
                    showSearchBar = !showSearchBar;
                  });
                },
                icon: Icon(Icons.search),
              ),
            ],
          ),
          body: Builder(
            builder: (context) {
              if (listManager.items.isEmpty) {
                return Text("No Recipes");
              } else {
                return Column(
                  children: [
                    showSearchBar
                        ? Column(
                            children: [
                              /*FilterBar(
                            viewType: RecipesView(), 
                            categoryList: categoryList, 
                            subcategoryList: subcategoryList, 
                            initcategory: selectedCategory, 
                            initsubcategory: selectedSubcategory, 
                            initTextSearch: selectedTextSearch, 
                            initSortBy: selectedSortBy,
                            sortByList: sortByList, 
                            initSortByAsc: selectedSortByAsc,
                            onFilterChanged: (category, subcategory, textSearch, sortBy, sortByAsc,) {
                              setState(() {
                                selectedCategory = category;
                                selectedSubcategory = subcategory;
                                selectedTextSearch = textSearch;
                                selectedSortBy = sortBy;
                                selectedSortByAsc = sortByAsc;
                              });
                            },
                            ),
                            FilterRecipes(),*/
                              Text("Placeholder searchbar"),
                            ],
                          )
                        : CustomDivider(tb: [2, 0]),
                    displayList.isEmpty
                        ? Text("No recipes corresponding current filters")
                        : Expanded(
                            child: ListView.builder(
                              itemCount: displayList.length,
                              itemBuilder: (context, index) {
                                return recipeCard(
                                  displayList[index],
                                  context,
                                  listManager,
                                );
                              },
                            ),
                          ),
                  ],
                );
              }
            },
          ),
        );
      },
    );
  }
}
