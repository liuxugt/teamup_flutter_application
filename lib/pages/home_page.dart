import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/auth.dart';
import 'package:teamup_app/models/home.dart';
import 'package:teamup_app/util/drawer.dart';
import 'package:teamup_app/widgets/classmates_list.dart';
import 'package:teamup_app/widgets/notifications_list.dart';
import 'package:teamup_app/widgets/projects_list.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
//    return ScopedModelDescendant<Home>(builder: (_, __, home) {
      return Scaffold(
        appBar: AppBar(
          title: Text(ScopedModel.of<Home>(context, rebuildOnChange: true).courseId),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () =>
                  ScopedModel.of<Auth>(context, rebuildOnChange: false)
                      .signOut(),
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              ScopedModel.of<Home>(context, rebuildOnChange: true).changePage(index);
            },
            currentIndex: ScopedModel.of<Home>(context, rebuildOnChange: true).pageIndex,
            items: [
              BottomNavigationBarItem(
                  icon: new Icon(Icons.person), title: new Text('Classmates')),
              BottomNavigationBarItem(
                  icon: new Icon(Icons.group), title: new Text('Teams')),
              BottomNavigationBarItem(
                  icon: new Icon(Icons.email), title: new Text('Notifications'))
            ]),
        body: ScopedModel.of<Home>(context, rebuildOnChange: true).isHomeLoading
            ? Center(child: CircularProgressIndicator())
            : ScopedModel.of<Home>(context, rebuildOnChange: true).hasCourse
              ? [ClassmatesList(), ClassmatesList(), NotificationList()][ScopedModel.of<Home>(context, rebuildOnChange: true).pageIndex]
              : Center(child: Text("No Courses")),
        drawer: ScopedModel.of<Home>(context, rebuildOnChange: true).isHomeLoading
            ? null
            : null
      );
    }
//    );

  }

