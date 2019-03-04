import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/auth.dart';
import 'package:teamup_app/models/home.dart';
import 'package:teamup_app/pages/home_page.dart';
import 'package:teamup_app/pages/login_signup_page.dart';

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RootPageState();
}


class _RootPageState extends State<RootPage> {


  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Auth>(
      builder: (context, child, model) {
        if(model.isAppLoading){
          return _buildWaitingScreen();
        }
        if(model.isSignedIn){
          Home home = new Home();
          home.loadData();
          return ScopedModel<Home>(
            model: home,
            child: HomePage(),
          );
        }else{
          return LoginSignUpPage();
        }
      },
    );
  }
}

