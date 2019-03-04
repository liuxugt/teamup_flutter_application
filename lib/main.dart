import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/pages/root_page.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    UserModel model = UserModel();
    return ScopedModel<UserModel>(
      model: model,
      child: MaterialApp(
        title: "TeamUp",
        home: RootPage()
      ),
    );
  }
}