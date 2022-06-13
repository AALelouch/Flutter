import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/list/user.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/menu/animation_route.dart';

import '../global.dart';
import '../menu/menu_lateral.dart';

class DetailUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Detalles",
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.pink,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.pink,
      ),
      home: const DetailsUser(title: "Detalles"),
    );
  }
}

class DetailsUser extends StatelessWidget {
  final String title;

  const DetailsUser({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          InkWell(
            child: const Icon(
              Icons.arrow_back_ios,
            ),
            onTap: () {
              Navigator.push(context, Animation_route(UserApp()))
                  .whenComplete(() => Navigator.of(context).pop());
            },
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Details(),
      drawer: MenuLateral(),
    );
  }
}

class Details extends StatefulWidget {
  @override
  DetailsFormState createState() {
    return DetailsFormState();
  }
}

class DetailsFormState extends State<Details> {
  late Users _doc;

  DetailsFormState() {
    _doc = Global.doc!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.black26,
        child: Stack(children: [
          _getBackground(),
          _getGradient(),
          _getContent(),
        ]),
      ),
    );
  }

  Container _getBackground() {
    return Container(
      constraints: const BoxConstraints.expand(
        height: 295.0,
      ),
      child: Image.network(
        _doc.Image,
        fit: BoxFit.cover,
        height: 300.0,
      ),
    );
  }

  Container _getGradient() {
    return Container(
      margin: const EdgeInsets.only(top: 190.0),
      height: 110.0,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black26,
            Colors.black38,
          ],
          stops: [0.0, 0.9],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(0.0, 1.0),
        ),
      ),
    );
  }

  Container _getContent() {
    final _overviewTitle = "Informacion".toUpperCase();
    return Container(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(0.0, 72.0, 0.0, 32.0),
        children: [],
      ),
    );
  }
}
