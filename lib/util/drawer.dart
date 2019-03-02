import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomDrawer extends StatelessWidget {
//  final List<String> labels = ["abc", "def"];
  final DocumentSnapshot userData;
  final Function(DocumentReference, int) cb;
  final int currentIndex;
  CustomDrawer(this.userData, this.cb, this.currentIndex) {
//    print(courseData.toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: new ListView(
            padding: EdgeInsets.zero,
            children: _buildDrawerList(context)
        )
    );
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

    if (userData.exists &&
        userData.data.containsKey('courses') &&
        userData.data['courses'] is List) {

        List courses = userData.data['courses'];
        for(int i = 0; i < courses.length; i++){
          labelListTiles.add(
              new ListTile(
                title: new Text(courses[i]['name']),
                onTap: () {
                  cb(courses[i]['ref'], i);
                  Navigator.pop(context);
                },
              )
          );
        }

//        userData.data['courses'].forEach((course) {
//          labelListTiles.add(
//              new ListTile(
//                title: new Text(course['name']),
//                onTap: () {
//                  cb(course['ref']);
//                  Navigator.pop(context);
//                },
//              )
//          );
//        });
        }
    return labelListTiles;
  }

  List<Widget> _buildDrawHeader(BuildContext context) {
    return [
      new UserAccountsDrawerHeader(
        accountName: Text(userData.data['first_name'] + " " + userData.data['last_name']),
        accountEmail: Text(userData.data['email']),
        currentAccountPicture: CircleAvatar(backgroundImage: NetworkImage("http://www.personalbrandingblog.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png")),
        decoration: BoxDecoration(color: Colors.blue),
      )
    ];
  }

  Widget _buildAvatar(BuildContext context) {
    return CircleAvatar();
  }

}


