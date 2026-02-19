import 'package:flutter/material.dart';
import '../singleComponents/custom_divider.dart';
import '../singleComponents/custom_iconbtn1.dart';

class FilterIngredients extends StatefulWidget {
  final List<bool> initIncludeShoppinglist; // no, yes
  final List<bool> initIncludeStarred; // no, yes
  final List<bool> initIncludeStatus; // [R, Y, G, unknown]
  final Function(
    List<bool> includeShoppinglist,
    List<bool> includeStarred,
    List<bool> includeStatus,
  )
  onFilterChanged;

  const FilterIngredients({
    super.key,
    required this.initIncludeShoppinglist,
    required this.initIncludeStarred,
    required this.initIncludeStatus,
    required this.onFilterChanged,
  });

  @override
  _FilterIngredientsState createState() => _FilterIngredientsState();
}

class _FilterIngredientsState extends State<FilterIngredients> {
  List<bool> includeShoppinglist = [];
  List<bool> includeStarred = [];
  List<bool> includeStatus = [];

  @override
  void initState() {
    super.initState();
    includeShoppinglist = widget.initIncludeShoppinglist;
    includeStarred = widget.initIncludeStarred;
    includeStatus = widget.initIncludeStatus;
  }

  void update() {
    widget.onFilterChanged(includeShoppinglist, includeStarred, includeStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 5),
          Text("Include:"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomIconBtn1(
                icon: Icon(Icons.shopping_cart, color: Colors.blueGrey),
                bgOn: includeShoppinglist[0],
                onPressed: () {
                  includeShoppinglist[0] = !includeShoppinglist[0];
                  update();
                },
              ),
              CustomIconBtn1(
                icon: Icon(Icons.shopping_cart, color: Colors.deepOrange),
                bgOn: includeShoppinglist[1],
                onPressed: () {
                  includeShoppinglist[1] = !includeShoppinglist[1];
                  update();
                },
              ),
              CustomIconBtn1(
                icon: Icon(Icons.star, color: Colors.blueGrey),
                bgOn: includeStarred[0],
                onPressed: () {
                  includeStarred[0] = !includeStarred[0];
                  update();
                },
              ),
              CustomIconBtn1(
                icon: Icon(Icons.star, color: Colors.deepOrange),
                bgOn: includeStarred[1],
                onPressed: () {
                  includeStarred[1] = !includeStarred[1];
                  update();
                },
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomIconBtn1(
                icon: Icon(Icons.shelves, color: Colors.blueGrey),
                bgOn: includeStatus[3],
                onPressed: () {
                  includeStatus[3] = !includeStatus[3];
                  update();
                },
              ),
              CustomIconBtn1(
                icon: Icon(Icons.shelves, color: Colors.red),
                bgOn: includeStatus[0],
                onPressed: () {
                  includeStatus[0] = !includeStatus[0];
                  update();
                },
              ),
              CustomIconBtn1(
                icon: Icon(Icons.shelves, color: Colors.amber),
                bgOn: includeStatus[1],
                onPressed: () {
                  includeStatus[1] = !includeStatus[1];
                  update();
                },
              ),
              CustomIconBtn1(
                icon: Icon(Icons.shelves, color: Colors.green),
                bgOn: includeStatus[2],
                onPressed: () {
                  includeStatus[2] = !includeStatus[2];
                  update();
                },
              ),
            ],
          ),
          CustomDivider(tb: [10, 0]),
        ],
      ),
    );
  }
}
