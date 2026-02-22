import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime? date;
  final ValueChanged<DateTime?> onChanged;
  final String label;

  const CustomDatePicker({
    super.key,
    required this.date,
    required this.onChanged,
    this.label = "Date",
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  final formatter = DateFormat("dd.MM.yyyy");

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("${widget.label}: "),
        Text(widget.date != null ? formatter.format(widget.date!) : "Not set"),
        TextButton(
          onPressed: () async {
            var newDate = await showDatePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (newDate == null) return;
            widget.onChanged(newDate);
          },
          child: const Text("Edit"),
        ),
        if (widget.date != null)
          TextButton(
            onPressed: () {
              widget.onChanged(null);
            },
            child: const Text("Remove"),
          ),
      ],
    );
  }
}
