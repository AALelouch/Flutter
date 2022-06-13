import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/list/user.dart';
import 'package:flutter_app/menu/menu_lateral.dart';

class ListUser extends StatefulWidget {
  @override
  ListUserState createState() => ListUserState();
}

class ListUserState extends State<ListUser> {
  final _refreshkey = GlobalKey<RefreshIndicatorState>();
  final _db = FirebaseFirestore.instance;
  List<Users>? listUser;
  late Widget _users;
  late bool _isSearching;
  final _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    listUser = <Users>[];
    _users = const SizedBox();
    _isSearching = false;
    readData();
  }

  Widget appBarTitle = const Text(
    "Search User",
    style: TextStyle(color: Color.fromARGB(255, 33, 243, 61)),
  );

  Icon icon = const Icon(
    Icons.search,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        actions: [
          IconButton(
            icon: icon,
            onPressed: () {
              setState(() {
                if (icon.icon == Icons.search) {
                  icon = const Icon(
                    Icons.close,
                    color: Colors.white,
                  );
                  appBarTitle = TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      hintText: "Search..",
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    onChanged: searchOperation,
                  );
                  _handleSearchStart();
                } else {
                  searchOperation(null);
                  _handleSearchEnd();
                }
              });
            },
          )
        ],
      ),
      drawer: MenuLateral(),
      body: RefreshIndicator(
        key: _refreshkey,
        onRefresh: readData,
        child: ListView(
          children: [
            _users,
          ],
        ),
      ),
    );
  }

  Future<void> readData() async {
    Stream<QuerySnapshot<Map<String, dynamic>>> qs =
        _db.collection('Users').snapshots();
    qs.listen((QuerySnapshot<Map<String, dynamic>> onData) => {
          listUser?.clear(),
          onData.docs
              .map((doc) => {
                    listUser?.add(Users(
                      doc.data()['LastName'],
                      doc.data()['Emoji'],
                      doc.data()['Name'],
                      doc.data()['Image'],
                      doc.id,
                      doc.data()['Role'],
                      doc.data()['Active'],
                    )),
                  })
              .toList(),
          userList(null),
        });
  }

  Container buildItem(Users doc) {
    return Container(
      height: 120.0,
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 5.0,
      ),
      child: Stack(
        children: [card(doc), thumbnail(doc)],
      ),
    );
  }

  GestureDetector card(Users doc) {
    return GestureDetector(
      child: Container(
        height: 130.0,
        margin: EdgeInsets.only(left: 46.0),
        decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Colors.black38,
                blurRadius: 5.0,
                offset: Offset(0.0, 5.0),
              )
            ]),
        child: Row(children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 60.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '$doc.Name',
                      style: const TextStyle(fontSize: 19, color: Colors.white),
                    ),
                    Text(
                      '$doc.Emoji',
                      style: const TextStyle(fontSize: 19, color: Colors.white),
                    )
                  ],
                ),
                Text(
                  '$doc.LastName',
                  style: const TextStyle(fontSize: 19, color: Colors.white),
                )
              ],
            ),
          ),
          Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Row(children: [
                  Text(
                    '$doc.Role',
                    style: const TextStyle(fontSize: 19, color: Colors.white),
                  ),
                ])
              ]))
        ]),
      ),
    );
  }

  Container thumbnail(Users doc) {
    return Container(
      alignment: FractionalOffset.centerLeft,
      child: Container(
        height: 90.0,
        width: 90.0,
        decoration: BoxDecoration(
            color: Colors.pink,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(50.0),
            image: DecorationImage(
              image: NetworkImage(doc.Image),
              fit: BoxFit.cover,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0xffA4A4A4),
                blurRadius: 3.0,
              )
            ]),
      ),
    );
  }

  void userList(String? searchText) {
    setState(() {
      if (listUser != null) {
        if (searchText != null || searchText != '') {
          _users = Column(
            children: listUser!.map((user) => buildItem(user)).toList(),
          );
        } else {
          var usuario = listUser!
              .where((element) => element.Name.startsWith(searchText!))
              .toList();
          if (usuario.isNotEmpty) {
            _users = Column(
              children: usuario.map((user) => buildItem(user)).toList(),
            );
          } else {
            _users = const SizedBox();
          }
        }
      } else {
        _users = const SizedBox();
      }
    });
  }

  void searchOperation(String? searchText) {
    if (_isSearching) {
      userList(searchText);
    }
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      _isSearching = false;
      _controller.clear();
      icon = const Icon(
        Icons.search,
        color: Colors.white,
      );
      appBarTitle = const Text(
        "Search User",
        style: TextStyle(color: Colors.white),
      );
    });
  }
}
