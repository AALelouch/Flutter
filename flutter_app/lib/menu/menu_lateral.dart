import 'package:flutter/material.dart';
import 'package:flutter_app/agregar/add_user.dart';
import 'package:flutter_app/global.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/menu/animation_route.dart';

import '../login.dart';

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
              '${Global.user?.Name} ${Global.user?.LastName}',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.rectangle,
              image: DecorationImage(
                image: NetworkImage(Global.user!.Image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
              leading: new Icon(
                Icons.home,
                color: Color(0xffffffff),
              ),
              title: Text("Inicio"),
              onTap: () {
                Global.doc = null;
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
                Global.doc = null;
                Navigator.push(context, Animation_route(AddUser()))
                    .whenComplete(() => Navigator.of(context).pop());
              }),
          ListTile(
            leading: new Icon(
              Icons.close,
              color: Colors.white,
            ),
            title: Text('Salir'),
            onTap: () {
              Global.doc = null;
              Global.user = null;
              Navigator.push(context, Animation_route(Login()))
                  .whenComplete(() => Navigator.of(context).pop());
            },
          ),
        ],
      ),
    );
  }
}
