import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomDrawer extends StatelessWidget {
  final List<String> labels = ["abc", "def"];
  final DocumentSnapshot userData;
  final Function(DocumentReference) cb;
  CustomDrawer(this.userData, this.cb) {
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
//      ..addAll(_defaultLabels(context))
//      ..addAll([new Divider()])
      ..addAll(_buildLabelWidgets(context));
//      ..addAll([new Divider()])
//      ..addAll(_buildActions(context))
//      ..addAll([new Divider()])
//      ..addAll(_buildSettingAndHelp(context));
    return children;
  }

  List<Widget> _buildLabelWidgets(BuildContext context) {
    List<Widget> labelListTiles = [];
//    labelListTiles.add(
//        new ListTile(
//          leading: new Text('Label'),
//          trailing: new Text(
//              'EDIT'
//          ),
//          onTap: () => _onTapCreateOrEditLabel(context),
//        )
//    );

    if (userData.exists &&
        userData.data.containsKey('courses') &&
        userData.data['courses'] is List) {

        userData.data['courses'].forEach((course) {
          labelListTiles.add(
              new ListTile(
                title: new Text(course['name']),
                onTap: () {
                  cb(course['ref']);
                  Navigator.pop(context);
                },
              )
          );
        });
        }
    return labelListTiles;
  }

  List<Widget> _buildDrawHeader(BuildContext context) {
    return [
      new DrawerHeader(
        child: Text(userData.data['first_name'] + " " + userData.data['last_name']),

        decoration: BoxDecoration(color: Colors.blue),
      ),];
  }

}

//Future<List<Map<K, V>>> _getCourse<K, V>() async {
//
//  if (querySnapshot.exists &&
//      querySnapshot.data.containsKey('courses') &&
//      querySnapshot.data['courses'] is List) {
//    // Create a new List<String> from List<dynamic>
//    return List<Map<K, V>>.from(querySnapshot.data['courses']);
//  }
//  return [];
//}