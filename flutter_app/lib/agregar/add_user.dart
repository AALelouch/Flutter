import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/agregar/validate_text.dart';
import 'package:flutter_app/details/details_user.dart';
import '../global.dart';
import '../list/user.dart';
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
                if (Global.doc != null) {
                  Navigator.push(context, Animation_route(UserApp()))
                      .whenComplete(() => Navigator.of(context).pop());
                } else {
                  Navigator.push(context, Animation_route(UserApp()))
                      .whenComplete(() => Navigator.of(context).pop());
                }
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
  final List _roles = ["Admin", "User"];
  late List<DropdownMenuItem<String>> _dropdownMenuItems;
  late List<DropdownMenuItem<String>> _dropDownRolesItems;
  late String _currentEmoji, _image, _currentRole;
  late bool _isEnable = true;
  validateText? validate; //revisar si esta bien por algo se puso el ?
  @override
  void initState() {
    _dropdownMenuItems = getDropDownMenuItems();
    _currentEmoji = _dropdownMenuItems[0].value!;
    _dropDownRolesItems = getDropDownRoleItems();
    _currentRole = _dropDownRolesItems[0].value!;
    _isEnable = true;
    if (Global.doc != null) {
      name.text = Global.doc!.Name;
      lastname.text = Global.doc!.LastName;
      email.text = Global.doc!.Email;
      _currentEmoji = Global.doc!.Emoji;
      _currentRole = Global.doc!.Role;
      _image = Global.doc!.Image;
      password.text = "*******";
      _isEnable = false;
    }
    validate = validateText();
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
                validator: validate?.validateEmail, // se agrego el ?
                controller: email,
                enabled: _isEnable),
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
                validator: validate?.validatePassword, // se agrego el ?
                controller: password,
                enabled: _isEnable),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: DropdownButton(
              value: _currentEmoji,
              items: _dropdownMenuItems,
              onChanged: changedDropDownItem,
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: DropdownButton(
                value: _currentRole,
                items: _dropDownRolesItems,
                onChanged: changedDropDownRoles,
              )),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
            child: MaterialButton(
              minWidth: 200.0,
              height: 60.0,
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  if (Global.doc == null) {
                    registrar(context);
                  } else {
                    actualizar();
                  }
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
      return const Text(
        "Registrar",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      );
    } else if (_state == 1) {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return const Text(
        "Registrar",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      );
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
            'Emoji': _currentEmoji,
            'Image': imUrl,
            'Role': _currentRole,
            'Active': true,
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

  List<DropdownMenuItem<String>> getDropDownRoleItems() {
    List<DropdownMenuItem<String>> items = [];
    for (String item in _roles) {
      items.add(DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
      ));
    }
    return items;
  }

  void changedDropDownRoles(String? selectedRole) {
    setState(() {
      _currentRole = selectedRole!;
    });
  }

  actualizar() async {
    final _firabaseStorageRef = FirebaseStorage.instance;
    final _db = FirebaseFirestore.instance;
    var image = CardFoto.croppedFile;
    var dataImage;
    var value = false;
    DocumentReference ref = _db.collection('Users').doc(email.text);
    setState(() {
      if (_state == 0) {}
    });
    if (image != null) {
      UploadTask task = _firabaseStorageRef
          .ref()
          .child("Users")
          .child("${email.text}")
          .putFile(image);
      task.whenComplete(() async {
        TaskSnapshot storageTaskSnapshot = task.snapshot;
        dataImage = await storageTaskSnapshot.ref.getDownloadURL();
        value = true;
      });
    } else {
      if (_image != null) {
        dataImage = _image;
        value = true;
      } else {
        value = false;
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Seleccione una imagen')));
      }
    }
    if (value) {
      ref.set({
        'Name': name.text,
        'LastName': lastname.text,
        'Emoji': _currentEmoji,
        'Image': dataImage,
        'Role': _currentRole,
        'Active': Global.doc!.Active,
      }).then((value) {
        Future<DocumentSnapshot<Map<String, dynamic>>> snapshot =
            _db.collection('Users').doc(email.text).get();
        snapshot.then((DocumentSnapshot<Map<String, dynamic>> user) {
          Global.doc = Users(
            user.data()!['LastName'],
            user.data()!['Emoji'],
            user.data()!['Name'],
            user.data()!['Image'],
            user.id,
            user.data()!['Role'],
            user.data()!['Active'],
          );
          Navigator.push(context, Animation_route(DetailUser()))
              .whenComplete(() => Navigator.of(context).pop());
        });
      });
    }
  }
}
