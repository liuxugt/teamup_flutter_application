import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/objects/team.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/pages/team_page.dart';

class TeamsList extends StatelessWidget {
  Widget _makeTeamCard(Team team, BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(220, 220, 220, .5)),
        child: ListTile(
            title:
                Text(team.name, style: TextStyle(fontWeight: FontWeight.bold)),
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

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      if (!model.hasCourse) return Center(child: Text('No Courses'));
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start, //align to the left
          children: <Widget>[
            //Label for my team
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("My Team", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
            ),
            // if I am in a team show my team card, if not don't show
            model.userInTeam
                ? Center(child: _makeTeamCard(model.currentTeam, context))
                : Center(
                    child: Text('Oops! You\'re not in a team yet.',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold))),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Available Teams", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
            ),
            Flexible(
                child: StreamBuilder<QuerySnapshot>(
                    stream: model.currentCourse.availableTeamsStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError)
                        return Text('Error: %{snapshot.error}');
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());
                        default:
                          return ListView(
                              children: snapshot.data.documents.map((document) {
                            return (document?.data != null)
                                ? _makeTeamCard(
                                    Team.fromSnapshot(document), context)
                                : Container(
                                    height: 0.0,
                                  );
                          }).toList());
                      }
                    })),
//            Padding(
//              padding: EdgeInsets.all(20.0),
//              child: Text("Full Teams"),
//            ),
//            Flexible(
//                child: StreamBuilder<QuerySnapshot>(
//                    stream: model.currentCourse.unavailableTeamsStream,
//                    builder: (ctx, snapshot) {
//                      if (snapshot.hasError)
//                        return Text('Error: %{snapshot.error}');
//                      switch (snapshot.connectionState) {
//                        case ConnectionState.waiting:
//                          return Center(child: CircularProgressIndicator());
//                        default:
//                          return ListView(
//                              children: snapshot.data.documents.map((document) {
//                                return _makeTeamCard(Team.fromSnapshotData(document.data), context);
//                              }).toList());
//                      }
//                    }))
          ]);
    });
  }
}
