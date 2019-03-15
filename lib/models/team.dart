

import 'package:cloud_firestore/cloud_firestore.dart';

class Team {
  String _name;
  String _description;
  bool isFull;
  String _id;
  int numMembers;




  // ignore: unnecessary_getters_setters
  String get name => _name;
  String get description => _description;

  String get id => _id;



  Team.fromSnapshot(DocumentSnapshot snap){
    //TODO: make these null safe
    _name = snap.data['name'];
    _description = snap.data['description'];
    isFull = snap.data['is_full'];
    _id = snap.documentID;
    numMembers = snap.data.containsKey('num_members') ? snap.data['num_members'] : 0;
  }

}