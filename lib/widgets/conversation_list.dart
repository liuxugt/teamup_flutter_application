import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/objects/conversation.dart';
import 'package:teamup_app/pages/conversation_page.dart';


class ConversationList extends StatelessWidget{
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
                  children: snapshot.data.documents.map((document){
                    return (document?.data != null) ?
                    ListElement(Conversation.fromSnapshot(document)) :
                    Divider();
                  }).toList()
              );
          }
        });
    });
  }
}

class ListElement extends StatefulWidget {
  final Conversation _conv;

  ListElement(this._conv);

  @override
  _ListElementState createState() => _ListElementState(_conv);
}



class _ListElementState extends State<ListElement> {
  final Conversation _conv;

  _ListElementState(this._conv);

  _loadUser() async {
    await _conv.setUser(context);
    await _conv.setFirstMessage();
    return _conv;
  }

  @override
  Widget build(BuildContext context){
    return Column(
      children: [FutureBuilder(
        future: _loadUser(),
        builder: (context, AsyncSnapshot<dynamic> conv){
          if(!conv.hasData) return Container();
          String name;
          int index;
          if(conv.data.related[0] == ScopedModel.of<UserModel>(context, rebuildOnChange: false).currentUser.id){
            name = conv.data.fullName2;
            index = 1;
          }
          else{
            name = conv.data.fullName1;
            index = 0;
          }
          return ListTile(
            contentPadding: EdgeInsets.only(top: 10, left: 10),
            title: Text(name),
            subtitle: Text(_conv.firstMessage),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConversationPage(_conv, index)));
            },
          );
        },
      ),
    Divider()]
    );
  }
}