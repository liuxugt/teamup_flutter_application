import 'package:flutter/material.dart';
import 'package:teamup_app/pages/root_page.dart';
import 'package:teamup_app/services/authentication.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teamup Demo',
      debugShowCheckedModeBanner: false,
      home: new RootPage(auth: new Auth())
    );
  }
}