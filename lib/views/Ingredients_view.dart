import 'package:flutter/material.dart';
import '../data/ingredient/ingredient_item.dart';
import 'components/filter/filter_ingredients.dart';
import '../data/ingredient/ingredient_list_manager.dart';
import 'package:provider/provider.dart';
import 'components/filter/filter_bar.dart';
import 'components/cards/ingredient_card.dart';
import 'components/singleComponents/custom_divider.dart';
import 'subviews/ingredient/input_ingredient_view.dart';
import '../data/category_list_builder.dart';
import '../data/constants.dart';

class IngredientsView extends StatefulWidget {
  const IngredientsView({super.key});

  @override
  State<IngredientsView> createState() => _IngredientsViewState();
}

class _IngredientsViewState extends State<IngredientsView> {
  final List<String> sortByList = ["Alphabetical", "Expire", "Recent"];

  List<bool> selectedIncludeShoppinglist = [true, true]; // no, yes
  List<bool> selectedIncludeStarred = [true, true]; // no, yes
  List<bool> selectedIncludeStatus = [
    true,
    true,
    true,
    true,
  ]; // [R, Y, G, unknown]

  bool showSearchBar = false;
  String selectedCategory = categoryAll;
  String selectedSubcategory = categoryAll;
  String selectedTextSearch = "";
  String selectedSortBy = "";
  bool selectedSortByAsc = true;

  // Filtered list
  List<IngredientItem> _getFilteredList(List<IngredientItem> items) {
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

      // Shoppinglist [false, true]
      if (!selectedIncludeShoppinglist[item.inShoppinglist ? 1 : 0]) {
        return false;
      }

      // Starred [false, true]
      if (!selectedIncludeStarred[item.isStarred ? 1 : 0]) {
        return false;
      }

      // Status [R, Y, G, unknown] -> [0, 1, 2, 3]
      if (item.status < selectedIncludeStatus.length &&
          !selectedIncludeStatus[item.status]) {
        return false;
      }

      return true;
    }).toList();
  }

  List<IngredientItem> _getSortedList(List<IngredientItem> items) {
    final sorted = List<IngredientItem>.from(items);
    sorted.sort((a, b) {
      int compare;
      switch (selectedSortBy) {
        case "Alphabetical":
          compare = a.name.compareTo(b.name);
          break;
        case "Expire":
          if (a.expire == null && b.expire == null) {
            compare = 0;
          } else if (a.expire == null) {
            compare = 1;
          } else if (b.expire == null) {
            compare = -1;
          } else {
            compare = a.expire!.compareTo(b.expire!);
          }
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
    return Consumer<IngredientListManager>(
      builder: (context, listManager, child) {
        final displayList = _getSortedList(_getFilteredList(listManager.items));
        final categoryList = CategoryListBuilder.buildFilterCategoryList(
          listManager,
        );
        final subcategoryList = CategoryListBuilder.buildFilterSubcategoryList(
          listManager,
          selectedCategory,
        );
        if (!subcategoryList.contains(selectedSubcategory)) {
          selectedSubcategory = subcategoryList.first;
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text("Ingredients"),
            actions: [
              IconButton(
                iconSize: Theme.of(context).iconTheme.size,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InputIngredientView(),
                    ),
                  );
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
                return Text("No Ingredients");
              } else {
                return Column(
                  children: [
                    showSearchBar
                        ? Column(
                            children: [
                              FilterBar(
                                viewType: IngredientsView(),
                                categoryList: categoryList,
                                subcategoryList: subcategoryList,
                                initcategory: selectedCategory,
                                initsubcategory: selectedSubcategory,
                                initTextSearch: selectedTextSearch,
                                initSortBy: selectedSortBy,
                                sortByList: sortByList,
                                initSortByAsc: selectedSortByAsc,
                                onFilterChanged:
                                    (
                                      category,
                                      subcategory,
                                      textSearch,
                                      sortBy,
                                      sortByAsc,
                                    ) {
                                      setState(() {
                                        selectedCategory = category;
                                        selectedSubcategory = subcategory;
                                        selectedTextSearch = textSearch;
                                        selectedSortBy = sortBy;
                                        selectedSortByAsc = sortByAsc;
                                      });
                                      // Logic
                                    },
                              ),
                              FilterIngredients(
                                initIncludeShoppinglist:
                                    selectedIncludeShoppinglist,
                                initIncludeStarred: selectedIncludeStarred,
                                initIncludeStatus: selectedIncludeStatus,
                                onFilterChanged:
                                    (
                                      includeShoppinglist,
                                      includeStarred,
                                      includeStatus,
                                    ) {
                                      setState(() {
                                        selectedIncludeShoppinglist =
                                            includeShoppinglist;
                                        selectedIncludeStarred = includeStarred;
                                        selectedIncludeStatus = includeStatus;
                                      });
                                      // Logic
                                    },
                              ),
                            ],
                          )
                        : CustomDivider(tb: [2, 0]),
                    displayList.isEmpty
                        ? Text("No ingredients corresponding current filters")
                        : Expanded(
                            child: ListView.builder(
                              itemCount: displayList.length,
                              itemBuilder: (context, index) {
                                return ingredientCard(
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
