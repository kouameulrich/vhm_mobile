import 'dart:io';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:vhm_mobile/di/service_locator.dart';
import 'package:vhm_mobile/ui/pages/Members/liste.members.dart';
import 'package:vhm_mobile/ui/pages/Members/reset.data.page.dart';
import 'package:vhm_mobile/ui/pages/Members/synchronisation.page.dart';
import 'package:vhm_mobile/ui/pages/home.page.dart';
import 'package:vhm_mobile/widgets/navigator_key.dart';

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = DevHttpOverrides();
  setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        navigatorKey: navigatorKey,
        routes: {
          // '/': (context) => const SplashScreen(),
          // '/loginpage': (context) => LoginPage(),
          '/': (context) => const HomePage(),
          '/listMembers': (context) => const ListMembersPage(),
          '/syncMembers': (context) => const SynchroMembersDataPage(),
          '/resetMembers': (context) => const ResetMembersDataPage(),
        },
        title: 'VHM APP',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        initialRoute: '/',
      ),
    );
  }
}
