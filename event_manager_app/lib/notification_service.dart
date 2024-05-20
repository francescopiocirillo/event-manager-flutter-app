import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz1;
import 'package:timezone/timezone.dart' as tz2;
import 'package:event_manager_app/home_page.dart';

class NotificationService {
  static int idNotification = 0;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    init();
  }

  init() async {
    print("PIPPOPAPERINO");
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    tz1.initializeTimeZones();
    print(tz2.getLocation(currentTimeZone).toString());
    tz2.setLocalLocation(tz2.getLocation(currentTimeZone));

    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings = DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  getAndroidNotificationDetails() {
    return const AndroidNotificationDetails(
      'reminder',
      'Reminder Notification',
      channelDescription: 'Notification sent as reminder',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      category: AndroidNotificationCategory.alarm,
      icon: '@mipmap/ic_launcher',
      groupKey: 'com.varadgauthankar.simple_reminder.REMINDER',
    );
  }

  getIosNotificationDetails() {
    return DarwinNotificationDetails();
  }

  getNotificationDetails() {
    return NotificationDetails(
      android: getAndroidNotificationDetails(),
      iOS: getIosNotificationDetails(),
    );
  }

  Future scheduleNotification(Event event) async {
    DateTime notificationIstant = DateTime(event.startDate.year, event.startDate.month, event.startDate.day, (event.startHour.hour).toInt(), (event.startHour.minute).toInt());
    if (event.startDate != null) {
      flutterLocalNotificationsPlugin.zonedSchedule(
        idNotification++,
        event.title,
        event.description,
        notificationTime(notificationIstant),
        getNotificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode:  AndroidScheduleMode.exactAllowWhileIdle,
      );
      print('notification set at ${notificationIstant}');
    } else {
      return;
    }
  }
/*
  Future<bool> reminderHasNotification(Reminder reminder) async {
    var pendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotifications
        .any((notification) => notification.id == reminder.key);
  }

  void updateNotification(Reminder reminder) async {
    var hasNotification = await reminderHasNotification(reminder);
    if (hasNotification) {
      flutterLocalNotificationsPlugin.cancel(reminder.key);
    }

    scheduleNotification(reminder);
  }

  void cancelNotification(int id) {
    flutterLocalNotificationsPlugin.cancel(id);
    print('$id canceled');
  }
*/
  tz2.TZDateTime notificationTime(DateTime dateTime) {
    return tz2.TZDateTime(
      tz2.local,
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
    );
  }
}