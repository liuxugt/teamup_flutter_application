import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  String _name;
  int _groupSize;
  String _id;
  CollectionReference _membersRef;
  CollectionReference _projectsRef;


  Course.fromSnapshot(DocumentSnapshot courseSnap){
    _name = courseSnap.data['name'];
    _groupSize = courseSnap.data['group_size'];
    _id = courseSnap.documentID;
    _membersRef = courseSnap.reference.collection('members').reference();
    _projectsRef = courseSnap.reference.collection('projects').reference();
  }


  String get name => _name;
  String get groupSize => _groupSize;
  int get id => _id;
  CollectionReference get membersRef => _membersRef;
  CollectionReference get projectsRef => _projectsRef;

}