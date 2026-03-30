import 'package:flutter/material.dart';
import '../../subviews/ingredient/input_ingredient_update_amounts.dart';
import 'package:intl/intl.dart';
import '../../../data/ingredient/ingredient_item.dart';
import '../../../data/ingredient/ingredient_list_manager.dart';
import '../../subviews/ingredient/input_ingredient_view.dart';

Center shoppinglistCard(
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
                      onPressed: () {
                        manager.removeFromShoppinglist(item);
                      },
                      icon: Icon(
                        Icons.remove_shopping_cart,
                        color: const Color.fromARGB(255, 160, 0, 0),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InputIngredientView(
                              item: item,
                              fromShoppinglist: true,
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                InputIngredientUpdateAmountsView(
                                  item: item,
                                  isAddition: true,
                                ),
                          ),
                        );
                      },
                      icon: Icon(Icons.shopping_cart_checkout),
                    ),
                  ],
                ),
                title: Text(
                  item.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                subtitle: item.expire != null
                    ? Row(
                        children: [
                          Text("Exp. ", textScaler: TextScaler.linear(1.1)),
                          Text(
                            DateFormat("dd.MM.yyyy").format(item.expire!),
                            textScaler: TextScaler.linear(1.1),
                            style: TextStyle(
                              color: item.expire!.isAfter(DateTime.now())
                                  ? Colors.black
                                  : Colors.red,
                            ),
                          ),
                        ],
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
                    Row(
                      children: [
                        item.currentAmount != 0
                            ? Row(
                                children: [
                                  Text(item.currentAmount.toString()),
                                  SizedBox(width: 4),
                                  Text(item.unit.toString()),
                                  SizedBox(width: 4),
                                ],
                              )
                            : Container(),
                        item.amountToBuy != 0
                            ? Row(
                                children: [
                                  Text(" + "),
                                  Text(item.amountToBuy.toString()),
                                  SizedBox(width: 4),
                                  Text(item.buyUnit.toString()),
                                ],
                              )
                            : Container(),
                      ],
                    ),
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
