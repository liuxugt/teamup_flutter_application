import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/pages/home_page.dart';
import 'package:teamup_app/pages/login_signup_page.dart';
import 'package:teamup_app/pages/root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final UserModel userModel = UserModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
        model: userModel,
        child: MaterialApp(title: "TeamUp", debugShowCheckedModeBanner: false ,initialRoute: '/', routes: {
          '/': (context) => RootPage(),
          '/home': (context) => HomePage(),
          '/login': (context) => LoginSignUpPage()
        }));

  }
}
