import 'package:flutter/material.dart';
import '../data/ingredient_list_manager.dart';
import 'package:provider/provider.dart';
import '../data/ingredient_item.dart';
import 'package:intl/intl.dart';
import 'components/FilterBar.dart';

class IngredientsView extends StatefulWidget {
  const IngredientsView({super.key});

  @override
  State<IngredientsView> createState() => _IngredientsViewState();
}

class _IngredientsViewState extends State<IngredientsView> {
  List<String> categoryList = ["All", "Unspecified"];
  List<String> subcategoryList = ["All", "Unspecified"];
  String? selectedCategory;
  String? selectedSubcategory;

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
            ],
          ),
          body: Builder(
            builder: (context) {
              if (listManager.items.isEmpty) {
                return Text("No Ingredients");
              } else {
                return Column(
                  children: [
                    FilterBar(
                      categoryList: categoryList,
                      subcategoryList: subcategoryList,
                      onFilterChanged: (category, subcategory) {
                        setState(() {
                          selectedCategory = category;
                          selectedSubcategory = subcategory;
                        });
                        // Logic
                      },
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: listManager.items.length,
                        itemBuilder: (context, index) {
                          return _buildIngredientCard(
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

Center _buildIngredientCard(
  IngredientItem item,
  BuildContext context,
  IngredientListManager manager,
) {
  return Center(
    child: Card(
      child: Column(
        children: <Widget>[
          Column(
            children: [
              ListTile(
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.shopping_cart,
                        color: item.isStarred
                            ? Colors.deepOrange
                            : Colors.blueGrey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.star,
                        color: item.isStarred
                            ? Colors.deepOrange
                            : Colors.blueGrey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.shelves),
                      color: _getColor(item.status),
                    ),
                    IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                  ],
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(item.name)],
                ),
                subtitle: item.expire != null
                    ? Text(
                        DateFormat("dd.MM.yyyy").format(item.expire!),
                        textScaler: TextScaler.linear(1.1),
                        style: TextStyle(
                          color: item.expire!.isAfter(DateTime.now())
                              ? Colors.black
                              : Colors.red,
                        ),
                      )
                    : Container(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
                child: Column(
                  children: [
                    item.description != ""
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(item.description),
                            ),
                          )
                        : Container(),
                    item.currentAmount != 0
                        ? Row(
                            children: [
                              Text(item.currentAmount.toString()),
                              SizedBox(width: 4),
                              Text(item.unit.toString()),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Color _getColor(int state) {
  switch (state) {
    case 0:
      return Colors.red;
    case 1:
      return Colors.yellow;
    case 2:
      return Colors.green;
    case 3:
      return Colors.blueGrey;
    default:
      return Colors.black;
  }
}
