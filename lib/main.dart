import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/user_model.dart';
//import 'package:teamup_app/pages/home_page.dart';
import 'package:teamup_app/pages/root_page.dart';
//import 'package:teamup_app/widgets/profile_page.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget{
//  final routes = <String, WidgetBuilder>{
//    HomePage.route: (BuildContext context) => HomePage(),
//    RootPage.route: (BuildContext context) => RootPage(),
//    ProfilePage.route: (BuildContext context) => ProfilePage(),
//  };

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: MaterialApp(
        title: "TeamUp",
        home: RootPage(),
      ),
    );
  }
}