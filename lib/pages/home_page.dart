import 'package:flutter/material.dart';
import 'package:teamup_app/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget{
  HomePage({Key key, this.auth, this.userId, this.onSignedOut}) : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();

}

class _HomePageState extends State<HomePage>{

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final db = Firestore.instance;
  int _currentIndex = 0;
  DocumentSnapshot userData;
  final List<Widget> _children = [

  ];


  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    DocumentSnapshot data = await db.collection('users').document(widget.userId).get();
    setState(() {
      userData = data;
    });
  }


  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  void onTabTapped(int index){
    setState((){
      _currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Teamup'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _signOut,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadUserData,
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.person),
              title: new Text('Classmates')
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.group),
              title: new Text('Teams')
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.email),
              title: new Text('Inbox')
            )
          ]
      ),
      body: Center(
        child: Center(
          child: userData != null ? Text(userData.data.toString()) : Text('Nothing here...')
          )
        )
      );
  }


}
