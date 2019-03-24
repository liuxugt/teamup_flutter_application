import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/objects/course_member.dart';
import 'package:teamup_app/objects/team.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeamPage extends StatelessWidget {
  final Team team;
  TeamPage({this.team});

  Widget _makeClassmateCard(CourseMember member, BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(220, 220, 220, .5)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(member.photoURL),
          ),
          title: Text('${member.firstName} ${member.lastName}'),
          subtitle: Text(member.headline),
        ),
      ),
    );
  }

  _buildMemberList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: ScopedModel.of<UserModel>(context, rebuildOnChange: true)
            .getTeamMembersStream(team.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: %{snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              return ListView(
                  children: snapshot.data.documents.map((document) {
                return _makeClassmateCard(
                    CourseMember.fromSnapshotData(document.data), context);
              }).toList());
          }
        });
  }

  _buildFAB(BuildContext context) {
    return ScopedModelDescendant<UserModel>(rebuildOnChange: true, builder: (context, child, model) {
      //if this team is the user's team, show the leave team button
      if (model.userInTeam && model.currentTeam.id == team.id)
        return FloatingActionButton(
            child: Icon(Icons.remove),
            onPressed: () {
              model.leaveCurrentTeam();
            });

      //if the user is in a team or the team is full, don't show anything
      if (team.isFull || model.userInTeam)
        return Container(
          height: 0.0,
        );

      //show a join button if the team isn't full and the user is not on a team

      return FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            model.createApplications(model.currentUser.id, team.leader, team.id, model.currentCourse.id);
            //model.joinTeam(team);
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              )),
          Padding(
            padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
            child: Text(
              team.description,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Team Members",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              )),
          Flexible(
            child: _buildMemberList(context),
          )
        ],
      ),
    );
  }
}
