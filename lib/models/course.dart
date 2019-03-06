import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  String _name;
  int _groupSize;
  String _id;
  CollectionReference _membersRef;
  CollectionReference _projectsRef;
  CollectionReference _teamsRef;


  Course.fromSnapshot(DocumentSnapshot courseSnap){
    _name = courseSnap.data['name'];
    _groupSize = courseSnap.data['group_size'];
    _id = courseSnap.documentID;
    _membersRef = courseSnap.reference.collection('members').reference();
    _projectsRef = courseSnap.reference.collection('projects').reference();
    _teamsRef = courseSnap.reference.collection('teams').reference();

  }


  String get name => _name;
  int get groupSize => _groupSize;
  String get id => _id;
  CollectionReference get membersRef => _membersRef;
  CollectionReference get projectsRef => _projectsRef;
  CollectionReference get teamsRef => _teamsRef;

}