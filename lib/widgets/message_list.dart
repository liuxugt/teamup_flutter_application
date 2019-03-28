import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/pages/home_page.dart';
import 'package:teamup_app/objects/notification.dart';

class MessageList extends StatelessWidget{
  Widget makeMessageBubble(Notifi notification, BuildContext context){
    final is_send = notification.from != ScopedModel.of<UserModel>(context, rebuildOnChange: true).currentUser.id;
    final is_application = notification.type == 'application';
    final radius = is_send
        ? BorderRadius.only(
        topRight: Radius.circular(10.0),
        bottomLeft: Radius.circular(20.0),
        bottomRight: Radius.circular(10.0))
        : BorderRadius.only(
        topLeft: Radius.circular(10.0),
        bottomLeft: Radius.circular(10.0),
        bottomRight: Radius.circular(20.0));
    return Column(
      crossAxisAlignment: (is_send) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
          Container(
            margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: (is_send) ? Colors.blue : Colors.green,
              borderRadius: radius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                notification.status == "pending" ?
                  Text("new ${notification.type} ${is_send}", style: TextStyle(fontSize: 20))
                    :
                  Text("${notification.type}", style: TextStyle(fontSize: 20)),
                is_send ?
                  Text("You send an ${notification.type} to ")
                    :
                  Text("${notification.fromFirst} ${notification.fromLast} "),
                notification.status == "pending" ?
                    Row(
                      children: <Widget>[
                        is_application ?
                        RaisedButton(
                          child: Text("accept"),
                          onPressed: (){
                            print("accept application");
                            //ScopedModel.of<UserModel>(context, rebuildOnChange: false).acceptApplication(notification);
                          },
                        ) : RaisedButton(
                          child: Text("accept"),
                          onPressed: (){
                            print("accept invitation");
                            //ScopedModel.of<UserModel>(context, rebuildOnChange: false).acceptInvitation(notification);
                          }
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.0, right: 5.0),
                        ),
                        RaisedButton(
                          child: Text("reject"),
                          onPressed: (){
                            print("reject message");
                            //ScopedModel.of<UserModel>(context, rebuildOnChange: false).rejectApplication(notification);
                          }
                        )
                      ],
                    )
                    :
                    Text("The message has been ${notification.status}")
              ],
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context){
    return ScopedModelDescendant<UserModel>(builder: (context, child, model){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: model.getMessage(),
                builder: (context, snapshot) {
                if(snapshot.hasError){
                  return Text("error, ${snapshot.error}");
                }
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                    break;
                  default:
                    return ListView(
                      children: snapshot.data.documents.map((document){
                        print(document.data["from_first"]);
                        if(document?.data == null){
                          return Container(height: 0.0);
                        }
                        else{
                          return makeMessageBubble(new Notifi.fromSnapshot(document), context);
                        }
                      }).toList()
                    );
                }
              },
            )
          ),
        ],
      );
    });
  }
}
