import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/user_model.dart';


class RootPage extends StatelessWidget {
//  static final String route = "Root-Page";

  @override
  Widget build(BuildContext context) {
    ScopedModel.of<UserModel>(context, rebuildOnChange: false)
        .loadCurrentUser()
        .then((isSignedIn) {
      if (isSignedIn) Navigator.of(context).pushReplacementNamed('/home');
      Navigator.of(context).pushReplacementNamed('/login');
    });
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );

//
//    return ScopedModelDescendant<UserModel>(
//      builder: (context, child, model) {
//
//
//
//        if (model.isAppLoading) return _buildWaitingScreen();
//        if (!model.isSignedIn)
//          Navigator.pushReplacementNamed(context, '/home');
//
//        Navigator.pushReplacementNamed(context, '/login');
//
//
//        return Center(
//          child: CircularProgressIndicator(),
//        );
////        return ScopedModel<HomeModel>(
////          model: HomeModel(model.currentUser),
////          child: HomePage(),
////        );
//      },
//    );
  }
}
