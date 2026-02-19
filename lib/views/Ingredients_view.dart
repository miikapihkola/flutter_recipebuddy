import 'package:flutter/material.dart';
import 'components/filter/FilterIngredients.dart';
import '../data/ingredient_list_manager.dart';
import 'package:provider/provider.dart';
import 'components/filter/FilterBar.dart';
import 'components/cards/IngredientCard.dart';
import 'components/singleComponents/custom_divider.dart';

class IngredientsView extends StatefulWidget {
  const IngredientsView({super.key});

  @override
  State<IngredientsView> createState() => _IngredientsViewState();
}

class _IngredientsViewState extends State<IngredientsView> {
  final List<String> categoryList = ["All", "Unspecified"];
  final List<String> subcategoryList = ["All", "Unspecified"];
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
  String selectedCategory = "";
  String selectedSubcategory = "";
  String selectedTextSearch = "";
  String selectedSortBy = "";
  bool selectedSortByAsc = false;

  @override
  void initState() {
    super.initState();
    selectedCategory = categoryList.first;
    selectedSubcategory = subcategoryList.first;
    selectedSortBy = sortByList.first;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IngredientListManager>(
      builder: (context, listManager, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Ingredients"),
            actions: [
              IconButton(
                iconSize: Theme.of(context).iconTheme.size,
                onPressed: () {},
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
