import 'package:flutter/material.dart';
import '../data/ingredient/ingredient_item.dart';
import '../data/ingredient/ingredient_list_manager.dart';
import 'package:provider/provider.dart';
import 'components/filter/filter_bar.dart';
import 'components/cards/shoppinglist_card.dart';
import 'components/singleComponents/custom_divider.dart';
import 'subviews/ingredient/input_ingredient_view.dart';
import '../data/category_list_builder.dart';
import '../data/constants.dart';

class ShoppinglistView extends StatefulWidget {
  const ShoppinglistView({super.key});

  @override
  State<ShoppinglistView> createState() => _ShoppinglistViewState();
}

class _ShoppinglistViewState extends State<ShoppinglistView> {
  final List<String> sortByList = ["Alphabetical", "Expire", "Recent"];

  bool showSearchBar = false;
  String selectedCategory = categoryAll;
  String selectedSubcategory = categoryAll;
  String selectedTextSearch = "";
  String selectedSortBy = "";
  bool selectedSortByAsc = true;
  bool noShoppinglistItems = true;

  // Filtered list
  List<IngredientItem> _getFilteredList(List<IngredientItem> items) {
    return items.where((item) {
      // Shoppinglist
      if (!item.inShoppinglist) {
        return false;
      }
      // Turn off noShoppinglistItems Flag
      noShoppinglistItems = false;

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
            title: const Text("Shoppinglist"),
            actions: [
              IconButton(
                iconSize: Theme.of(context).iconTheme.size,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          InputIngredientView(fromShoppinglist: true),
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
                                viewType: ShoppinglistView(),
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
                                      textsearch,
                                      sortBy,
                                      sortByAsc,
                                    ) {
                                      setState(() {
                                        selectedCategory = category;
                                        selectedSubcategory = subcategory;
                                        selectedTextSearch = textsearch;
                                        selectedSortBy = sortBy;
                                        selectedSortByAsc = sortByAsc;
                                      });
                                    },
                              ),
                              CustomDivider(tb: [10, 0]),
                            ],
                          )
                        : CustomDivider(tb: [2, 0]),
                    noShoppinglistItems
                        ? Text("No items tagged to shoppinglist")
                        : displayList.isEmpty
                        ? Text("No items corresponding current filters")
                        : Expanded(
                            child: ListView.builder(
                              itemCount: displayList.length,
                              itemBuilder: (context, index) {
                                return shoppinglistCard(
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
