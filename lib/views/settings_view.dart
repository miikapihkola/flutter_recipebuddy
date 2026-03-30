import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/database_provider.dart';
import '../data/settings_helper.dart';
import 'package:flutter/foundation.dart';
import '../data/notification_helper.dart';
import '../data/ingredient/ingredient_list_manager.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool preferOriginalUnit = false;
  bool notificationsEnabled = true;
  int notificationHour = 12;
  int notificationDaysBefore = 3;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final preferOriginalUnitValue = await SettingsHelper.instance
        .getPreferOriginalUnit();
    final notificationsEnabledValue = await SettingsHelper.instance
        .getNotificationsEnabled();
    final notificationHourValue = await SettingsHelper.instance
        .getNotificationHour();
    final notificationDaysBeforeValue = await SettingsHelper.instance
        .getNotificationDaysBefore();
    setState(() {
      preferOriginalUnit = preferOriginalUnitValue;
      notificationsEnabled = notificationsEnabledValue;
      notificationHour = notificationHourValue;
      notificationDaysBefore = notificationDaysBeforeValue;
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
            CheckboxListTile(
              title: Text("Enable expiry notifications"),
              value: notificationsEnabled,
              onChanged: (value) async {
                final manager = Provider.of<IngredientListManager>(
                  context,
                  listen: false,
                );
                setState(() => notificationsEnabled = value!);
                await SettingsHelper.instance.setNotificationsEnabled(value!);
                await NotificationHelper.instance.rescheduleAllNotifications(
                  manager.items.toList(),
                );
              },
            ),
            if (notificationsEnabled)
              Column(
                children: [
                  ListTile(
                    title: Text("Notification time"),
                    trailing: DropdownButton<int>(
                      value: notificationHour,
                      items: List.generate(24, (i) => i)
                          .map(
                            (h) => DropdownMenuItem(
                              value: h,
                              child: Text('${h.toString().padLeft(2, '0')}:00'),
                            ),
                          )
                          .toList(),
                      onChanged: (value) async {
                        final manager = Provider.of<IngredientListManager>(
                          context,
                          listen: false,
                        );
                        setState(() => notificationHour = value!);
                        await SettingsHelper.instance.setNotificationHour(
                          value!,
                        );
                        await NotificationHelper.instance
                            .rescheduleAllNotifications(manager.items.toList());
                      },
                    ),
                  ),
                  ListTile(
                    title: Text("Notify days before expiry"),
                    trailing: DropdownButton<int>(
                      value: notificationDaysBefore,
                      items: [0, 1, 2, 3, 5, 7]
                          .map(
                            (d) => DropdownMenuItem(
                              value: d,
                              child: Text('$d days'),
                            ),
                          )
                          .toList(),
                      onChanged: (value) async {
                        final manager = Provider.of<IngredientListManager>(
                          context,
                          listen: false,
                        );
                        setState(() => notificationDaysBefore = value!);
                        await SettingsHelper.instance.setNotificationDaysBefore(
                          value!,
                        );
                        await NotificationHelper.instance
                            .rescheduleAllNotifications(manager.items.toList());
                      },
                    ),
                  ),
                ],
              ),
            // Debug buttons
            if (kDebugMode)
              Padding(
                padding: const EdgeInsets.only(top: 40),
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
