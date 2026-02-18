import 'package:flutter/material.dart';
import '../data/ingredient_list_manager.dart';
import 'package:provider/provider.dart';
import 'components/FilterBar.dart';
import 'components/cards/IngredientCard.dart';

class IngredientsView extends StatefulWidget {
  const IngredientsView({super.key});

  @override
  State<IngredientsView> createState() => _IngredientsViewState();
}

class _IngredientsViewState extends State<IngredientsView> {
  final List<String> categoryList = ["All", "Unspecified"];
  final List<String> subcategoryList = ["All", "Unspecified"];
  final List<String> sortByList = ["Alphabetical", "Expire", "Recent"];

  final List<bool> includeShoppinglist = [true, true]; // no, yes
  final List<bool> includeStarred = [true, true]; // no, yes
  final List<bool> includeStatus = [
    true,
    true,
    true,
    true,
  ]; // [R, Y, G, unknown]
  String selectedCategory = "";
  String selectedSubcategory = "";
  bool showSearchBar = false;
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
                        ? FilterBar(
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
                          )
                        : Container(
                            padding: EdgeInsets.fromLTRB(5, 2, 5, 0),
                            child: Divider(
                              height: 1,
                              thickness: 2,
                              color: Colors.black,
                            ),
                          ),
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
