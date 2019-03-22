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

  Future<CourseMember> getCourseMember(String courseId, String memberId) async {
    DocumentSnapshot courseMemberSnap =
        await _firestore.document('/courses/$courseId/members/$memberId').get();
    return CourseMember.fromSnapshot(courseMemberSnap);
  }

  Future<FirebaseUser> getCurrentUser() async {
    return await _firebaseAuth.currentUser();
  }

  Future<void> signInUser(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOutUser() async {
    await _firebaseAuth.signOut();
  }


  Future<void> registerUser(
      String email, String password, String firstName, String lastName) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    await _firestore.collection('users').document(user.uid).setData({
      'email': email,
      'uid': user.uid.toString(),
      'first_name': firstName,
      'last_name': lastName,
      'courses': [],
      'attributes': {},
      'photo_url': "http://rkhealth.com/wp-content/uploads/5.jpg",
      'onboard_complete': false,
    });
  }

}
