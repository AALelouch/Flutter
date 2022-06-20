import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/agregar/validate_text.dart';
import 'package:flutter_app/global.dart';
import 'package:flutter_app/list/user.dart';
import 'package:flutter_app/main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import 'login/login_summary.dart';
import 'menu/animation_route.dart';

SharedPreferences? prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  prefs = await SharedPreferences.getInstance();
  if (prefs?.getString("user") == "") {
    runApp(Login());
  } else {
    runApp(UserApp());
  }
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
            Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 10.0),
                child: _signInButton()),
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

        String encodedUser = jsonEncode(Global.user);
        prefs?.setString('user', encodedUser);
        Navigator.push(context, Animation_route(UserApp()))
            .whenComplete(() => Navigator.of(context).pop());
      });
    }).catchError((e) {
      setState(() {
        _state = 2;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    });
  }

  Future<User?> googleSingIn() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    GoogleSignIn _googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User? user = authResult.user;
    assert(user?.email != null);
    assert(user?.displayName != null);
    final currentUser = await _auth.currentUser;
    assert(user?.uid == currentUser?.uid);
    return user;
  }

  void googleSignInUser() {
    final _db = FirebaseFirestore.instance;
    final _firebaseStorageRef = FirebaseStorage.instance;
    googleSingIn().then((User? data) {
      Future<DocumentSnapshot<Map<String, dynamic>>> snapshot =
          _db.collection('Users').doc(email.text).get();
      snapshot.then((DocumentSnapshot<Map<String, dynamic>> user) {
        if (user != null && user.exists) {
          Global.doc = Users(
            user.data()!['LastName'],
            user.data()!['Emoji'],
            user.data()!['Name'],
            user.data()!['Image'],
            user.id,
            user.data()!['Role'],
            user.data()!['Active'],
          );
        } else {
          var image = imageToFile(imageName: data?.email);
          image.then((value) {
            UploadTask task = _firebaseStorageRef
                .ref()
                .child('Users')
                .child(data?.email)
                .putFile(value);
            task.whenComplete(() async {
              TaskSnapshot storageTaskSnapshot = task.snapshot;
              String imgUrl = await storageTaskSnapshot.ref.getDownloadURL();
              DocumentReference<Map<String, dynamic>> ref =
                  _db.collection('Users').doc(data?.email);
              ref.set({
                'Name': 'pdhn',
                'LastName': 'pdhn',
                'Emoji': "😃",
                'Image': '$imgUrl',
                'Role': 'User',
                'Active': 'true',
              }).then((value) {
                Global.user = Users(
                  'pdhn',
                  "😃",
                  'pdhn',
                  '$imgUrl',
                  data.email,
                  'User',
                  'true',
                );
              }).catchError((e) {
                Global.user = null;
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(e.message)));
              });
            });
          });
        }
        if(Global.user != null){
            String encodeUser = jsonEncode(Global.user);
        prefs?.setString('user', encodeUser);
        Navigator.push(context, Animation_route(UserApp()))
            .whenComplete(() => Navigator.of(context).pop());
        }

      
      });
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
      ));
    });
  }

  Widget _signInButton() {
    return MaterialButton(
      minWidth: 200.0,
      height: 60.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      onPressed: () {
        googleSignInUser();
      },
      child: Text(
        'Sign in with Google',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      color: Colors.teal,
    );
  }

  Future<File> imageToFile({String? imageName}) async {
    var bytes = await rootBundle.load('assets/logo-google.png');
    String temPath = (await getTemporaryDirectory()).path;
    File file = File('$temPath/$imageName.png');
    await file.writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    return file;
  }
}
