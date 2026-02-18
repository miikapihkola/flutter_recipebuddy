import 'package:flutter/material.dart';

class FilterBar extends StatefulWidget {
  final List<String> categoryList;
  final List<String> subcategoryList;
  final Function(String category, String subcategory, String textSearch)
  onFilterChanged;

  final String initcategory;
  final String initsubcategory;
  final String initTextSearch;

  const FilterBar({
    super.key,
    required this.categoryList,
    required this.subcategoryList,
    required this.onFilterChanged,
    required this.initcategory,
    required this.initsubcategory,
    required this.initTextSearch,
  });

  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  final List<String> sortByList = ["Alphabetical", "Expire"];

  String category = "";
  String subcategory = "";
  String textSearch = "";

  late TextEditingController _textSearchController;

  @override
  void initState() {
    super.initState();
    category = widget.initcategory;
    subcategory = widget.initsubcategory;
    textSearch = widget.initTextSearch;
    _textSearchController = TextEditingController(text: textSearch);
  }

  @override
  void dispose() {
    _textSearchController.dispose();
    super.dispose();
  }

  void update() {
    widget.onFilterChanged(category, subcategory, textSearch);
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text("Main Category", textScaler: TextScaler.linear(1.4)),
                  SizedBox(
                    width: 200,
                    child: DropdownButton(
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                      underline: Container(height: 2, color: Colors.blueGrey),
                      padding: EdgeInsets.only(top: 10),
                      items: categoryItems,
                      onChanged: (value) {
                        setState(() {
                          category = value;
                          update();
                        });
                      },
                      value: category,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text("Sub Category", textScaler: TextScaler.linear(1.4)),
                  SizedBox(
                    width: 200,
                    child: DropdownButton(
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                      underline: Container(height: 2, color: Colors.blueGrey),
                      padding: EdgeInsets.only(top: 10),
                      items: subcategoryItems,
                      onChanged: (value) {
                        setState(() {
                          subcategory = value;
                          update();
                        });
                      },
                      value: subcategory,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: _textSearchController,
              decoration: InputDecoration(labelText: "Search by Text"),
              onChanged: (value) {
                setState(() {
                  textSearch = value;
                  update();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
