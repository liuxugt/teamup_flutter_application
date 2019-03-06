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
      ..addAll(_buildLabelWidgets(context));
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
      new UserAccountsDrawerHeader(
        accountName: Text('${user.firstName} ${user.lastName}'),
        accountEmail: Text(user.email),
        currentAccountPicture: CircleAvatar(
            backgroundImage: NetworkImage(
                "http://www.personalbrandingblog.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png")),
        decoration: BoxDecoration(color: Colors.blue),
      )
    ];
  }

//  Widget _buildAvatar(BuildContext context) {
//    return CircleAvatar();
//  }
}
