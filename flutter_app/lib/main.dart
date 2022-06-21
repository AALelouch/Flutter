import 'dart:convert';
import 'dart:html';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/global.dart';
import 'package:flutter_app/list/list_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'list/user.dart';

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
    getUser();
    return Scaffold(
      body: ListUser(),
    );
  }

  Future<void> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    late Map userMap = jsonDecode("${prefs.getString("user")}");

    Global?.user = Users.fromJson(userMap);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(Global.user!.Name),
    ));
  }
}
