import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/details/separador.dart';

import '../global.dart';
import '../list/user.dart';

class UserSummary extends StatelessWidget {
  late final bool horizontal;
  late Users _doc;
  UserSummary({Key? key, required this.horizontal}) : super(key: key) {
    _doc = Global.doc!;
  }

  @override
  Widget build(BuildContext context) {
    final imageThumbnail = Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      alignment:
          horizontal ? FractionalOffset.centerLeft : FractionalOffset.center,
      child: Container(
        height: 30.0,
        width: 90.0,
        decoration: BoxDecoration(
            color: Colors.pink,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(50.0),
            image: DecorationImage(
              image: NetworkImage(_doc.Image),
              fit: BoxFit.cover,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 3.0,
                offset: Offset(1.0, 5.0),
              )
            ]),
      ),
    );

    Widget _userValue({required String value, required IconData icono}) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icono, color: Colors.white, size: 15.0),
          Container(
            width: 8.0,
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 15.0),
          ),
        ]),
      );
    }

    final userCardContent = Container(
      margin: EdgeInsets.fromLTRB(
          horizontal ? 76.0 : 16.0, horizontal ? 16.0 : 42.0, 16.0, 16.0),
      constraints: const BoxConstraints.expand(),
      child: Column(
          crossAxisAlignment:
              horizontal ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Container(
              height: 4.0,
            ),
            Text(
              "${_doc.Name} ${_doc.LastName}",
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            Container(
              height: 10.0,
            ),
            Text(_doc.Emoji),
            const Separador(),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                flex: horizontal ? 1 : 0,
                child: _userValue(value: _doc.Email, icono: Icons.email),
              ),
              Container(
                width: 8.0,
              ),
              Expanded(
                flex: horizontal ? 1 : 0,
                child: _userValue(
                    value: _doc.Role, icono: Icons.admin_panel_settings),
              ),
              Container(
                width: 32.0,
              ),
            ])
          ]),
    );
    final userCard = Container(
      height: horizontal ? 124.0 : 154.0,
      margin: horizontal
          ? const EdgeInsets.only(left: 46.0)
          : const EdgeInsets.only(top: 72.0),
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            )
          ]),
      child: userCardContent,
    );
    return userCard;
  }
}
