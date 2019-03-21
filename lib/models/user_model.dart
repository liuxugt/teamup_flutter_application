import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/objects/course.dart';
import 'package:teamup_app/objects/course_member.dart';
import 'package:teamup_app/objects/team.dart';
import 'package:teamup_app/objects/user.dart';
import 'package:teamup_app/services/api.dart';

class UserModel extends Model {
  //TODO: start moving database functions into the API
  final API api = API();


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
    try {
      FirebaseUser user = await api.getCurrentUser();
      if (user != null && user.uid != "") {
        _currentUser = await api.getUser(user.uid);
        return _loadCourseAndTeam();

      }
    } catch (e) {
      print(e.toString());
      _error = e.toString();
    }
    return false;
  }

  Future<bool> _loadCourseAndTeam([String id = ""]) async {
    if (_currentUser == null || _currentUser.courseIds.isEmpty)
      return false;
    try {
      String courseId = (id.isEmpty) ? _currentUser.courseIds.first : id;
      _currentCourse = await api.getCourse(courseId);

      CourseMember courseMember =
          await api.getCourseMember(courseId, _currentUser.id);

      if (courseMember.teamId != null) {
        _currentTeam = await api.getTeam(courseId, courseMember.teamId);
      } else {
        _currentTeam = null;
      }


      return true;
    } catch (error) {
      _error = error.toString();
    }
    return false;
  }

  Future<bool> signInUser(String email, String password) async {
    try {
      await api.signInUser(email, password);
      loadCurrentUser();
      return true;
    } catch (error) {
      _error = error.toString();
      print(_error);
    }
    return false;
  }

  Future<bool> registerUser(
      String email, String password, String firstName, String lastName) async {
    try {

      api.registerUser(email, password, firstName, lastName);
      return true;
    } catch (error) {
      _error = error.toString();
      print(_error);
    }
    return false;
  }

  Future<bool> signOut() async {
    try {
      await api.signOutUser();
      _currentCourse = null;
      _currentUser = null;
      _currentTeam = null;
      return true;
    }catch(error){
      _error = error.toString();
      print(_error);
    }
    return false;
  }

  void changeCourse(String courseId) async {
    await _loadCourseAndTeam(courseId);
    notifyListeners();
  }

  Future<bool> joinTeam(Team team) async {
    try {
      DocumentReference teamRef = _currentCourse.teamsRef.document(team.id);
      //if user is not part of a team and the team is not full
      if (!userInTeam && !team.isFull) {
        //add the user to the team in the database
        await teamRef
            .setData({'available_spots': --team.availableSpots}, merge: true);

        //add the team to the CourseMember
        await _currentCourse.membersRef
            .document(_currentUser.id)
            .setData({'team': team.id}, merge: true);

        //set the current team
        _currentTeam = team;
        //return successful execution
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = e.toString();
      print(_error);
    }
    return false;
  }

  Future<bool> leaveCurrentTeam() async {
    try {
      DocumentReference teamRef =
          _currentCourse.teamsRef.document(_currentTeam.id);

      await _currentCourse.membersRef
          .document(_currentUser.id)
          .setData({'team': null}, merge: true);

      await teamRef.setData({'available_spots': ++_currentTeam.availableSpots},
          merge: true);

      //set local team to null
      _currentTeam = null;

      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      print(_error);
    }
    return false;
  }

  Stream<QuerySnapshot> getTeamMembersStream(String teamId) {
    if (_currentCourse == null) return null;
    return _currentCourse.membersRef
        .where('team', isEqualTo: teamId)
        .snapshots();
  }

  Future<User> getUser(String uid) async {
    return api.getUser(uid);
  }
}
