import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/widgets/classmates_list.dart';
import 'package:teamup_app/widgets/drawer.dart';
import 'package:teamup_app/widgets/send_list.dart';
import 'package:teamup_app/widgets/teams_list.dart';
import 'package:teamup_app/widgets/receive_list.dart'

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(ScopedModel.of<UserModel>(context, rebuildOnChange: true)
              .courseTitle),
//          title: Text('Home Page'),
          actions: <Widget>[
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
        body: TabBarView(
            children: [
          ClassmatesList(),
          TeamsList(),
          SentList(),
          ReceivedList()
        ]),
        drawer: CustomDrawer(),
      ),
    );


  }
}
