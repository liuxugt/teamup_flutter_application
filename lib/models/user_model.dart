import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/course.dart';
import 'package:teamup_app/models/course_user.dart';
import 'package:teamup_app/models/team.dart';
import 'package:teamup_app/models/user.dart';

class UserModel extends Model {
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User _currentUser;
  Course _currentCourse;
  Team _currentTeam;
  CourseUser _currentCourseUser;
  String _error = "";

  Course get currentCourse => _currentCourse;
  User get currentUser => _currentUser;
  String get error => _error;
  bool get hasCourse => _currentCourse != null;
  String get courseTitle => _currentCourse?.id ?? "No Courses";
  bool get userInTeam => _currentTeam != null;
  Team get currentTeam => _currentTeam;




  UserModel() {
    print("User Model Initialized");
    loadCurrentUser();
  }

  Future<bool> loadCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if (user != null && user.uid != "") {
      DocumentSnapshot userSnap =
          await _firestore.document('/users/${user.uid}').get();
      if (userSnap?.data != null) {
        _currentUser = User.fromSnapshotData(userSnap.data);
        await _loadCourseAndTeam();
        return true;
      }
    }
    return false;
  }

  Future<void> _loadCourseAndTeam([String id = ""]) async {
    if(_currentUser?.courseIds == null || _currentUser.courseIds.isEmpty) return;


    String courseId = (id.isEmpty) ? _currentUser.courseIds.first : id;


    DocumentSnapshot courseSnap =
        await _firestore.document('/courses/$courseId').get();

    DocumentSnapshot courseUserSnap = await _firestore
        .document('/courses/$courseId/members/${_currentUser.id}')
        .get();

    _currentCourse = (courseSnap?.data != null) ? Course.fromSnapshot(courseSnap) : null;

    if (courseUserSnap?.data != null) {
      _currentCourseUser = CourseUser.fromSnapshotData(courseUserSnap.data);
      if (_currentCourseUser.teamId != null) {
        DocumentSnapshot teamSnap = await _firestore
            .document(
                '/courses/${_currentCourse.id}/teams/${_currentCourseUser.teamId}')
            .get();
        _currentTeam = (teamSnap?.data != null) ? Team.fromSnapshot(teamSnap) : null;
      }else {
        _currentTeam = null;
      }
    }else{
      _currentCourseUser = null;
    }
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
        'courses': []
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
    _currentCourseUser = null;
    return;
  }

  void changeCourse(String courseId) async {
    await _loadCourseAndTeam(courseId);
    notifyListeners();
  }

  Future<bool> joinTeam(String teamId) async {
    try {
      //make sure current user exists and is in a course and the user is not already in a team (they are available)
      if (_currentUser != null && _currentCourse != null && !_currentCourseUser.isAvailable) {
        DocumentReference teamRef = _firestore.document('/courses/${_currentCourse.id}/teams/$teamId');
        DocumentSnapshot teamSnap = await teamRef.get();
        if (teamSnap.exists) {
          Team team = Team.fromSnapshot(teamSnap);
          //if user is not in the group, if user is available, if user is not part of a project
          if (!team.isFull) {
            ++team.numMembers;
            team.isFull = team.numMembers >= _currentCourse.groupSize;
            _currentCourseUser.teamId = teamId;
            _currentTeam = team;

            //add the user to the team
            await teamRef.setData({
              'num_members': team.numMembers,
              'is_full': team.isFull
            }, merge: true);
            //add the team to the CourseUser
            await _firestore
                .document(
                    'courses/${_currentCourse.id}/members/${_currentUser.id}')
                .setData({'team': _currentCourseUser.teamId}, merge: true);
            return true;
          }
        }
      }
    } catch (e) {
      _error = e.toString();
    }
    return false;
  }

  Stream<QuerySnapshot> getTeamMembers(String teamId){
    if(_currentCourse == null) return null;
    return _firestore.collection('courses/${_currentCourse.id}/users').where('team', isEqualTo: teamId).snapshots();
  }


}
