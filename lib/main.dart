import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flat_finder/common/about_screen.dart';
import 'package:flat_finder/common/add_details_screen.dart';
import 'package:flat_finder/common/add_screen.dart';
import 'package:flat_finder/common/chat_screen.dart';
import 'package:flat_finder/common/help_and_support_screen.dart';
import 'package:flat_finder/common/login_and_signup/forget_password_screen.dart';
import 'package:flat_finder/common/login_and_signup/login_screen.dart';
import 'package:flat_finder/common/login_and_signup/signup_screen.dart';
import 'package:flat_finder/common/profile_screen.dart';
import 'package:flat_finder/common/setting_screen.dart';
import 'package:flat_finder/common/splace_screen.dart';
import 'package:flat_finder/landlord/bottom_navigation_landlord.dart';
import 'package:flat_finder/tenant/bottom_navigation_tenant.dart';
import 'package:flat_finder/tenant/detail_view_screen.dart';
import 'package:flat_finder/tenant/flat_screen.dart';
import 'package:flat_finder/tenant/home_Screen.dart';
import 'package:flat_finder/tenant/search_screen.dart';
import 'package:flat_finder/theme/colors.dart';
import 'package:flat_finder/widgets/card_large.dart';
import 'package:flat_finder/widgets/edit_profile_screen.dart';
import 'package:flat_finder/widgets/filter_drawer.dart';
import 'package:flat_finder/widgets/profile_navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors().green)
  );
  /// for orientations
  await SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ]
  );

  /// Background & Terminated state listener
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

}

/// --- For notifications --- ///
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background Notifications Received : ${message.notification?.title}" ) ;
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors().grey),
        useMaterial3: true,
      ),

      home: const SplaceScreen()
    );
  }
}
