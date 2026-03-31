import 'package:flutter/material.dart';

class CustomDeleteBtn {
  static void show({
    required BuildContext context,
    required String itemName,
    required Future<void> Function() onDelete,
    String? warningMessage, // if provided, shows second dialog
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete $itemName"),
        content: Text("Are you sure you want to delete this $itemName?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              if (warningMessage != null) {
                if (!context.mounted) return;
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Warning"),
                    content: Text(warningMessage),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () async {
                          await onDelete();
                          if (!context.mounted) return;
                          Navigator.pop(context); // close warning dialog
                          Navigator.pop(context); // close first dialog
                          Navigator.pop(context); // go back to list
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: Text("Delete anyway"),
                      ),
                    ],
                  ),
                );
              } else {
                await onDelete();
                if (!context.mounted) return;
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // go back to list
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }
}
