import 'package:flutter/material.dart';
import 'singleComponents/custom_divider.dart';
import 'singleComponents/custom_iconbtn1.dart';

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
                bgOn: true,
                onPressed: () {},
              ),
              CustomIconBtn1(
                icon: Icon(Icons.shopping_cart, color: Colors.deepOrange),
                bgOn: true,
                onPressed: () {},
              ),
              CustomIconBtn1(
                icon: Icon(Icons.star, color: Colors.blueGrey),
                bgOn: true,
                onPressed: () {},
              ),
              CustomIconBtn1(
                icon: Icon(Icons.star, color: Colors.deepOrange),
                bgOn: true,
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomIconBtn1(
                icon: Icon(Icons.shelves, color: Colors.blueGrey),
                bgOn: true,
                onPressed: () {},
              ),
              CustomIconBtn1(
                icon: Icon(Icons.shelves, color: Colors.red),
                bgOn: true,
                onPressed: () {},
              ),
              CustomIconBtn1(
                icon: Icon(Icons.shelves, color: Colors.yellow),
                bgOn: true,
                onPressed: () {},
              ),
              CustomIconBtn1(
                icon: Icon(Icons.shelves, color: Colors.green),
                bgOn: true,
                onPressed: () {},
              ),
            ],
          ),
          CustomDivider(tb: [10, 0]),
        ],
      ),
    );
  }
}
