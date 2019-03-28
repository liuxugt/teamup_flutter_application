import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/pages/team_page.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/objects/notification.dart';
/*
class ApplicationPage extends StatelessWidget {
  Notifi notification;
  ApplicationPage({this.notification});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model){
      return Scaffold(
          appBar: AppBar(title: Text("Application detail")),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "From " + notification.fromName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  )),
              Padding(
                padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
                child: Text(
                  notification.fromName + " applies to join team " + notification.teamName,
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Related Information",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  )),

              Padding(
                  padding: EdgeInsets.all(20.0),
                  child: RaisedButton(
                      child: Text("Team Information"),
                      onPressed: () {
                        print(notification.fromName);
                        print(notification.toName);
                        print(notification.teamName);
                        print("show team information");
                      })
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: RaisedButton(
                  child: Text("Applicant information"),
                  onPressed: (){
                    print("show applicant information");
                  },
                ),),
              model.currentUser.id == notification.to ?
              Expanded(
                  child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                              color: Colors.blue,
                              child: Text("accept"),
                              onPressed: (){
                              //  acceptInvitation(notification);
                                model.acceptApplication(notification);
                              }
                            ),
                            Padding(
                                padding: EdgeInsets.only(left:20.0, right:20.0)
                            ),
                            RaisedButton(
                                color: Colors.yellow,
                                child: Text("reject"),
                                onPressed: (){
                                  model.rejectApplication(notification);
                                }
                            )
                          ]
                      )
                  )
              )
                  : Text("you can not operate on it")
            ],
          )
      );
    });
  }
  /*
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
  */
}


class InvitationPage extends StatelessWidget{
  final Notifi notification;
  InvitationPage({this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Application detail")),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "From " + notification.fromName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                )),
            Padding(
              padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
              child: Text(
                notification.fromName + " invites you to join team " + notification.teamName,
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Related Information",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                )),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: RaisedButton(
                  child: Text("Team Information"),
                  onPressed: () {
                    print("show team information");
                  }
                )
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
                child: RaisedButton(
                  child: Text("Applicant information"),
                  onPressed: (){
                    print("show applicant information");
                  },
            )
            ),
            Expanded(
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.red,
                          child: Text("accept"),
                          //onPressed: (){
                          //  acceptInvitation(notification);
                          //}
                        ),
                        Padding(
                          padding: EdgeInsets.only(left:20.0, right:20.0)
                        ),
                        RaisedButton(
                          color: Colors.blue,
                          child: Text("reject"),
                          //onPressed: (){
                          //  RejectInvitation(notification);
                          //}
                        )
                      ]
                  )
              )
            )
          ],
        )
    );
  }
}
*/