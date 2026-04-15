import 'package:flutter/material.dart';
import '../../../../data/recipe/recipe_item.dart';

class CookStepTile extends StatelessWidget {
  final CookStep step;
  const CookStepTile({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step header
            Row(
              children: [
                Text(
                  "Step ${step.order}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (step.type.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(
                      step.type,
                      style: const TextStyle(fontSize: 11),
                    ),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
                const Spacer(),
                if (step.durationMinutes > 0)
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 16),
                      const SizedBox(width: 4),
                      Text("${step.durationMinutes} min"),
                    ],
                  ),
              ],
            ),

            // Description
            if (step.description.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(step.description),
            ],
          ],
        ),
      ),
    );
  }
}
