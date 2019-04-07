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
  String content;
  TextEditingController _messageController = new TextEditingController();

  ConversationPageState(this._conversation, this._targetIndex);

  Widget buildListMessage(){
    return Flexible(
//        padding: EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _conversation.messageRef.orderBy("time", descending: false).snapshots(),
          builder: (context, snapshot){
            if(snapshot.hasError){
              return Text("Error in ${snapshot.error}");
            }
            switch(snapshot.connectionState){
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                return ListView(
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  physics: ClampingScrollPhysics(),
                    children: snapshot.data.documents.map((document){
                      return (document?.data != null) ?
                      Bubble(Message.fromSnapshot(document), _conversation.id) : Divider();
                    }).toList()
                );
            }
          },
        )
    );
  }

  Widget buildInput(){
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration.collapsed(hintText: 'type your message here', hintStyle: TextStyle(color: Colors.grey)),
                onChanged: (value) => content = value,
              )
          ),
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: (){
                    String toId = _conversation.related[_targetIndex];
                    ScopedModel.of<UserModel>(context, rebuildOnChange: true).sendRegularMessage(toId, _conversation.id, content);
                    _messageController.clear();
                    content = "";
                  })
            )
          )
        ],
      )
    );
  }

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
    body: Column(
      children: <Widget>[
        buildListMessage(),
        buildInput()
      ],
    ),
    );
  }
}


class Bubble extends StatelessWidget {
  Bubble(this.message, this.conversationId);
  final Message message;
  final String conversationId;

  @override
  Widget build(BuildContext context) {
    final received = (ScopedModel.of<UserModel>(context, rebuildOnChange: false).currentUser.id != message.from);
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
    //print(message.type);
    print(message.status);
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
                padding: (message.type == "regular" ) ? EdgeInsets.only(right: 48.0) : (message.status == "pending") ? EdgeInsets.only(right: 48.0, bottom: 45.0) : EdgeInsets.only(right: 48.0, bottom: 20.0),
                child: Text(content),
              ),
              (received && message.type != "regular" && message.status == "pending") ?
              Positioned(
                //padding: EdgeInsets.only(right: 48.0, top: 20.0),
                bottom: 0.0,
                left: 0.0,
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      textColor: Colors.blue,
                      child: Text("Accept"),
                      onPressed: (){
                        if(message.type == "application"){
                          ScopedModel.of<UserModel>(context).acceptApplication(message, conversationId);
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10.0)
                    ),
                    FlatButton(
                      child: Text("Reject"),
                      textColor: Colors.red,
                      onPressed: (){
                        if(message.type=="application"){
                          ScopedModel.of<UserModel>(context).rejectApplication(message, conversationId);
                        }
                      },
                    )
                  ],
                )
              ) :
              (message.type != "regular" && message.status != "pending") ?
              Positioned(
                  //padding: EdgeInsets.only(right: 48.0, top: 20.0),
                  bottom: 0.0,
                  left: 0.0,
                  child: Text("This has been responded")
              ) :
                  Container(width: 0.0, height: 0.0),
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