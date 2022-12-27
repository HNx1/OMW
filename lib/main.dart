import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:omw/admin/admin_screen.dart';
import 'package:omw/authentication/WelcomeScreen.dart';
import 'package:omw/authentication/addProfileScreen.dart';
import 'package:omw/authentication/signUp.dart';
import 'package:omw/bottom/Chat/IndividualChat/individual_chat_Room.dart';
import 'package:omw/bottom/Events/event/eventDetails_screen.dart';
import 'package:omw/notifier/CookieData.dart';
import 'package:omw/preference/preference.dart';
import 'package:omw/splash/spalsh.dart';
import 'package:omw/widget/routesFile.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'authentication/loginScreen.dart';

import 'bottom/bottomtab.dart';
import 'bottom/payment/payment_screen.dart';
import 'constant/theme.dart';

import 'notifier/AllChatingFunctions.dart';
import 'notifier/authenication_notifier.dart';
import 'notifier/changenotifier.dart';
import 'notifier/chatting_notifier.dart';
import 'notifier/event_notifier.dart';
import 'notifier/group_notifier.dart';
import 'notifier/notication_notifier.dart';
import 'dart:async';

import 'notifier/payment_notifier.dart';

ValueNotifier<int> notificationCounterValueNotifer = ValueNotifier(0);
late AndroidNotificationChannel channel;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
String? link;
String? eventId;

String? eventHostUserId;

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
AllChat chat = AllChat("");
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAuth.instance;

  Stripe.publishableKey =
      'pk_test_51LE9ZpLtPhgIm71dX7m1rLR3B3Vi5exebNDqQATBXNcC1knzvy3tYqt1gfI49geOyiPLXdkUPbyQ7kShg5eCMPSX00qGr7YNGe';
  await Stripe.instance.applySettings();
  await PrefServices().init();

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title

      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    notificationCounterValueNotifer.value++;

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: '@mipmap/ic_launcher',
            ),
          ),
          payload: json.encode(message.data));

      await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        ),
        onSelectNotification: (message) async {
          notificationCounterValueNotifer.value = 0;
          print("object${message}");
          var data = json.decode(message!);
          if (data["type"] == "Chatting") {
            chat = AllChat(
              data["sendBy"],
              conversationId: data["conversationId"],
            );
            await chat.fetchMessages().then((value) {
              navigatorKey.currentState!.pushNamed(Routes.chatting);
            });
            print('chatting');
            return null;
          } else if (data["type"] == "eventInvite") {
            navigatorKey.currentState!.pushNamed(Routes.HOME);
            return null;
          } else if (data["type"] == "multiDate") {
            eventId = data["eventId"];
            eventHostUserId = data["eventHostUserId"];

            print('goto multidate page');
            navigatorKey.currentState!.pushNamed(Routes.eventDetails);
            return null;
          } else {
            navigatorKey.currentState!.pushNamed(Routes.payment);
          }
        },
      );
    }
  });

  try {
    await FirebaseDynamicLinks.instance.getInitialLink().then((value) async {
      print("====link======" + value!.link.query);
      if (value != "") {
        if (value.link.query != "") {
          link = value.link.query;
        }
      }
    });
  } catch (e) {
    print(e);
  }

  FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
    if (dynamicLinkData.link != "") {
      print('Link== ${dynamicLinkData.link}');
      link = dynamicLinkData.link.toString();

      print('goto=>Home');

      navigatorKey.currentState!.pushNamed(Routes.HOME);
    }
  }).onError((error) {
    print(error);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    notificationCounterValueNotifer.value = 0;
    print('A new onMessageOpenedApp event was published!');
    if (message.data["type"] == "Chatting") {
      chat = AllChat(
        message.data["sendBy"],
        conversationId: message.data["conversationId"],
      );
      await chat.fetchMessages().then((value) {
        navigatorKey.currentState!.pushNamed(Routes.chatting);
      });
      print('chatting');
      return null;
    } else if (message.data["type"] == "eventInvite") {
      return null;
    } else if (message.data["type"] == "multiDate") {
      eventId = message.data["eventId"];
      eventHostUserId = message.data["eventHostUserId"];

      print('goto multidate page');
      navigatorKey.currentState!.pushNamed(Routes.eventDetails);
      return null;
    } else {
      navigatorKey.currentState!.pushNamed(Routes.payment);
      return null;
    }
  });

  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then(
    (_) => runApp(
      MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            AppTheme.islight ? Brightness.dark : Brightness.light,
        statusBarBrightness:
            AppTheme.islight ? Brightness.light : Brightness.dark,
        systemNavigationBarColor:
            AppTheme.islight ? Colors.white : Colors.black,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness:
            AppTheme.islight ? Brightness.dark : Brightness.light,
      ),
    );

    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: AppTheme.getTheme().copyWith(),
        routes: routes,
      ),
    );
  }

  List<SingleChildWidget> providers = [
    ChangeNotifierProvider<ProviderNotifier>(create: (_) => ProviderNotifier()),
    ChangeNotifierProvider<AuthenicationNotifier>(
        create: (_) => AuthenicationNotifier()),
    ChangeNotifierProvider<CookiesData>(create: (_) => CookiesData()),
    ChangeNotifierProvider<CreateEventNotifier>(
        create: (_) => CreateEventNotifier()),
    ChangeNotifierProvider<GroupNotifier>(create: (_) => GroupNotifier()),
    ChangeNotifierProvider<NotificationNotifier>(
        create: (_) => NotificationNotifier()),
    ChangeNotifierProvider<ChattingNotifier>(
      create: (_) => ChattingNotifier(),
    ),
    ChangeNotifierProvider<PaymentNotifier>(
      create: (_) => PaymentNotifier(),
    ),
  ];

  var routes = <String, WidgetBuilder>{
    Routes.SPLASH: (BuildContext context) => Spalsh(),
    Routes.Login: (BuildContext context) => LoginScreen(),
    Routes.Welcome: (BuildContext context) => WelcomeScreen(),
    Routes.SignUp: (BuildContext context) => SignUpScreen(),
    Routes.Profile: (BuildContext context) => AddProfileScreen(),
    Routes.HOME: (BuildContext context) => BottomNavBarScreen(
          index: 1,
          lastIndex: 1,
        ),
    Routes.Admin: (BuildContext context) => AdminScreen(),
    Routes.payment: (BuildContext context) => PaymentScreen(),
    Routes.chatting: (BuildContext context) => IndividualChatRoom(
          chat: chat,
        ),
    Routes.eventDetails: (BuildContext context) => EventDetailsScreen(
        isFromMyeventScreen: true,
        isPastEvent: false,
        ismyPastEvent: false,
        eventId: eventId!,
        hostId: eventHostUserId!)
  };
}
