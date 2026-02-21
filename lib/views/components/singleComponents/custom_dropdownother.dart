import 'package:flutter/material.dart';

class CustomDropdownOther extends StatefulWidget {
  final List<String> options;
  final String? initialValue;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const CustomDropdownOther({
    super.key,
    required this.options,
    required this.initialValue,
    required this.onChanged,
    this.validator,
  });

  @override
  State<CustomDropdownOther> createState() => _CustomDropdownOtherState();
}

class _CustomDropdownOtherState extends State<CustomDropdownOther> {
  String selectedValue = "Unspecified";

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue ?? widget.options.first;
  }

  @override
  void didUpdateWidget(covariant CustomDropdownOther oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setState(() {
        selectedValue = widget.initialValue ?? widget.options.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> items = widget.options
        .map((item) => DropdownMenuItem(value: item, child: Text(item)))
        .toList();
    items.add(
      DropdownMenuItem<String>(value: "other", child: Text("Add new +")),
    );
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            DropdownButtonFormField(
              initialValue: selectedValue,
              items: items,
              onChanged: (value) {
                setState(() {
                  selectedValue = value!;
                });
                widget.onChanged(value);
              },
              validator: widget.validator,
            ),
            if (selectedValue == "other")
              TextFormField(
                decoration: InputDecoration(labelText: "New category"),
                onChanged: (value) {
                  widget.onChanged(value);
                },
              ),
          ],
        ),
      ),
    );
  }
}
