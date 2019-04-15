import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/objects/team.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/pages/propose_team_page.dart';
import 'package:teamup_app/pages/team_page.dart';

class TeamsList extends StatelessWidget {
  final Map<String, Image> _teamMateIconMap = {
    'anyone': Image.asset("assets/anyone.png", height: 32, width: 32),
    'designer': Image.asset("assets/designer.png", height: 32, width: 32),
    'researcher': Image.asset("assets/researcher.png", height: 32, width: 32),
    'developer': Image.asset("assets/developer.png", height: 32, width: 32),
  };
  final List<String> _customRoleList = [
    'anyone',
    'designer',
    'researcher',
    'developer'
  ];

  List<Widget> _makeTeamIcons(List<dynamic> teamRoles) {
    List<Widget> iconList = [
      Container(
        height: 48,
        child: Center(child: Text("we want", style: TextStyle(color: Color.fromRGBO(90, 133, 236, 1.0), fontWeight: FontWeight.w600),)),
      )
    ];

    Map<String, int> roleCountMap = {};
    for (String role in teamRoles) {
      if (roleCountMap.containsKey(role)) {
        roleCountMap[role]++;
      } else {
        roleCountMap[role] = 1;
      }
    }
    List<String> finalRoles = [];
    roleCountMap.forEach((role, count) {
      if (count > 1) {
        finalRoles.add("$role x${count.toString()}");
      } else {
        finalRoles.add(role);
      }
    });

    Widget icon = _teamMateIconMap[_customRoleList[0]];

    for (String role in finalRoles) {
      //default icon
      for (String s in _customRoleList) {
        if (role.toLowerCase().contains(s)) {
          icon = _teamMateIconMap[s];
          break;
        }
      }

      iconList.add(Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          icon,
          Container(
            padding: EdgeInsets.only(top: 8),
            child: Center(
                child: Text(
              role.toString(),
              textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11),
            )),
            width: 70.0,
          )
        ],
      ));
    }
    return iconList;
  }

  Widget _makeTeamCard(Team team, BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color.fromRGBO(90, 133, 236, 1), Color.fromRGBO(149, 138, 224, 1)]),
//                color: Color.fromRGBO(245, 245, 245, 1)
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                isThreeLine: true,
                title: Text(team.name,
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: Text(team.description, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TeamPage(team: team)));
                }),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _makeTeamIcons(team.roles),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      if (!model.hasCourse) return Center(child: Text('No Courses'));
      return StreamBuilder<QuerySnapshot>(
          stream: model.getTeams(),
          builder: (context, snapshot) {
            List<Widget> children = [
              //Label for my team
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "My Team",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
              ),
              // if I am in a team show my team card, if not don't show
              Center(
                child: model.userInTeam
                    ? _makeTeamCard(model.currentTeam, context)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'Oops! You are not in a team yet!',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            height: 16.0,
                          ),
                          FlatButton(
                            child: const Text(
                              'Propose a new Team',
                            ),
                            color: Color.fromRGBO(90, 133, 236, 1.0),
                            textColor: Colors.white,
                            onPressed: () {
                              int courseGroupSize = ScopedModel.of<UserModel>(
                                      context,
                                      rebuildOnChange: false)
                                  .currentCourse
                                  .groupSize;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProposeTeamPage(
                                            maxGroupSize: courseGroupSize,
                                          )));
                            },
                          )
                        ],
                      ),
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("Available Teams",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
              )
            ];

            if (snapshot.hasError) {
              children.add(Text('Error: %{snapshot.error}'));
              return ListView(children: children);
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                children.add(Center(child: CircularProgressIndicator()));
                return ListView(
                  children: children,
                );
              default:
                List<Widget> queryList =
                    snapshot.data.documents.map((document) {
                  if (document?.data != null) {
                    Team team = Team.fromSnapshot(document);
                    if (model.currentTeam == null ||
                        team.id != model.currentTeam.id) {
                      return _makeTeamCard(team, context);
                    }
                  }
                  return Container(
                    height: 0.0,
                  );
                }).toList();
                children.addAll(queryList);
                return ListView(children: children);
            }
          });
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
    });
  }
}
