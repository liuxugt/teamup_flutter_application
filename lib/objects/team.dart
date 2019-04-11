import 'package:cloud_firestore/cloud_firestore.dart';


class Team {
  String name;
  String description;
  String _id;
  int availableSpots;
  String _leader;
  List<dynamic> roles;


  String get id => _id;
  bool get isFull => availableSpots == 0;
  String get leader => _leader;



  Team.fromSnapshot(DocumentSnapshot snap){
    //TODO: make these null safe

    Map<String, dynamic> data = snap.data;
    name = data['name'];
    description = data['description'];
    _id = snap.documentID;
    availableSpots = data['available_spots'];
    _leader = data['leader'];
    roles = data.containsKey("roles") ? data['roles'] : [];

  }



  Team.fromSnapshotData(Map<String, dynamic> data){
    //TODO: make these null safe

    name = data['name'];
    description = data['description'];
    _id = data['id'];
    availableSpots = data['available_spots'];
    _leader = data['leader'];
    roles = data.containsKey("roles") ? data['roles'] : [];
  }

  Team({this.availableSpots, this.name, this.description, this.roles, String leaderId}){
    _leader = leaderId;
    _id = "";
  }

  Map<String, dynamic> toFireBaseMap(){
    return {
      'name': name,
      'description': description,
      'available_spots': availableSpots,
      'id': _id,
      'leader': _leader,
      'roles': roles
    };
  }
  void set id(String id){
    this._id = id;
  }
}