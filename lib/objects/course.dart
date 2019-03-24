import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  String _name;
  int _groupSize;
  String _id;
  CollectionReference _membersRef;
  CollectionReference _teamsRef;
  CollectionReference _applicationRef;
  CollectionReference _invitationRef;

  Course.fromSnapshot(DocumentSnapshot courseSnap){
    _name = courseSnap.data['name'];
    _groupSize = courseSnap.data['group_size'];
    _id = courseSnap.documentID;
    _membersRef = courseSnap.reference.collection('members').reference();
    _teamsRef = courseSnap.reference.collection('teams').reference();
    _applicationRef = courseSnap.reference.collection('applications').reference();
    _invitationRef = courseSnap.reference.collection('invitations').reference();
  }


  String get name => _name;
  int get groupSize => _groupSize;
  String get id => _id;
  CollectionReference get membersRef => _membersRef;
//  CollectionReference get projectsRef => _projectsRef;
  CollectionReference get teamsRef => _teamsRef;
  CollectionReference get applicationRef => _applicationRef;
  CollectionReference get invitationRef => _invitationRef;


  //TODO: potentially do the conversion here from QuerySnapshot to Team here and create a stream<Team> that is fed to the pages for better abstraction
  Stream<QuerySnapshot> get availableTeamsStream => _teamsRef.where("available_spots", isGreaterThan: 0).snapshots();
  Stream<QuerySnapshot> get unavailableTeamsStream => _teamsRef.where("available_spots", isEqualTo: 0).snapshots();
  Stream<QuerySnapshot> get availableMembersStream => _membersRef.orderBy("team").snapshots();

  Stream<QuerySnapshot> get pendingApplicationStream => _applicationRef.where("status", isEqualTo: "pending").snapshots();
  Stream<QuerySnapshot> get respondedApplicationStream => _applicationRef.where("status", isEqualTo: "responded").snapshots();
  Stream<QuerySnapshot> get pendingInvitationStream => _invitationRef.where("status", isEqualTo: "pending").snapshots();
  Stream<QuerySnapshot> get respondedInvitationStream => _invitationRef.where("status", isEqualTo: "responded").snapshots();
}