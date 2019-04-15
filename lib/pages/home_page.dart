import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/widgets/classmates_list.dart';
import 'package:teamup_app/widgets/drawer.dart';
import 'package:teamup_app/widgets/teams_list.dart';
import 'package:teamup_app/widgets/conversation_list.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
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
            Tab(icon: Icon(Icons.person), child: Text("Classmates"),),
            Tab(icon: Icon(Icons.group), child: Text("Teams"),),
            Tab(icon: Icon(Icons.mail), child: Text("Inbox"),),
          ],
          labelColor: Color.fromRGBO(90, 133, 236, 1.0),
          indicatorColor: Color.fromRGBO(90, 133, 236, 1.0),
          unselectedLabelColor: Colors.grey,
        ),
        body: TabBarView(
            children: [
          ClassmatesList(),
          TeamsList(),
          ConversationList(),
        ]),
        drawer: CustomDrawer(),
      ),
    );


  }
}
