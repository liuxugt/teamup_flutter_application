import 'package:flutter/material.dart';
import 'package:teamup_app/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OnBoardingPage extends StatefulWidget{
  OnBoardingPage({Key key, this.auth, this.userId}) : super(key: key);

  final BaseAuth auth;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _OnBoardingPage();

}

class _OnBoardingPage extends State<OnBoardingPage>{

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final db = Firestore.instance;


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Onboarding'),
        ),
        body: Center(
          child: Text('This is Onboarding')
        )
    );
  }


}
