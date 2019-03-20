import 'package:cloud_firestore/cloud_firestore.dart';


class Team {
  String name;
  String description;
  String _id;
  int availableSpots;



  String get id => _id;
  bool get isFull => availableSpots == 0;



  Team.fromSnapshot(DocumentSnapshot snap){
    //TODO: make these null safe

    Map<String, dynamic> data = snap.data;

    name = data['name'];
    description = data['description'];
    _id = snap.documentID;
    availableSpots = data['available_spots'];
  }



  Team.fromSnapshotData(Map<String, dynamic> data){
    //TODO: make these null safe

    name = data['name'];
    description = data['description'];
    _id = data['id'];
    availableSpots = data['available_spots'];
  }
}