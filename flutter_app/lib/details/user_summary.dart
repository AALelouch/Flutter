import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

    return imageThumbnail;
  }
}
