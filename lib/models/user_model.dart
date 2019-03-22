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
  final API _api = API();


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
      FirebaseUser user = await _api.getCurrentUser();
      print('user ${user.uid} is loaded');
        _currentUser = await _api.getUser(user.uid);
        await _loadCourseAndTeam();
        return true;
    } catch (e) {
      print("Error loading user: " + e.toString());
      _error = e.toString();
    }
    return false;
  }

  Future<void> _loadCourseAndTeam([String id = ""]) async {
      String courseId = (id.isEmpty) ? _currentUser.courseIds.first : id;

      _currentCourse = await _api.getCourse(courseId);

      CourseMember courseMember =
          await _api.getCourseMember(courseId, _currentUser.id);

      _currentTeam = (courseMember?.teamId != null) ? await _api.getTeam(courseId, courseMember.teamId) : null;


  }

  Future<bool> signInUser(String email, String password) async {
    try {
      await _api.signInUser(email, password);
      return loadCurrentUser();
    } catch (error) {
      _error = error.toString();
      print(_error);
    }
    return false;
  }

  Future<bool> registerUser(
      String email, String password, String firstName, String lastName) async {
    try {

      _api.registerUser(email, password, firstName, lastName);
      _error = "";
      return true;
    } catch (error) {
      _error = error.toString();
      print(_error);
    }
    return false;
  }

  Future<bool> signOut() async {
    try {
      await _api.signOutUser();
      _currentCourse = null;
      _currentUser = null;
      _currentTeam = null;
      _error = "";
      return true;
    }catch(error){
      _error = error.toString();
      print(_error);
    }
    return false;
  }

  void changeCourse(String courseId) async {
    try {
      await _loadCourseAndTeam(courseId);
      notifyListeners();
    }catch(error){
      _error = error.toString();
      print(_error);
    }
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
        _error = "";
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
      _error = "";
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
    return _api.getUser(uid);
  }
}
