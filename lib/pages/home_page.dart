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


  @override
  void initState() {
    super.initState();

  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Home Page'),
      ),
      body: Center(
        child: Column(
          children: [
            new RaisedButton(
              onPressed: _signOut,
              color: Colors.blue,
              elevation: 5,
              child: new Text('Sign Out', style: new TextStyle(color: Colors.white),)
              )
            ]
          )
        )
      );
  }


}
