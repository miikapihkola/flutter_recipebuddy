import 'package:flutter/material.dart';
import '../data/ingredient_list_manager.dart';
import 'package:provider/provider.dart';
import '../data/ingredient_item.dart';
import 'package:intl/intl.dart';

class IngredientsView extends StatelessWidget {
  const IngredientsView({super.key});

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
                return ListView.builder(
                  itemCount: listManager.items.length,
                  itemBuilder: (context, index) {
                    return _buildIngredientCard(
                      listManager.items[index],
                      context,
                      listManager,
                    );
                  },
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
          ListTile(
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.shopping_cart,
                    color: item.isStarred ? Colors.deepOrange : Colors.blueGrey,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.star,
                    color: item.isStarred ? Colors.deepOrange : Colors.blueGrey,
                  ),
                ),
              ],
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.name),
                item.expire != null
                    ? Text(
                        DateFormat("dd.MM.yyyy").format(item.expire!),
                        textScaler: TextScaler.linear(0.9),
                        style: TextStyle(
                          color: item.expire!.isAfter(DateTime.now())
                              ? Colors.black
                              : Colors.red,
                        ),
                      )
                    : Container(),
              ],
            ),
            subtitle: Text(item.description),
          ),
        ],
      ),
    ),
  );
}
