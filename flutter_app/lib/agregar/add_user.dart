import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'package:flutter_app/menu/animation_route.dart';
import 'package:flutter_app/menu/menu_lateral.dart';

import 'card_Foto.dart';

void main() => runApp(AddUser());

class AddUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.pink,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.pink,
      ),
      home: const HomePage(
        title: 'Registrar',
      ),
      routes: const <String, WidgetBuilder>{},
    );
  }
}

class HomePage extends StatelessWidget {
  final String title;
  const HomePage({Key? key, required this.title})
      : super(key: key); // error del Key? y error deñ this title
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          InkWell(
              child: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xffffffff),
              ),
              onTap: () {
                Navigator.push(context, Animation_route(UserApp()))
                    .whenComplete(() => Navigator.of(context).pop());
              }),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: const UserForm(),
      drawer: MenuLateral(),
    );
  }
}

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  UserFormState createState() {
    return UserFormState();
  }
}

class UserFormState extends State<UserForm> {
  final _formkey = GlobalKey<FormState>();
  var email = TextEditingController();
  var password = TextEditingController();
  var name = TextEditingController();
  var lastname = TextEditingController();
  final List _emoji = ["😃", "😆", "🙃", "😅", "😇"];
  late List<DropdownMenuItem<String>> _dropDownMenuItems;
  late String _currentEmoji, _image;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentEmoji = _dropDownMenuItems[0].value!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key: _formkey,
      child: ListView(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
            child: CardFotos(),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              style: const TextStyle(fontSize: 20.0),
              decoration: InputDecoration(
                  labelText: "Enter Nombre",
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide())),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Porfavor ingrese el nombre";
                }
              },
              controller: name,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              style: const TextStyle(fontSize: 20.0),
              decoration: InputDecoration(
                  labelText: "Enter apellido",
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide())),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Porfavor ingrese el apellido";
                }
              },
              controller: lastname,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(fontSize: 20.0),
              decoration: InputDecoration(
                  labelText: "Enter email",
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide())),
              validator: validateEmail,
              controller: email,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: TextFormField(
              obscureText: true,
              style: const TextStyle(fontSize: 20.0),
              decoration: InputDecoration(
                  labelText: "Enter password",
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.enhanced_encryption),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide())),
              validator: validatePassword,
              controller: password,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: DropdownButton(
              value: _currentEmoji,
              items: _dropDownMenuItems,
              onChanged: changedDropDownItem,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
            child: MaterialButton(
              minWidth: 200.0,
              height: 60.0,
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  registrar(context);
                }
              },
              color: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              child: setUpButtonChild(),
            ),
          ),
        ],
      ),
    );
  }

  int _state = 0;
  Widget setUpButtonChild() {
    if (_state == 0) {
      return Text(
        "Registrar",
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
        "Registrar",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      );
    }
  }

  String? validateEmail(String? value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    if (value!.isEmpty) {
      return 'por favor ingrese el email';
    } else {
      RegExp regex = RegExp(pattern.toString());
      if (!regex.hasMatch(value)) {
        return 'Enter Valid Email';
      }
    }
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'por favor ingrese el password';
    } else {
      if (6 > value.length) {
        return 'por favor ingrese una constraseña de 6 caracteres';
      }
    }
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = [];
    for (String item in _emoji) {
      items.add(DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            fontSize: 35,
          ),
        ),
      ));
    }
    return items;
  }

  void changedDropDownItem(String? selectedEmoji) {
    setState(() {
      _currentEmoji = selectedEmoji!;
    });
  }

  registrar(BuildContext context) async {
    final _auth = FirebaseAuth.instance;
    final _firebaseStorageRef = FirebaseStorage.instance;
    final _db = FirebaseFirestore.instance;
    var image = CardFoto.croppedFile;
    if (image != null) {
      setState(() {
        animateButton();
      });
      await _auth
          .createUserWithEmailAndPassword(
              email: email.text, password: password.text)
          .then((value) {
        UploadTask task = _firebaseStorageRef
            .ref()
            .child("Users")
            .child(email.text)
            .putFile(image);
        task.whenComplete(() async {
          TaskSnapshot storageTaskSnapshot = task.snapshot;
          String imUrl = await storageTaskSnapshot.ref.getDownloadURL();
          DocumentReference ref = _db.collection('Users').doc(email.text);
          ref.set({
            'Name': name.text,
            'LastName': lastname.text,
            'Emoji': '$_currentEmoji',
            'Image': '$imUrl'
          }).then((value) {
            Navigator.push(context, Animation_route(HomePageMain()))
                .whenComplete(() => Navigator.of(context).pop());
          });
        });
        // ignore: invalid_return_type_for_catch_error
      }).catchError((e) => {
                Scaffold.of(context).showBottomSheet(
                    (context) => SnackBar(content: Text(e.toString())))
              });
    }
  }

  void animateButton() {
    setState(() {
      _state = 1;
    });
    Timer(const Duration(seconds: 60), () {
      setState(() {
        _state = 2;
      });
    });
  }
}
