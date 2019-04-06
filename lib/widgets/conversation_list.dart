import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/objects/conversation.dart';
import 'package:teamup_app/objects/user.dart';

class ConversationList extends StatelessWidget{
  Widget _MakeCard(Conversation conv, BuildContext context){
    String name;
    if(conv.related[0] == ScopedModel.of<UserModel>(context, rebuildOnChange: false).currentUser.id){
      name = conv.fullName2;
    }
    else{
      name = conv.fullName1;
    }

    return ListTile(
      contentPadding: EdgeInsets.all(10),
      title: Text("From " + name),
      onTap: (){},
    );
  }

  @override
  build(BuildContext context){
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      if (!model.hasCourse) return Center(child: Text('No Courses'));
      return StreamBuilder<QuerySnapshot>(
        stream: model.getConvsersations(),
        builder: (context, snapshot){
          if (snapshot.hasError)
            return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              return ListView(
                  children: snapshot.data.documents.map((document) {
                    return (document?.data != null) ?
                    _MakeCard(Conversation.fromSnapshot(document), context) :
                    Divider();
                  }).toList()
              );
          }
        });
    });
  }
}