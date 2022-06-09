import 'package:flutter/material.dart';
import 'package:flutter_app/agregar/add_user.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/menu/animation_route.dart';

class MenuLateral extends StatefulWidget {
  @override
  Menu createState() => Menu();
}

class Menu extends State<MenuLateral> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text(
              "Alex",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white12,
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.cyanAccent,
              shape: BoxShape.rectangle,
            ),
          ),
          ListTile(
              leading: new Icon(
                Icons.home,
                color: Color(0xffffffff),
              ),
              title: Text("Inicio"),
              onTap: () {
                Navigator.push(context, Animation_route(UserApp()))
                    .whenComplete(() => Navigator.of(context).pop());
              }),
          ListTile(
              leading: new Icon(
                Icons.home,
                color: Color(0xffffffff),
              ),
              title: Text('Registrar'),
              onTap: () {
                Navigator.push(context, Animation_route(AddUser()))
                    .whenComplete(() => Navigator.of(context).pop());
              }),
        ],
      ),
    );
  }
}
