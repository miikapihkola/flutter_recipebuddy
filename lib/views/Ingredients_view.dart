import 'package:flutter/material.dart';
import 'components/filter/filter_ingredients.dart';
import '../data/ingredient_list_manager.dart';
import 'package:provider/provider.dart';
import 'components/filter/filter_bar.dart';
import 'components/cards/ingredient_card.dart';
import 'components/singleComponents/custom_divider.dart';
import 'subviews/input_ingredient_view.dart';
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
  bool selectedSortByAsc = false;

  @override
  void initState() {
    super.initState();
    selectedSortBy = sortByList.first;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IngredientListManager>(
      builder: (context, listManager, child) {
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
                    Expanded(
                      child: ListView.builder(
                        itemCount: listManager.items.length,
                        itemBuilder: (context, index) {
                          return ingredientCard(
                            listManager.items[index],
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
