import 'package:flutter/material.dart';
import '../Ingredients_view.dart';
import 'singleComponents/custom_dropdown.dart';
import 'singleComponents/custom_divider.dart';

class FilterBar extends StatefulWidget {
  final List<String> categoryList;
  final List<String> subcategoryList;
  final List<String> sortByList;
  final Function(
    String category,
    String subcategory,
    String textSearch,
    String sortBy,
    bool sortByAsc,
  )
  onFilterChanged;

  final Widget viewType;
  final String initcategory;
  final String initsubcategory;
  final String initTextSearch;
  final String initSortBy;
  final bool initSortByAsc;

  const FilterBar({
    super.key,
    required this.viewType,
    required this.categoryList,
    required this.subcategoryList,
    required this.onFilterChanged,
    required this.initcategory,
    required this.initsubcategory,
    required this.initTextSearch,
    required this.initSortBy,
    required this.sortByList,
    required this.initSortByAsc,
  });

  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  String category = "";
  String subcategory = "";
  String textSearch = "";
  String sortBy = "";
  bool sortByAsc = false;

  late TextEditingController _textSearchController;

  @override
  void initState() {
    super.initState();
    category = widget.initcategory;
    subcategory = widget.initsubcategory;
    textSearch = widget.initTextSearch;
    sortBy = widget.initSortBy;
    sortByAsc = widget.initSortByAsc;
    _textSearchController = TextEditingController(text: textSearch);
  }

  @override
  void dispose() {
    _textSearchController.dispose();
    super.dispose();
  }

  void update() {
    widget.onFilterChanged(
      category,
      subcategory,
      textSearch,
      sortBy,
      sortByAsc,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CustomDivider(tb: [2, 10]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 200,
                child: Column(
                  children: [
                    Text("Main Category", textScaler: TextScaler.linear(1.4)),
                    CustomDropdown(
                      value: category,
                      list: widget.categoryList,
                      onChanged: (value) {
                        setState(() {
                          category = value;
                          update();
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _textSearchController,
                      decoration: InputDecoration(labelText: "Search by Text"),
                      onChanged: (value) {
                        setState(() {
                          textSearch = value;
                          update();
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 200,
                child: Column(
                  children: [
                    Text("Sub Category", textScaler: TextScaler.linear(1.4)),
                    CustomDropdown(
                      value: subcategory,
                      list: widget.subcategoryList,
                      onChanged: (value) {
                        setState(() {
                          subcategory = value;
                          update();
                        });
                      },
                    ),
                    Text("Order by:"),
                    Row(
                      children: [
                        SizedBox(
                          width: 150,
                          child: CustomDropdown(
                            value: sortBy,
                            list: widget.sortByList,
                            onChanged: (value) {
                              setState(() {
                                sortBy = value;
                                update();
                              });
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              sortByAsc = !sortByAsc;
                              update();
                            });
                          },
                          icon: Icon(
                            sortByAsc
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Builder(
            builder: (context) {
              switch (widget.viewType) {
                case IngredientsView():
                  return Text("placeholder for ingredients filter");
                default:
                  return Container();
              }
            },
          ),
          CustomDivider(tb: [10, 0]),
        ],
      ),
    );
  }
}
