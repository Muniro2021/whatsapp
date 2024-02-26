import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:uct_chat/features/admin_home_feature/cubit/home_screen_cubit.dart';
import 'package:uct_chat/features/chat_screen/cubit/chat_screen_cubit.dart';
import 'package:uct_chat/features/create_update_screen/create_update_screen.dart';
import 'package:uct_chat/features/login_feature/cubit/login_screen_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uct_chat/features/splash_screen/splash_screen.dart';
import 'package:uct_chat/features/user_home_feature/cubit/home_screen_cubit.dart';
import 'firebase_options.dart';

//global object for accessing device screen size
late Size mq;
final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //enter full-screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await FlutterDownloader.initialize(
      debug: true // Set it to false in release mode
      );
  //for setting orientation to portrait only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) {
    _initializeFirebase();
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChatScreenCubit(),
        ),
        BlocProvider(
          create: (context) => AdminHomeScreenCubit(),
        ),
        BlocProvider(
          create: (context) => UserHomeScreenCubit(),
        ),
        BlocProvider(
          create: (context) => LoginScreenCubit(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'UCT Chat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 1,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 19,
            ),
            backgroundColor: Colors.white,
          ),
        ),
        home: const SplashScreen(),
        routes: {
          CreateUpdateScreen.route: (context) => const CreateUpdateScreen()
        },
      ),
    );
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FlutterNotificationChannel.registerNotificationChannel(
    description: 'For Showing Message Notification',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats',
    allowBubbles: true,
    enableSound: true,
    enableVibration: true,
  );
  await FlutterNotificationChannel.registerNotificationChannel(
    description: 'For Showing Updates Message Notification',
    id: 'updates',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Updates',
    allowBubbles: true,
    enableSound: true,
    enableVibration: true,
  );
  await FlutterNotificationChannel.registerNotificationChannel(
    description: 'For Showing Leaves Message Notification',
    id: 'leaves',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Leaves',
    allowBubbles: true,
    enableSound: true,
    enableVibration: true,
  );
  // APIsMessage.initPushNotification();
  // APIsMessage.initLocalNotifications();
}
