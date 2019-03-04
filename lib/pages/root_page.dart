import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/userModel.dart';
import 'package:teamup_app/models/homeModel.dart';
import 'package:teamup_app/pages/home_page.dart';
import 'package:teamup_app/pages/login_signup_page.dart';


class RootPage extends StatelessWidget {

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  final Home home = Home();
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Auth>(
      builder: (context, child, model) {
        if(model.isAppLoading){
          return _buildWaitingScreen();
        }
        if(model.isSignedIn){
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

