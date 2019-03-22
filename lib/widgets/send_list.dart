import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/objects/notification.dart';
import 'package:teamup_app/pages/notification_page.dart';


class SendList extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 2,
      child: new Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: new Container(
            color: Colors.blue,
            child: new TabBar(
              tabs: <Widget>[
                Text("Applications", style: TextStyle(
                    color: Colors.black, fontSize: 20)),
                Text("Invitations", style: TextStyle(
                    color: Colors.black, fontSize: 20)),
              ],
            ),
          )
        ),
        body: new TabBarView(
          children: [
            SendApplications(),
            SendInvitations()
          ]
        ),
      )
    );

  }
}

class SendApplications extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "The applications you Send",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ),
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: model.getSendAppllication(),
              builder: (context, snapshot) {
                if(snapshot.hasError){
                  return Text('Error: %{snapshot.error}');
                }
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    return ListView(
                      children: snapshot.data.documents.map((document){
                        return (document?.data != null)
                            ? _makeNotificationCard(
                            Notifi.fromSnapshot(document), context)
                            : Container(
                          height: 0.0,
                        );
                      }).toList());
                }
              }
            )
          ),
        ],
      );
    });

  }

  Widget _makeNotificationCard(Notifi notification, BuildContext context){
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(220, 220, 220, .5)),
        child: ListTile(
          isThreeLine: true,
          title: Text("To " + notification.to),
          subtitle: Text("Apply to Join " + notification.team),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ApplicationPage())
            );
          },
        )
      ),
    );
  }
}


class SendInvitations extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return ScopedModelDescendant<UserModel>(builder: (context, child, model){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Text(
              "Invitations You Send",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
          ),
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: model.getSendInvitation(),
              builder: (context, snapshot){
                if(snapshot.hasError){
                  return Text("error with ${snapshot.error}");
                }
                switch(snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    return ListView(
                        children: snapshot.data.documents.map((document) {
                          return document?.data != null
                              ? _makeNotificationCard(
                              Notifi.fromSnapshot(document), context)
                              : Container(height: 0.0);
                        }).toList());
                }
              }
              )
          ),
        ],
      );
    });
  }

  Widget _makeNotificationCard(Notifi notification, BuildContext context){
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(220, 220, 220, .5)),
        child: ListTile(
          isThreeLine: true,
          title: Text("To" + notification.to),
          subtitle: Text("Invite you to join " + notification.team),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InvitationPage())
            );
          },
        ),
      ),
    );
  }
}