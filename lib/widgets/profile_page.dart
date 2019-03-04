import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/home.dart';


class ProfilePage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Profile Page'),
      ),
      body: Center(
        child: Text(ScopedModel.of<Home>(context, rebuildOnChange: false).user.firstName)
      ),
    );
  }

}