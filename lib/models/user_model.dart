import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/objects/course.dart';
import 'package:teamup_app/objects/course_member.dart';
import 'package:teamup_app/objects/team.dart';
import 'package:teamup_app/objects/user.dart';

class UserModel extends Model {
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User _currentUser;
  Course _currentCourse;
  Team _currentTeam;

  String _error = "";

  Course get currentCourse => _currentCourse;
  User get currentUser => _currentUser;
  Team get currentTeam => _currentTeam;

  String get error => _error;
  bool get hasCourse => _currentCourse != null;
  String get courseTitle => _currentCourse?.id ?? "No Courses";
  bool get userInTeam => _currentTeam != null;

  UserModel() {
    print("User Model Initialized");
//    loadCurrentUser();
  }

  Future<bool> loadCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if (user != null && user.uid != "") {
      DocumentSnapshot userSnap =
          await _firestore.document('/users/${user.uid}').get();
      if (userSnap?.data != null) {
        _currentUser = User.fromSnapshotData(userSnap.data);
        return _loadCourseAndTeam();
      }
    }
    return false;
  }

  Future<bool> _loadCourseAndTeam([String id = ""]) async {
    if (_currentUser?.courseIds == null || _currentUser.courseIds.isEmpty)
      return false;
    try {
      String courseId = (id.isEmpty) ? _currentUser.courseIds.first : id;

      DocumentSnapshot courseSnap =
          await _firestore.document('/courses/$courseId').get();

      _currentCourse =
          (courseSnap?.data != null) ? Course.fromSnapshot(courseSnap) : null;

      DocumentSnapshot courseMemberSnap = await _firestore
          .document('/courses/$courseId/members/${_currentUser.id}')
          .get();

      if (courseMemberSnap?.data != null) {
        CourseMember courseMember = CourseMember.fromSnapshot(courseMemberSnap);
        if (courseMember.teamId != null) {
          DocumentSnapshot teamSnap = await _firestore
              .document('/courses/$courseId/teams/${courseMember.teamId}')
              .get();

          _currentTeam =
              (teamSnap?.data != null) ? Team.fromSnapshot(teamSnap) : null;
        } else {
          _currentTeam = null;
        }
      }
      return true;
    } catch (error) {
      _error = error.toString();
    }
    return false;
  }

  Future<bool> signInUser(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return loadCurrentUser();
    } catch (error) {
      _error = error.toString();
    }
    return false;
  }

  Future<bool> registerUser(
      String email, String password, String firstName, String lastName) async {
    try {
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
      return true;
    } catch (error) {
      _error = error.toString();
    }
    return false;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _currentCourse = null;
    _currentUser = null;
    _currentTeam = null;
    return;
  }

  void changeCourse(String courseId) async {
    await _loadCourseAndTeam(courseId);
    notifyListeners();
  }

  Future<bool> joinTeam(String teamId) async {
    print('Join Team initiated with $teamId and ${_currentUser.firstName}');
    try {
      DocumentSnapshot teamSnap =
          await _currentCourse.teamsRef.document(teamId).get();

      Team team = Team.fromSnapshot(teamSnap);

      print('Team Created -  ${team.name}');
      //if user is not part of a team and the team is not full
      if (!userInTeam && !team.isFull) {
        print("user not part of team and team is not full");
        //update team locally and set it as current user's team
        --team.availableSpots;
        _currentTeam = team;

        //add the user to the team in the database
        await teamSnap.reference
            .setData({'available_spots': team.availableSpots}, merge: true);

        //add the team to the CourseMember
        await _currentCourse.membersRef
            .document(_currentUser.id)
            .setData({'team': currentTeam.id}, merge: true);

        return true;
      }
    } catch (e) {
      print('error occurred!!!  -   ${e.toString()}');
      _error = e.toString();
    }
    return false;
  }

  //TODO: Leave team function




  Stream<QuerySnapshot> getTeamMembersStream(String teamId) {
    if (_currentCourse == null) return null;
    return _currentCourse.membersRef
        .where('team', isEqualTo: teamId)
        .snapshots();
  }

  Future<User> getUser(String uid) async {
    DocumentSnapshot user = await _firestore.collection('users').document(uid).get();
    return User.fromSnapshotData(user.data);
  }


}
