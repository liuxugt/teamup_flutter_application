import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teamup_app/objects/course.dart';
import 'package:teamup_app/objects/course_member.dart';
import 'package:teamup_app/objects/team.dart';
import 'package:teamup_app/objects/user.dart';

class API {
  static final Firestore _firestore = Firestore.instance;
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User> getUser(String uid) async {
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
    assert (user != null);
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

    assert (user != null);
    assert (await user.getIdToken() != null);

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
    DocumentReference teamRef = _firestore.document('courses/$courseId/teams/$teamId');
    DocumentReference userRef = _firestore.document('users/$userId');

    Team team = await getTeam(courseId, teamId);

    //add the user to the team in the database
    await teamRef.updateData({'available_spots': --team.availableSpots});

    //add the team to the CourseMember
    await userRef.updateData(
        {
          'course_team.$courseId' : teamId,
          'teams' : FieldValue.arrayUnion([teamId]),
        }
    );
  }

  Future<void> leaveTeam(String userId, String courseId, String teamId) async {
//    String teamId = team.id;
    DocumentReference teamRef = _firestore.document('/courses/$courseId/teams/$teamId');
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


  Future<void> updateUserAttributes(
      String uid, Map<String, dynamic> attributes) async {
    await _firestore
        .document('/users/$uid')
        .setData({'attributes': attributes}, merge: true);
  }


  //New Added for changing database Structure
  CollectionReference getUserRef(){
    return _firestore.collection('users').reference();
  }

  DocumentReference getUserDoc(String userId){
    return _firestore.collection('users').document(userId);
  }


  Future<String> createNewTeamInCourse(String courseId, Team team) async {
    DocumentReference teamRef = await _firestore.collection('/courses/$courseId/teams').add(team.toFireBaseMap());
    await teamRef.updateData({'id': teamRef.documentID});
    return teamRef.documentID;
  }


}
