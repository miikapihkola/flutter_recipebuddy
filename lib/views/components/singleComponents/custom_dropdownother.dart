import 'package:flutter/material.dart';
import '../../../data/constants.dart';

class CustomDropdownOther extends StatefulWidget {
  final List<String> options;
  final String? initialValue;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;
  final bool disabled;

  const CustomDropdownOther({
    super.key,
    required this.options,
    required this.initialValue,
    required this.onChanged,
    this.validator,
    this.disabled = false,
  });

  @override
  State<CustomDropdownOther> createState() => _CustomDropdownOtherState();
}

class _CustomDropdownOtherState extends State<CustomDropdownOther> {
  String selectedValue = categoryUnspecified;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final allValues = [...widget.options, dropDownOtherAddNewPlaceholder];
    selectedValue = allValues.contains(widget.initialValue)
        ? widget.initialValue!
        : widget.options.first;
  }

  @override
  void didUpdateWidget(covariant CustomDropdownOther oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      final allValues = [...widget.options, dropDownOtherAddNewPlaceholder];
      if (allValues.contains(widget.initialValue)) {
        setState(() {
          selectedValue = widget.initialValue!;
        });
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> items = widget.options
        .map((item) => DropdownMenuItem(value: item, child: Text(item)))
        .toList();
    items.add(
      DropdownMenuItem<String>(
        value: dropDownOtherAddNewPlaceholder,
        child: Text(dropDownOtherVisibleText),
      ),
    );
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: selectedValue,
              items: items,
              onChanged: widget.disabled
                  ? null
                  : (value) {
                      setState(() {
                        selectedValue = value!;
                        _textController.clear();
                      });
                      if (value != dropDownOtherAddNewPlaceholder) {
                        widget.onChanged(value);
                      } else {
                        widget.onChanged(dropDownOtherAddNewPlaceholder);
                      }
                    },
              validator: widget.validator,
              selectedItemBuilder: (context) {
                return items
                    .map(
                      (item) => Text(
                        item.value == dropDownOtherAddNewPlaceholder
                            ? dropDownOtherVisibleText
                            : item.value ?? "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    )
                    .toList();
              },
            ),
            if (selectedValue == dropDownOtherAddNewPlaceholder)
              TextFormField(
                controller: _textController,
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
