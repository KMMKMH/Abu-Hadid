import 'package:abu_hadid_app/pages/info.dart';
import 'package:abu_hadid_app/pages/login_uid.dart';
import 'package:flutter/material.dart';
import 'package:abu_hadid_app/pages/loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);

  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
    '/': (context) => Loading(),
    '/login_uid': (context) => LoginUid(),
    '/info': (context) => Info(),
  },
));
}

