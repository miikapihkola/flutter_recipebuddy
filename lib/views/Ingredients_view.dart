import 'package:flutter/material.dart';
import '../data/ingredient_list_manager.dart';
import 'package:provider/provider.dart';
import 'components/FilterBar.dart';
import 'components/cards/IngredientCard.dart';
import 'package:flutter/services.dart';

class IngredientsView extends StatefulWidget {
  const IngredientsView({super.key});

  @override
  State<IngredientsView> createState() => _IngredientsViewState();
}

class _IngredientsViewState extends State<IngredientsView> {
  final List<String> categoryList = ["All", "Unspecified"];
  final List<String> subcategoryList = ["All", "Unspecified"];

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
  String sortBy = "Alphabetical";
  bool sortByAsc = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    selectedCategory = categoryList.first;
    selectedSubcategory = subcategoryList.first;
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
                            categoryList: categoryList,
                            subcategoryList: subcategoryList,
                            initcategory: selectedCategory,
                            initsubcategory: selectedSubcategory,
                            initTextSearch: selectedTextSearch,
                            onFilterChanged:
                                (category, subcategory, textSearch) {
                                  setState(() {
                                    selectedCategory = category;
                                    selectedSubcategory = subcategory;
                                    selectedTextSearch = textSearch;
                                  });
                                  // Logic
                                },
                          )
                        : Container(),
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
