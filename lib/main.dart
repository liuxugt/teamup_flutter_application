import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/home_model.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/pages/home_page.dart';
import 'package:teamup_app/pages/login_signup_page.dart';
import 'package:teamup_app/pages/root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
//  final routes = <String, WidgetBuilder>{
//    '/': (context) => RootPage(),
//    '/home': (context) => ScopedModel<HomeModel>(model: HomeModel(),child: HomePage()),
//    '/login': (context) => LoginSignUpPage()
//  };

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
        model: UserModel(),
        child: MaterialApp(title: "TeamUp", initialRoute: '/', routes: {
          '/': (context) => RootPage(),
          '/home': (context) => ScopedModel<HomeModel>(
              model: HomeModel(
                  ScopedModel.of<UserModel>(context, rebuildOnChange: false)
                      .currentUser),
              child: HomePage()),
          '/login': (context) => LoginSignUpPage()
        }));
//      ),
//        child: ScopedModelDescendant<UserModel>(builder: (builder, child, model){
//          return MaterialApp(
//            title: "TeamUp",
//            initialRoute: '/',
//            routes: routes,
//          );
//        })

//      child: RootPage()
//      MaterialApp(
//        title: "TeamUp",
//        home: RootPage(),
//        routes: routes,
//      ),
//    );
  }
}
