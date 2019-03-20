import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/user.dart';
import 'package:teamup_app/models/user_model.dart';

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
        onTap: () {
          ScopedModel.of<UserModel>(context, rebuildOnChange: true)
              .changeCourse(courseIds[i]);
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
        decoration: BoxDecoration(color: Colors.blue),
      )
    ];
  }

  List<Widget> _buildSettingsWidgets(BuildContext context) {
    return [
      ListTile(
        trailing: Icon(Icons.add),
        title: Text("Add Course"),
        onTap: () {
          //TODO: make page to view all courses and join selected
        },
      ),
      ListTile(
        trailing: Icon(Icons.exit_to_app),
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

//  Widget _buildAvatar(BuildContext context) {
//    return CircleAvatar();
//  }
}
