import 'package:co_op/screens/workout/workout_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:co_op/provider/dark_theme_provider.dart';
import 'package:co_op/screens/splash_screen.dart';
import 'package:co_op/search/clock.dart';
import 'package:co_op/search/request.dart';
import 'package:co_op/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'constants/constants.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await Future.delayed(Duration(seconds: 2));
/* 
  Get.to(Clock()); */
  print("Handling a background message: ${message.data}");
}

Future<void> _handleMessage(RemoteMessage message) async {
  print('naviagate1 ');
  await Future.delayed(Duration(seconds: 2));

  if (type == '0') {
    print('trueeeeeeeeeeeeeeeeeeeeeee');
    /*  Get.defaultDialog(
        title: "Request",
        middleText: "",
        backgroundColor: Colors.white,
        titleStyle: TextStyle(color: Colors.black),
        middleTextStyle: TextStyle(color: Colors.black),
        confirm: Container(
          child: Text('Accept'),
        ),
        cancel: Container(
          child: Text('Decline'),
        ),
        onConfirm: () {
          print('confirm');
        },
        onCancel: () {
          print('cancel');
        }); */
    Get.to(() => WorkoutDetail(userId.toString()));
  }
}

Future<void> onSelectNotification(String? payload) async {
  print('naviagate2');

  await Future.delayed(Duration(seconds: 2));
  if (type == '0') {
    print('trueeeeeeeeeeeeeeeeeeeeeee');
    /*  Get.defaultDialog(
        title: "Request",
        middleText: "",
        backgroundColor: Colors.white,
        titleStyle: TextStyle(color: Colors.black),
        middleTextStyle: TextStyle(color: Colors.black),
        confirm: Container(
          child: Text('Accept'),
        ),
        cancel: Container(
          child: Text('Decline'),
        ),
        onConfirm: () {
          print('confirm');
        },
        onCancel: () {
          print('cancel');
        }); */
    Get.to(() => WorkoutDetail(userId.toString()));
  } else if (type == '1') {

    print(userId);
    Get.to(() => WorkoutDetail(userId.toString()));
  }
  // Get.to(Clock());
}

Future<void> setupInteractedMessage() async {
  print('terminated');
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    _handleMessage(initialMessage);
  }
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
}

Future<void> _selectNotification(RemoteMessage message) async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      const AndroidNotificationDetails(
          'high_importance_channel', 'High Importance Notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: "@mipmap/ic_launcher");
  NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  print("message.data");
  print(message.data);
  type = message.data['type'];
  userId = message.data['user_id'];
  id = message.data['id'];

  /*  await FlutterLocalNotificationsPlugin().show(123, message.data['title'],
      message.data['body'], platformChannelSpecifics,
      payload: 'data'); */
  await FlutterLocalNotificationsPlugin().show(123, message.notification!.title,
      message.notification!.body, platformChannelSpecifics,
      payload: 'data');
/*   await FlutterLocalNotificationsPlugin().zonedSchedule(
    123,
    message.notification!.title,
    message.notification!.body,
    tz.TZDateTime.now(tz.local).add(Duration(
        seconds: 1)), //schedule the notification to show after 2 seconds.
    const NotificationDetails(
      // Android details
      android: AndroidNotificationDetails('main_channel', 'Main Channel',
          channelDescription: "ashwin",
          importance: Importance.max,
          priority: Priority.max),
      // iOS details
      iOS: IOSNotificationDetails(
        sound: 'default.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    ),

    // Type of time interpretation
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    androidAllowWhileIdle:
        true, // To show notification even when the app is closed
  ); */

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  FlutterLocalNotificationsPlugin().initialize(initializationSettings,
      onSelectNotification: onSelectNotification);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  setupInteractedMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessageOpenedApp.listen((_handleMessage));
  FirebaseMessaging.onMessage.listen((_selectNotification));

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title // description
      importance: Importance.high,
      playSound: true);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  FirebaseMessaging.instance.requestPermission(
      sound: true, badge: true, alert: true, provisional: true);
  await FirebaseMessaging.instance.getToken().then((value) async {
    print(value);
  });

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => DarkThemeProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  void initState() {
    getCurrentAppTheme();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Sizer(
        builder: (BuildContext context, Orientation orientation, deviceType) {
      return ChangeNotifierProvider(
        create: (_) {
          return themeChangeProvider;
        },
        child: Consumer<DarkThemeProvider>(
            builder: (BuildContext context, value, Widget? child) {
          return GetMaterialApp(
            themeMode: ThemeMode.system,
            useInheritedMediaQuery: true,
            debugShowCheckedModeBanner: false,
            title: 'co_op',
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            //  home: Checking(),
            home: SplashScreen(),
            //   home: SignInScreen(),
          );
        }),
      );
    });
  }
}
