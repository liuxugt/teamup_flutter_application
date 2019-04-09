import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/objects/user.dart';
import 'package:teamup_app/objects/team.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamup_app/objects/conversation.dart';
import 'package:teamup_app/pages/conversation_page.dart';
import 'package:teamup_app/pages/profile_page.dart';

class TeamPage extends StatelessWidget {
  final Team team;
  TeamPage({this.team});

  List<Widget> _makeTeamIcons(List<dynamic> teamRoles) {
    List<Widget> iconList = [];

    for (String role in teamRoles) {
      iconList.add(Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.account_circle,
            color: Colors.grey[400],
            size: 48.0,
          ),
          Container(
            child: Center(
                child: Text(
              role.toString(),
              textAlign: TextAlign.center,
            )),
            width: 70.0,
          )
        ],
      ));
    }
    return iconList;
  }

  Widget _makeClassmateCard(User user, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      leading: CircleAvatar(
          backgroundImage: NetworkImage(user.photoURL), radius: 24.0),
      title: RichText(
        text: TextSpan(
          text: '${user.firstName} ${user.lastName}',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16.0),
          children: <TextSpan>[
            (user.id == team.leader)
                ? TextSpan(
                    text: ' (Team Lead)', style: TextStyle(color: Colors.blue))
                : TextSpan(text: ""),
          ],
        ),
      ),
      subtitle: Text(
        user.subtitle,
        style: TextStyle(color: Colors.black),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(
                      user: user,
                    )));
      },
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
                    User.fromSnapshotData(document.data), context);
              }).toList());
          }
        });
  }

  _onLeaveTeamPressed(BuildContext context) async {
    User currentUser =
        ScopedModel.of<UserModel>(context, rebuildOnChange: false).currentUser;
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirm leaving Team"),
            content: Text("Are you sure you would like to leave this team?"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              FlatButton(
                onPressed: () async {
                  await ScopedModel.of<UserModel>(context,
                          rebuildOnChange: true)
                      .leaveCurrentTeam();
                  Navigator.of(context).pop();
                },
                child: Text('Yes'),
              ),
            ],
          );
        });
  }

  _buildFAB(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
        rebuildOnChange: true,
        builder: (context, child, model) {
          //if the current user is the team leader

          //if this team is the user's team and they are not the leader, show the leave team button
          if (model.userInTeam &&
              model.currentTeam.id == team.id &&
              model.currentUser.id != team.id)
            return FloatingActionButton(
                child: Icon(Icons.remove),
                onPressed: () => _onLeaveTeamPressed(context));

          //if the user is in a team or the team is full, don't show anything
          if (team.isFull || model.userInTeam)
            return Container(
              height: 0.0,
            );

          //show a join button if the team isn't full and the user is not on a team

          return FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              if(await model.createApplication(team)){
                await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Application Confirmation"),
                        content: Text(
                            "Your application has been successfully sent, check your inbox for updates!"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Okay!"),
                            onPressed: () => Navigator.of(context).pop(),
                          )
                        ],
                      );
                    });
              }else{
                await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Error"),
                        content: Text(
                            "Oops! Looks like something went wrong! Error: ${model.error}"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Okay"),
                            onPressed: () => Navigator.of(context).pop(),
                          )
                        ],
                      );
                    });
              }

//              String conversationID = await model.createApplication(
//                  model.currentUser.id,
//                  team.leader,
//                  model.currentCourse.id,
//                  team.id);
//              DocumentSnapshot _conv = await model.currentCourse.conversationRef
//                  .document(conversationID)
//                  .get();
//              Conversation conversation = Conversation.fromSnapshot(_conv);
//              int index =
//                  (model.currentUser.id == conversation.userId1) ? 0 : 1;
//              await conversation.setUser(context);
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) =>
//                          ConversationPage(conversation, index)));
            },
            //model.joinTeam(team);
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(team.name)),
      floatingActionButton: _buildFAB(context),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Project Ideas",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                      color: Color.fromRGBO(161, 166, 187, 1.0)),
                )),
            Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                team.description,
                style: TextStyle(
                    fontSize: 18.0, color: Color.fromRGBO(90, 96, 116, 1.0)),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Vacancies",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                      color: Color.fromRGBO(161, 166, 187, 1.0)),
                )),
            Container(
              height: 96.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: ClampingScrollPhysics(),
                children: _makeTeamIcons(team.roles),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(
                  "Team Members",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                      color: Color.fromRGBO(161, 166, 187, 1.0)),
                )),
            Flexible(
              child: _buildMemberList(context),
            )
          ],
        ),
      ),
    );
  }
}
