import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:teamup_app/objects/user.dart';

class Conversation{
  String _userId1;
  String _userId2;
  CollectionReference _messageRef;
  String _firstName1;
  String _lastName1;
  String _firstName2;
  String _lastName2;
  User _user1;
  User _user2;
  String _firstMessage;
  String _id;


  Conversation.fromSnapshot(DocumentSnapshot snap) {
    Map<String, dynamic> data = snap.data;
    _userId1 = data["related"][0];
    _userId2 = data["related"][1];
    _messageRef = snap.reference.collection("messages").reference();
    _firstMessage = null;
    _id = snap.documentID;
  }

  setUser(BuildContext context) async{
    _user1 = await ScopedModel.of<UserModel>(context, rebuildOnChange: true).getUser(_userId1);
    _user2 = await ScopedModel.of<UserModel>(context, rebuildOnChange: true).getUser(_userId2);
  }

  setFirstMessage() async{
    QuerySnapshot temp = await _messageRef.orderBy("time", descending: true).getDocuments();
    //print("get latest message");
    //print(temp.documents.length);
    if(temp.documents.isEmpty){
      _firstMessage = "";
    }
    else{
      _firstMessage = temp.documents[0].data["content"];
    }
  }

  CollectionReference get messageRef => _messageRef;
  String get userId1 => _userId1;
  String get userId2 => _userId2;
  List<String> get related => [_userId1, _userId2];
  String get id => _id;

  String get fullName1 => _user1.firstName + " " + _user1.lastName;
  String get fullName2 => _user2.firstName + " " + _user2.lastName;
  String get firstMessage => _firstMessage;
}