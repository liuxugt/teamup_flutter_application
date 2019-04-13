import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/objects/user.dart';
import 'package:teamup_app/models/user_model.dart';
//import 'package:teamup_app/pages/onboarding_page.dart';
import 'package:teamup_app/pages/profile_page.dart';
import 'package:teamup_app/pages/select_course_page.dart';
import 'package:teamup_app/pages/profile_edit_page.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(child: new ListView(children: _buildDrawerList(context)));
  }

  List<Widget> _buildDrawerList(BuildContext context) {
    List<Widget> children = [];
    children
      ..addAll(_buildDrawHeader(context))
      ..addAll(_buildLabelWidgets(context))
      ..addAll(_buildSettingsWidgets(context));
    return children;
  }

  List<Widget> _buildLabelWidgets(BuildContext context) {
    List<Widget> labelListTiles = [];
    User user =
        ScopedModel.of<UserModel>(context, rebuildOnChange: true).currentUser;
    List<String> courseIds = user.courseIds;
    for (int i = 0; i < courseIds.length; i++) {
      labelListTiles.add(ListTile(
        title: Text(courseIds[i]),
        leading: Icon(Icons.book),
        onTap: () {
          ScopedModel.of<UserModel>(context, rebuildOnChange: true)
              .changeCourse(courseId: courseIds[i]);
          Navigator.pop(context);
        },
      ));
    }
    return labelListTiles;
  }

  List<Widget> _buildDrawHeader(BuildContext context) {
    User user =
        ScopedModel.of<UserModel>(context, rebuildOnChange: true).currentUser;
    return [
      UserAccountsDrawerHeader(
        accountName: Text('${user.firstName} ${user.lastName}'),
        accountEmail: Text(user.email),
        currentAccountPicture: CircleAvatar(
            backgroundImage: NetworkImage(user.photoURL)),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color.fromRGBO(90, 133, 236, 1), Color.fromRGBO(149, 138, 224, 1)])
        ),
        onDetailsPressed: (){
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfilePage(user: user,)));
        },
      )
    ];
  }

  List<Widget> _buildSettingsWidgets(BuildContext context) {
    return [
//      ListTile(
//        title: Text("Onboarding"),
//        leading: Icon(Icons.person),
//        onTap: (){
//          Navigator.of(context).push(MaterialPageRoute(
//              builder: (context) => OnboardingPage()));
//        },
//      ),
      ListTile(
        leading: Icon(Icons.add),
        title: Text("Add Course"),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SelectCoursePage()));
        },
      ),
      Padding(
        padding: EdgeInsets.only(left: 20),
        child: Text("Setting")
      ),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text("Edit profile"),
        onTap:(){
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => ProfileEditPage(
                    user: ScopedModel.of<UserModel>(context, rebuildOnChange: false).currentUser
                  )));
        },
      ),
      ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text("Sign Out"),
        onTap: () {
          ScopedModel.of<UserModel>(context, rebuildOnChange: false)
              .signOut()
              .then((void n) {
            Navigator.of(context).pushReplacementNamed('/');
          });
        },
      )
    ];
  }

}
