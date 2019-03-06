import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/widgets/classmates_list.dart';
import 'package:teamup_app/widgets/drawer.dart';
import 'package:teamup_app/widgets/notifications_list.dart';
import 'package:teamup_app/widgets/teams_list.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(ScopedModel.of<UserModel>(context, rebuildOnChange: true)
              .currentCourseId),
//          title: Text('Home Page'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                  ScopedModel.of<UserModel>(context, rebuildOnChange: false)
                      .signOut().then((void n){
                        Navigator.of(context).pushReplacementNamed('/');
                  });
              }
            )
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: <Widget>[
            Tab(icon: Icon(Icons.person)),
            Tab(icon: Icon(Icons.group)),
            Tab(icon: Icon(Icons.mail))
          ],
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
        ),
        body: TabBarView(children: [
          ClassmatesList(),
          TeamsList(),
          NotificationList(),
        ]),
        drawer: CustomDrawer(),
      ),
    );


  }
}
