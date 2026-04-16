import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'settings_helper.dart';
import 'ingredient/ingredient_item.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationHelper {
  static final NotificationHelper instance = NotificationHelper._init();
  NotificationHelper._init();

  final _notifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings("@mipmap/ic_launcher");
    const settings = InitializationSettings(android: android);

    await _notifications.initialize(settings: settings);

    // Request permissions
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.requestNotificationsPermission();
  }

  Future<void> rescheduleAllNotifications(List<IngredientItem> items) async {
    await cancelAllNotifications();

    final enabled = await SettingsHelper.instance.getNotificationsEnabled();
    if (!enabled) return;

    final daysBefore = await SettingsHelper.instance
        .getNotificationDaysBefore();
    final hour = await SettingsHelper.instance.getNotificationHour();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Group items
    final Map<String, List<IngredientItem>> groupedByDate = {};

    for (final item in items) {
      if (item.expire == null) continue;

      final expireDate = DateTime(
        item.expire!.year,
        item.expire!.month,
        item.expire!.day,
      );

      if (expireDate.isBefore(today)) continue;

      final startNotifyDate = expireDate.subtract(Duration(days: daysBefore));

      // Loop through each day from startNotifyDate to expireDate
      for (
        var d = startNotifyDate;
        !d.isAfter(expireDate);
        d = d.add(Duration(days: 1))
      ) {
        if (d.isBefore(today)) continue; // skip past dates

        final dateKey = '${d.year}-${d.month}-${d.day}';
        groupedByDate.putIfAbsent(dateKey, () => []).add(item);
      }
    }

    // Schedule one notification per day
    int notificationId = 0;
    for (final entry in groupedByDate.entries) {
      final dateParts = entry.key.split("-");
      final scheduleDate = tz.TZDateTime(
        tz.local,
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
        hour,
      );

      // Skip if schedule time has already passed
      if (scheduleDate.isBefore(tz.TZDateTime.now(tz.local))) continue;

      final itemNames = entry.value.map((i) => i.name).join(", ");
      final count = entry.value.length;
      final body = count == 1
          ? '${entry.value.first.name} is expiring soon!'
          : '$count ingredients expiring soon: $itemNames';

      await _notifications.zonedSchedule(
        id: notificationId++,
        scheduledDate: scheduleDate,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            "expiry_channel",
            "Expiry Notifications",
            channelDescription: "Notification for expiring ingredients",
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexact,
        title: "Expiring ingredients",
        body: body,
      );
    }
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // DEBUG code

  Future<void> debugTestNotification() async {
    if (!kDebugMode) return;

    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate = now.add(Duration(seconds: 10));

    debugPrint("DEBUG: Scheduling test notification for $scheduleDate");
    debugPrint("DEBUG: Current time is $now");

    await _notifications.zonedSchedule(
      id: 999,
      title: "Test notification",
      scheduledDate: scheduleDate,
      body: "This is a test",
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          "expiracy_channel",
          "Expiry Notifications",
          channelDescription: "Notification for expiring ingredients",
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexact,
    );

    await _notifications.show(
      id: 998,
      title: "Immediate test",
      body: "This should appear right now",
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          "expiry_channel",
          "Expiry Notifications",
          importance: Importance.max,
          priority: Priority.max,
        ),
      ),
    );

    debugPrint("DEBUG: Notification scheduled succesfully");

    final pending = await _notifications.pendingNotificationRequests();
    debugPrint("DEBUG: Pending notifications: ${pending.length}");
    for (final n in pending) {
      debugPrint("DEBUG: id=${n.id}, title${n.title}, body${n.body}");
    }
  }
}
