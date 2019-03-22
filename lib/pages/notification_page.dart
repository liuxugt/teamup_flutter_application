import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/pages/team_page.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/objects/notification.dart';
import 'package:teamup_app/objects/team.dart';
import 'package:teamup_app/objects/course_member.dart';

class ApplicationPage extends StatelessWidget {
  Notifi notification;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Application detail")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "From" + notification.fromName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              )),
          Padding(
            padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
            child: Text(
              notification.fromName + "applies to join team" + notification.teamName,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Related Information",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              )),
          Flexible(
            child: Column(
              children: <Widget>[
              ],
              )
          )
        ],
      ),
    );
  }

  Future<Widget> _buildTeamCard(String teamID, context) async {
    DocumentSnapshot team = await ScopedModel.of<UserModel>(context, rebuildOnChange: true).currentCourse.teamsRef.document(teamID).get();
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(220, 220, 220, .5)),
        child: ListTile(
            isThreeLine: true,
            title: Text(team.name, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(team.description),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TeamPage(team: team)));
            }),
        ),
      );
}

/*
class InvitationPage extends StatelessWidget{
  final Notifi notification;
  InvitationPage({this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Invitation Detail")),
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
}*/