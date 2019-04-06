import 'package:cloud_firestore/cloud_firestore.dart';


class Message{
  String _content;
  String _fromId;
  String _toId;
  String _type;
  String _status;

  Message.fromSnapshot(DocumentSnapshot messageSnap){
    _content = messageSnap.data["content"];
    _fromId = messageSnap.data["from"];
    _toId = messageSnap.data["to"];
    _type = messageSnap.data["type"];
    _status = messageSnap.data["status"];
  }

  String get content => _content;
  String get from => _fromId;
  String get to => _toId;
  String get type => _type;
  String get status => _status;
}