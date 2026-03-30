import 'package:flutter/material.dart';
import '../data/database_provider.dart';
import '../data/settings_helper.dart';
import 'package:flutter/foundation.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool preferOriginalUnit = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final preferOriginalUnitValue = await SettingsHelper.instance
        .getPreferOriginalUnit();
    setState(() {
      preferOriginalUnit = preferOriginalUnitValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CheckboxListTile(
              title: Text("Ingredient: Add using original unit"),
              value: preferOriginalUnit,
              onChanged: (value) async {
                setState(() {
                  preferOriginalUnit = value!;
                });
                await SettingsHelper.instance.setPreferOriginalUnit(value!);
              },
            ),

            // Debug buttons
            if (kDebugMode)
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await DatabaseProvider.instance.clearAll();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: Text("DEBUG: Clear DB"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await DatabaseProvider.instance.debugDeleteDatabase();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: Text("DEBUG: Delete DB"),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
