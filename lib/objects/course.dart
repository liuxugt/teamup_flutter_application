import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  String _name;
  int _groupSize;
  String _id;
  CollectionReference _membersRef;
  CollectionReference _teamsRef;
  CollectionReference _messagesRef;

  Course.fromSnapshot(DocumentSnapshot courseSnap){
    _name = courseSnap.data['name'];
    _groupSize = courseSnap.data['group_size'];
    _id = courseSnap.documentID;
    _membersRef = courseSnap.reference.collection('members').reference();
    _teamsRef = courseSnap.reference.collection('teams').reference();
    _messagesRef = courseSnap.reference.collection('messages').reference();
  }


  String get name => _name;
  int get groupSize => _groupSize;
  String get id => _id;
  CollectionReference get membersRef => _membersRef;
//  CollectionReference get projectsRef => _projectsRef;
  CollectionReference get teamsRef => _teamsRef;
  CollectionReference get messagesRef => _messagesRef;


  //TODO: potentially do the conversion here from QuerySnapshot to Team here and create a stream<Team> that is fed to the pages for better abstraction
  Stream<QuerySnapshot> get availableTeamsStream => _teamsRef.where("available_spots", isGreaterThan: 0).snapshots();
  Stream<QuerySnapshot> get unavailableTeamsStream => _teamsRef.where("available_spots", isEqualTo: 0).snapshots();
  Stream<QuerySnapshot> get availableMembersStream => _membersRef.orderBy("team").snapshots();

  Stream<QuerySnapshot> get pendingMessageStream => _messagesRef.where('status', isEqualTo: 'pending').snapshots();
  Stream<QuerySnapshot> get respondedMessageStream => _messagesRef.where('status', isEqualTo: 'responded').snapshots();

}