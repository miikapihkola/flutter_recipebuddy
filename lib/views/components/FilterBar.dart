import 'package:flutter/material.dart';

class FilterBar extends StatefulWidget {
  final List<String> categoryList;
  final List<String> subcategoryList;
  final Function(String? category, String? subcategory) onFilterChanged;

  const FilterBar({
    super.key,
    required this.categoryList,
    required this.subcategoryList,
    required this.onFilterChanged,
  });

  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  String? category;
  String? subcategory;

  @override
  void initState() {
    super.initState();
    if (widget.categoryList.isNotEmpty) {
      category = widget.categoryList.first;
    }
    if (widget.subcategoryList.isNotEmpty) {
      subcategory = widget.subcategoryList.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<dynamic>> categoryItems = widget.categoryList
        .map((item) => DropdownMenuItem(value: item, child: Text(item)))
        .toList();
    List<DropdownMenuItem<dynamic>> subcategoryItems = widget.subcategoryList
        .map((item) => DropdownMenuItem(value: item, child: Text(item)))
        .toList();

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text("Main Category", textScaler: TextScaler.linear(1.4)),
              DropdownButton(
                icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                underline: Container(height: 2, color: Colors.blueGrey),
                padding: EdgeInsets.only(bottom: 10),
                items: categoryItems,
                onChanged: (value) {
                  setState(() {
                    category = value;
                    widget.onFilterChanged(category, subcategory);
                  });
                },
                value: category,
              ),
            ],
          ),
          Column(
            children: [
              Text("Sub Category", textScaler: TextScaler.linear(1.4)),
              DropdownButton(
                icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                underline: Container(height: 2, color: Colors.blueGrey),
                padding: EdgeInsets.only(bottom: 10),
                items: subcategoryItems,
                onChanged: (value) {
                  setState(() {
                    subcategory = value;
                    widget.onFilterChanged(category, subcategory);
                  });
                },
                value: subcategory,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
