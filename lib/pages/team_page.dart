import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/course_user.dart';
import 'package:teamup_app/models/team.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class TeamPage extends StatelessWidget {


  Widget _makeClassmateCard(CourseUser user, BuildContext context){
    return ListTile(
      title: Text('${user.firstName} ${user.lastName}'),
      subtitle: Text(user.email),
    );
  }


  _buildMemberList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: ScopedModel.of<UserModel>(context, rebuildOnChange: true).getTeamMembers(team.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: %{snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              return ListView(
                  children: snapshot.data.documents.map((document) {
                return _makeClassmateCard(
                CourseUser.fromSnapshotData(document.data),context);
              }).toList());
          }
        });
  }

  final Team team;
  TeamPage({this.team});

  _buildFAB(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      if (model.userInTeam)
        return Container(
          height: 0.0,
        );
      return FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            model.joinTeam(this.team.id);
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(team.name)),
      floatingActionButton: _buildFAB(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Description",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Padding(
            padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
            child: Text(team.description),
          ),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Team Members",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Flexible(
            child: _buildMemberList(context),
          )
        ],
      ),
    );
  }
}
