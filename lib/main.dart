import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/auth.dart';
import 'package:teamup_app/pages/root_page.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    Auth auth = Auth();
    return ScopedModel<Auth>(
      model: auth,
      child: MaterialApp(
        title: "TeamUp",
        home: RootPage()
      ),
    );
  }
}