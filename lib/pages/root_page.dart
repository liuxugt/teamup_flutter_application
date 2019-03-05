import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/models/course_model.dart';
import 'package:teamup_app/pages/course_page.dart';
import 'package:teamup_app/pages/login_signup_page.dart';


class RootPage extends StatelessWidget {

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        if(model.isAppLoading)
          return _buildWaitingScreen();
        if(model.isSignedIn){
          return ScopedModel<CourseModel>(
            model: CourseModel(ScopedModel.of<UserModel>(context, rebuildOnChange: true).currentUser),
            child: CoursePage(),
          );
        }else{
          return LoginSignUpPage();
        }
      },
    );
  }
}

