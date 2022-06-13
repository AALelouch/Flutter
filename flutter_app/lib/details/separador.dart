import 'package:flutter/material.dart';

class Separador extends StatelessWidget {
  const Separador({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      height: 2.0,
      width: 18.0,
      color: Colors.grey[400],
    );
  }
}
