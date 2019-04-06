import 'package:flutter/material.dart';
import 'package:teamup_app/objects/conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamup_app/objects/message.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class ConversationPage extends StatefulWidget {
  final Conversation _conversation;
  final int _targetIndex;
  ConversationPage(this._conversation, this._targetIndex);

  @override
  ConversationPageState createState() => ConversationPageState(_conversation, _targetIndex);
}

class ConversationPageState extends State<ConversationPage>{
  final Conversation _conversation;
  final int _targetIndex;

  ConversationPageState(this._conversation, this._targetIndex);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .9,
        title: Text(
          (_targetIndex == 0) ? _conversation.fullName1 : _conversation.fullName2,
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
        ],
      ),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: _conversation.messageRef.orderBy("time", descending: true).snapshots(),
            builder: (context, snapshot){
              if(snapshot.hasError){
                return Text("Error in ${snapshot.error}");
              }
              switch(snapshot.connectionState){
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: snapshot.data.documents.map((document){
                        return (document?.data != null) ?
                        Bubble(Message.fromSnapshot(document)) : Divider();
                      }).toList()
                  );
              }
            },
          )
      ),
      /*bottomSheet: Container(
        color: Colors.green
      ),*/
    );
  }
}


class Bubble extends StatelessWidget {
  Bubble(this.message);
  final Message message;

  @override
  Widget build(BuildContext context) {
    final received = (ScopedModel.of<UserModel>(context, rebuildOnChange: false).currentUser.id == message.from);
    //print("the value of whether it is received is");
    //print(received);
    final bg = received ? Colors.white : Colors.greenAccent.shade100;
    final align = received ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    print(align);
    final String content = message.content;
    final icon = Icons.done_all;
    final radius = received
        ? BorderRadius.only(
      topRight: Radius.circular(10.0),
      bottomLeft: Radius.circular(15.0),
      bottomRight: Radius.circular(10.0),
    )
        : BorderRadius.only(
      topLeft: Radius.circular(10.0),
      bottomLeft: Radius.circular(10.0),
      bottomRight: Radius.circular(15.0),
    );

    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.0,
                  color: Colors.black.withOpacity(.12))
            ],
            color: bg,
            borderRadius: radius,
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 48.0),
                child: Text(content),
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Row(
                  children: <Widget>[
                    Text("12:00",
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 10.0,
                        )),
                    SizedBox(width: 3.0),
                    Icon(
                      icon,
                      size: 12.0,
                      color: Colors.black38,
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}