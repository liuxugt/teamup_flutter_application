import 'package:flutter/material.dart';


class ProfilePage extends StatelessWidget{
  static final String route = "Profile-Page";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Center(
        child: Text('Nothing to see here...yet!')
      ),
    );
  }

}