
import 'package:cloud_firestore/cloud_firestore.dart';

class CourseMember {
  String _firstName;
  String _lastName;
  String _email;
  String teamId;
  String _id;
  String _headline;
  String _photoURL;


  CourseMember.fromSnapshotData(Map<String, dynamic> data){
    _firstName = data['first_name'];
    _lastName = data['last_name'];
    _email = data['email'];
    teamId = data['team'];
    _id = data['uid'];
    _headline = data['headline'];
    _photoURL = data['photo_url'];
  }

  CourseMember.fromSnapshot(DocumentSnapshot document){
    Map<String, dynamic> data = document.data;
    _firstName = data['first_name'];
    _lastName = data['last_name'];
    _email = data['email'];
    teamId = data['team'];
    _id = data['uid'];
    _headline = data['headline'];
    _photoURL = data['photo_url'];
  }





  // Might not need
  bool get isAvailable => teamId != null;


  String get email => _email;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get id => _id;
  String get headline => _headline;
  String get photoURL => _photoURL;
}