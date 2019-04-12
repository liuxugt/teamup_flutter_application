import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teamup_app/objects/course.dart';
import 'package:teamup_app/objects/team.dart';
import 'package:teamup_app/objects/user.dart';
//import 'package:teamup_app/objects/conversation.dart';
import 'package:teamup_app/objects/message.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class API {
  static final Firestore _firestore = Firestore.instance;
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<User> getUser(String uid) async {
    print(uid);
    DocumentSnapshot user =
        await _firestore.collection('users').document(uid).get();
    return User.fromSnapshotData(user.data);
  }

  Future<Team> getTeam(String courseId, String teamId) async {
    DocumentSnapshot teamSnap = await _firestore
        .collection('courses/$courseId/teams')
        .document(teamId)
        .get();
    return Team.fromSnapshot(teamSnap);
  }

  Future<Course> getCourse(String courseId) async {
    DocumentSnapshot courseSnap =
        await _firestore.document('/courses/$courseId').get();
    return Course.fromSnapshot(courseSnap);
  }
  /*
  Future<CourseMember> getCourseMember(String courseId, String memberId) async {
    DocumentSnapshot courseMemberSnap =
        await _firestore.document('/courses/$courseId/members/$memberId').get();
    return CourseMember.fromSnapshot(courseMemberSnap);
  }
  */

  Future<FirebaseUser> getCurrentUser() async {
    return await _firebaseAuth.currentUser();
  }

  Future<void> signInUser(String email, String password) async {
    print("begin signin");
    final FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    print("signin complete");
    assert(user != null);
    assert(await user.getIdToken() != null);
    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    assert(user.uid == currentUser.uid);
    print(" in SignInUser API, returning");
  }

  Future<void> signOutUser() async {
    await _firebaseAuth.signOut();
  }

  Future<void> registerUser(
      String email, String password, String firstName, String lastName) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    assert(user != null);
    assert(await user.getIdToken() != null);

    await _firestore.collection('users').document(user.uid).setData({
      'email': email,
      'uid': user.uid.toString(),
      'first_name': firstName,
      'last_name': lastName,
      'courses': [],
      'attributes': {},
      'photo_url': "http://rkhealth.com/wp-content/uploads/5.jpg",
      'onboard_complete': false,
      'teams': [],
      'course_team': {},
    });
  }

  Future<void> joinTeam(String userId, String courseId, String teamId) async {
//    String teamId = team.id;
    DocumentReference teamRef =
        _firestore.document('courses/$courseId/teams/$teamId');
    DocumentReference userRef = _firestore.document('users/$userId');

    Team team = await getTeam(courseId, teamId);

    //add the user to the team in the database
    await teamRef.updateData({'available_spots': --team.availableSpots});

    //add the team to the CourseMember
    await userRef.updateData({
      'course_team.$courseId': teamId,
      'teams': FieldValue.arrayUnion([teamId]),
    });
  }

  Future<void> leaveTeam(String userId, String courseId, String teamId) async {
//    String teamId = team.id;
    DocumentReference teamRef =
        _firestore.document('/courses/$courseId/teams/$teamId');
    DocumentReference userRef = _firestore.document('users/$userId');

    Team team = await getTeam(courseId, teamId);

    await userRef.updateData({
      "teams": FieldValue.arrayRemove([teamId]),
      "course_team.$courseId": null,
    });
    /*
      await _currentCourse.membersRef
          .document(_currentUser.id)
          .setData({'team': null}, merge: true);
      */
    await teamRef.updateData({'available_spots': ++team.availableSpots});
  }

  Future<void> modifyTeam(String courseId, Team team) async {
    DocumentReference teamRef =
        _firestore.document('/courses/$courseId/teams/${team.id}');
    await teamRef.updateData({
      'roles': team.roles,
      'name': team.name,
      'description' : team.description
    });
  }

  Future<void> joinCourse(String userId, String courseId) async {
//    DocumentReference courseRef = _firestore.document('/courses/$courseId');
    DocumentReference userRef = _firestore.document('users/$userId');

    await userRef.updateData({
      "courses": FieldValue.arrayUnion([courseId]),
      "course_team.$courseId": null,
    });
  }

  Future<void> updateUserAttributes(
      String uid, Map<String, dynamic> attributes) async {
    await _firestore
        .document('/users/$uid')
        .setData({'attributes': attributes}, merge: true);
  }

  //New Added for changing database Structure
  CollectionReference getUserRef() {
    return _firestore.collection('users').reference();
  }

  DocumentReference getUserDoc(String userId) {
    return _firestore.collection('users').document(userId);
  }

  Future<String> createNewTeamInCourse(String courseId, Team team) async {
    DocumentReference teamRef = await _firestore
        .collection('/courses/$courseId/teams')
        .add(team.toFireBaseMap());
    await teamRef.updateData({'id': teamRef.documentID});
    return teamRef.documentID;
  }

  Future<String> createMessage(
      String courseId, String conversationId, Message message) async {
    DocumentReference messageRef = await _firestore
        .collection('/courses/$courseId/conversations/$conversationId/messages')
        .add({
      "from": message.from,
      "to": message.to,
      "time": FieldValue.serverTimestamp(),
      "content": message.content,
      "type": message.type,
      "team": message.team,
      "status": message.status
    });
    await messageRef.updateData({"id": messageRef.documentID});
    return messageRef.documentID;
  }

  Future<void> updateMessageStatus(
      String courseId, String conversationId, String messageId) async {
    DocumentReference messageRef = _firestore.document(
        "/courses/$courseId/conversations/$conversationId/messages/$messageId");
    await messageRef.updateData({"status": "responded"});
  }

  Future<String> createConversation(
      String courseId, String id1, String id2) async {
    DocumentReference conversationRef =
        await _firestore.collection('/courses/$courseId/conversations').add({
      "related": FieldValue.arrayUnion([id1, id2])
    });
    //print("here");
    await conversationRef.updateData({"id": conversationRef.documentID});
//    print("after creating conversation");

    return conversationRef.documentID;
  }

  Stream<QuerySnapshot> getCoursesStream() {
    return _firestore.collection('courses').snapshots();
  }

  Future<String> uploadPicture(String filename, File file) async {
    final StorageReference ref = _firebaseStorage.ref().child(filename);
    final StorageUploadTask task = ref.putFile(file);
    String url = await (await task.onComplete).ref.getDownloadURL();
    return url;
  }

  Future<void> updateUserPhoto(String uid, String url) async {
    await _firestore.document('/users/$uid').updateData({'photo_url': url});
  }

  Future<void> markOnboardingComplete(String uid) async {
    await _firestore
        .document('/users/$uid')
        .updateData({'onboard_complete': true});
  }
}
