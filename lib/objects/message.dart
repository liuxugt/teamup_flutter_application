import 'package:cloud_firestore/cloud_firestore.dart';


class Message{
  String _content;
  String _fromId;
  String _toId;
  String _type;
  String _status;
  String _id;
  String _team;

  Message.fromSnapshot(DocumentSnapshot messageSnap){
    _content = messageSnap.data["content"];
    _fromId = messageSnap.data["from"];
    _toId = messageSnap.data["to"];
    _type = messageSnap.data["type"];
    _status = messageSnap.data["status"];
    _team = messageSnap.data["team"];
    _id = messageSnap.documentID;
  }

  Message(String content, String fromId, String toId, String type, String status, String team){
    _content = content;
    _fromId = fromId;
    _toId = toId;
    _type = type;
    _status = status;
    _team = team;
  }

  String get content => _content;
  String get from => _fromId;
  String get to => _toId;
  String get type => _type;
  String get status => _status;
  String get id => _id;
  String get team => _team;
}