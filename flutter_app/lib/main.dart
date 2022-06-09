import 'dart:html';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/list/list_user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(UserApp());
}

class UserApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Users",
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.pink,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.pink,
        ),
        home: HomePageMain(),
        routes: <String, WidgetBuilder>{});
  }
}

class HomePageMain extends StatefulWidget {
  @override
  _SearchilisState createState() => new _SearchilisState();
}

class _SearchilisState extends State<HomePageMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListUser(),
    );
  }
}
