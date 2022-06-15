import 'dart:html';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/agregar/validate_text.dart';

import 'login/login_summary.dart';

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
          ],
        ),
      ),
    );
  }
}
