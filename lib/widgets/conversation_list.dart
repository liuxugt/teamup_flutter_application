import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/objects/conversation.dart';
import 'package:teamup_app/objects/user.dart';
import 'package:teamup_app/pages/conversation_page.dart';


class ConversationList extends StatefulWidget{
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> with AutomaticKeepAliveClientMixin<ConversationList> {

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

  @override
  bool get wantKeepAlive => true;
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
    User user1 = await ScopedModel.of<UserModel>(context, rebuildOnChange: false).getUser(_conv.userId1);
    User user2 = await ScopedModel.of<UserModel>(context, rebuildOnChange: false).getUser(_conv.userId2);

//    await _conv.setUser(context);
    await _conv.setUsers(user1, user2);
    await _conv.setFirstMessage();
    return _conv;
  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder(
        future: _loadUser(),
        builder: (context, AsyncSnapshot<dynamic> conv){
          if(!conv.hasData) return Container();

          String name;
          int index;
          String photoURL;
          if(_conv.related[0] == ScopedModel.of<UserModel>(context, rebuildOnChange: false).currentUser.id){
            name = _conv.fullName2;
            index = 1;
            photoURL = _conv.user2.photoURL;
          }
          else{
            name = _conv.fullName1;
            index = 0;
            photoURL = _conv.user1.photoURL;
          }
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(photoURL),
              radius: 24.0,
            ),
            title: Text(name,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(_conv.firstMessage),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConversationPage(_conv, index)));
            },
          );
        },
      );
  }
}