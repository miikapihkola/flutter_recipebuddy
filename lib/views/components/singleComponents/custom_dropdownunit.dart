import 'package:flutter/material.dart';
import '../../../data/constants.dart';

class CustomDropdownUnit extends StatelessWidget {
  final String? value;
  final List<String> list;
  final Function(dynamic) onChanged;
  final bool disabled;

  const CustomDropdownUnit({
    super.key,
    required this.value,
    this.list = unitsList,
    required this.onChanged,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<dynamic>> items = list
        .map(
          (item) =>
              DropdownMenuItem(value: item, child: Text(item, softWrap: true)),
        )
        .toList();
    return SizedBox(
      width: 80,
      child: DropdownButton(
        isExpanded: true,
        itemHeight: null,
        icon: Icon(Icons.arrow_drop_down, color: Colors.black),
        underline: Container(height: 2, color: Colors.blueGrey),
        padding: EdgeInsets.only(top: 10),
        items: items,
        onChanged: disabled ? null : onChanged,
        value: value,
        selectedItemBuilder: (context) => list
            .map(
              (item) => SizedBox(
                height: 48,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
