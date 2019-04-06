import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation{
  String _userId1;
  String _userId2;
  CollectionReference _messages;
  String _firstName1;
  String _lastName1;
  String _firstName2;
  String _lastName2;


  Conversation.fromSnapshot(DocumentSnapshot snap){
    Map<String, dynamic> data = snap.data;
    _userId1 = data["related"][0];
    _userId2 = data["related"][1];
    _firstName1 = data["first_name"][0];
    _lastName1 = data["last_name"][0];
    _firstName2 = data["first_name"][1];
    _lastName2 = data["last_name"][1];
    _messages = snap.reference.collection("message").reference();
  }

  CollectionReference get messages => _messages;
  String get userId1 => _userId1;
  String get userId2 => _userId2;
  List<String> get related => [_userId1, _userId2];
  String get firstName1 => _firstName1;
  String get firstName2 => _firstName2;
  String get lastName1 => _lastName1;
  String get lastName2 => _lastName2;

  String get fullName1 => (_firstName1 + " " + _lastName1);
  String get fullName2 => (_firstName2 + " " + _lastName2);
}