import 'dart:async';
import 'dart:html';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/agregar/validate_text.dart';
import 'package:flutter_app/global.dart';
import 'package:flutter_app/list/user.dart';
import 'package:flutter_app/main.dart';

import 'login/login_summary.dart';
import 'menu/animation_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Login());
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.pink,
      ),
      darkTheme:
          ThemeData(brightness: Brightness.dark, primarySwatch: Colors.pink),
      home: LoginUser(title: 'Login'),
    );
  }
}

class LoginUser extends StatelessWidget {
  final String title;
  const LoginUser({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.black26,
    ));
    return Scaffold(
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  loginFormState createState() {
    return loginFormState();
  }
}

class loginFormState extends State<LoginForm> {
  final _formkey = GlobalKey<FormState>();
  var email = TextEditingController();
  var password = TextEditingController();
  validateText validate = validateText();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Stack(
          children: [_getContent()],
        ),
      ),
    );
  }

  Container _getContent() {
    return Container(
      child: Form(
        key: _formkey,
        child: ListView(
          children: [
            LoginSummary(horizontal: false),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: 20.0),
                decoration: InputDecoration(
                  labelText: "Enter Email",
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(),
                  ),
                ),
                validator: validate.validateEmail,
                controller: email,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: TextFormField(
                obscureText: true,
                style: TextStyle(fontSize: 20.0),
                decoration: InputDecoration(
                  labelText: "Enter Password",
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.enhanced_encryption),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(),
                  ),
                ),
                validator: validate.validatePassword,
                controller: password,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
              child: MaterialButton(
                  minWidth: 200.0,
                  height: 60.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      signInWithCredentials(context);
                    }
                  },
                  child: setUpButtonChild(),
                  color: Colors.deepOrangeAccent),
            ),
          ],
        ),
      ),
    );
  }

  int _state = 0;
  Widget setUpButtonChild() {
    if (_state == 0) {
      return Text(
        "log in",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      );
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Text(
        "log in",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      );
    }
  }

  void animateButton() {
    setState(() {
      _state = 1;
    });
    Timer(Duration(seconds: 60), () {
      setState(() {
        _state = 2;
      });
    });
  }

  void signInWithCredentials(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final _db = FirebaseFirestore.instance;
    animateButton();
    _auth
        .signInWithEmailAndPassword(email: email.text, password: password.text)
        .then((value) {
      // a change was made using the map
      Future<DocumentSnapshot<Map<String, dynamic>>> snapshot =
          _db.collection('Users').doc(email.text).get();
      snapshot.then((DocumentSnapshot<Map<String, dynamic>> user) {
        Global.user = Users(
          user.data()!['LastName'],
          user.data()!['Emoji'],
          user.data()!['Name'],
          user.data()!['Image'],
          user.id,
          user.data()!['Role'],
          user.data()!['Active'],
        );
        Navigator.push(context, Animation_route(UserApp()))
            .whenComplete(() => Navigator.of(context).pop());
      });
    }).catchError((e) {
      setState(() {
        _state = 2;
      });
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    });
  }
}
