import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/models/home_model.dart';
import 'package:teamup_app/util/drawer.dart';
import 'package:teamup_app/widgets/classmates_list.dart';
import 'package:teamup_app/widgets/notifications_list.dart';
//import 'package:teamup_app/widgets/projects_list.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//  List<Widget> _pages = ScopedModel.of<HomeModel>(context, rebuildOnChange: false).hasCourse ? <Widget>[ClassmatesList(), ClassmatesList(), NotificationList()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(ScopedModel.of<HomeModel>(context, rebuildOnChange: true).courseId),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () =>
                  ScopedModel.of<UserModel>(context, rebuildOnChange: false)
                      .signOut(),
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              ScopedModel.of<HomeModel>(context, rebuildOnChange: true).changePage(index);
            },
            currentIndex: ScopedModel.of<HomeModel>(context, rebuildOnChange: true).pageIndex,
            items: [
              BottomNavigationBarItem(
                  icon: new Icon(Icons.person), title: new Text('Classmates')),
              BottomNavigationBarItem(
                  icon: new Icon(Icons.group), title: new Text('Teams')),
              BottomNavigationBarItem(
                  icon: new Icon(Icons.email), title: new Text('Notifications'))
            ]),
        body: ScopedModel.of<HomeModel>(context, rebuildOnChange: true).isHomeLoading
            ? Center(child: CircularProgressIndicator())
            : ScopedModel.of<HomeModel>(context, rebuildOnChange: false).hasCourse
                ? [ClassmatesList(), ClassmatesList(), NotificationList()][ScopedModel.of<HomeModel>(context, rebuildOnChange: false).pageIndex]
                : Center(child: Text("No Courses")),
        //TODO change this to make a drawer that doesnt reload bc user is always loaded
        drawer: ScopedModel.of<HomeModel>(context, rebuildOnChange: false).isHomeLoading ? null : null);
  }
}
