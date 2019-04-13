import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/pages/home_page.dart';
import 'package:teamup_app/pages/login_signup_page.dart';
import 'package:teamup_app/pages/onboarding_page.dart';
import 'package:teamup_app/pages/root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final UserModel userModel = UserModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
        model: userModel,
        child: MaterialApp(
            theme: ThemeData(
                scaffoldBackgroundColor: Colors.white,
                appBarTheme: AppBarTheme(
                  iconTheme: IconThemeData.fallback(),
                    color: Colors.white,
                    elevation: 1.0,
                    textTheme: TextTheme(
                        title: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500)))),
            title: "TeamUp",
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: {
              '/': (context) => RootPage(),
              '/home': (context) => HomePage(),
              '/login': (context) => LoginSignUpPage(),
              '/onboarding': (context) => OnboardingPage()
            }));
  }
}
