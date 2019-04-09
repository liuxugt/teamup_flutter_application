import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/objects/course.dart';
import 'package:teamup_app/objects/team.dart';
import 'package:teamup_app/objects/user.dart';
import 'package:teamup_app/services/api.dart';
import 'package:teamup_app/objects/message.dart';
import 'package:teamup_app/objects/conversation.dart';

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

  //New Added variable for changing database structure
  CollectionReference _userRef;

  UserModel() {
    print("User Model Initialized");
    _userRef = _api.getUserRef();
//    loadCurrentUser();
  }

  Future<bool> loadCurrentUser() async {
    try {
      FirebaseUser user = await _api.getCurrentUser();
//      print('user ${user.uid} is loaded');
        _currentUser = await _api.getUser(user.uid);
        print("get user");
        await _loadCourseAndTeam();
        return true;
    } catch (e) {
      print("Error loading user: " + e.toString());
      _error = e.toString();
    }
    return false;
  }

  Future<void> _loadCourseAndTeam([String id = ""]) async {
    String courseId;
    if(_currentUser.courseIds.isEmpty){
      _currentCourse = null;
      _currentTeam = null;
      return;
    }
    else{
      courseId = (id.isEmpty) ? _currentUser.courseIds.first : id;
    }
    print("get course");
    print(courseId);

    _currentCourse = await _api.getCourse(courseId);

    if(courseId == ""){
      _currentTeam = null;
    }
    else{
      _currentTeam = (_currentUser.courseTeam[courseId] != null) ? await _api.getTeam(courseId, _currentUser.courseTeam[courseId]) : null;
    }
  }

  Future<bool> signInUser(String email, String password) async {
    try {
      print("SignInUser (UserModel)");
      await _api.signInUser(email, password);
      print("Got current user, loading current user...");
      return loadCurrentUser();
    } catch (error) {
      print("test");
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
      String courseId = _currentCourse.id;
      String userId = _currentUser.id;
      String teamId = team.id;

//      DocumentReference teamRef = _currentCourse.teamsRef.document(team.id);
      //if user is not part of a team and the team is not full
      if (!userInTeam && !team.isFull) {

        await _api.joinTeam(userId, courseId, teamId);

        //set the current team
        _currentTeam = await _api.getTeam(courseId, team.id);
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
      String courseId = _currentCourse.id;
      String userId = _currentUser.id;

      await _api.leaveTeam(userId, courseId, _currentTeam.id);

      _currentUser.teamIds.remove(_currentTeam.id);
      print(_currentUser.courseTeam);
      _currentUser.courseTeam.update(_currentCourse.id, (dynamic val) => null, ifAbsent: () => null);
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


  Future<bool> createTeamAndJoin(Team team) async{
    try{
      String teamId = await _api.createNewTeamInCourse(_currentCourse.id, team);
      await _api.joinTeam(_currentUser.id, _currentCourse.id, teamId);
      _currentTeam = await _api.getTeam(_currentCourse.id, teamId);
      _error = "";
      notifyListeners();
      return true;
    }catch(e){
      _error = e.toString();
      print(_error);
    }
    return false;
  }

  Future<bool> joinCourse(Course course) async {
    try{
      await _api.joinCourse(currentUser.id, course.id);
      await loadCurrentUser();
      _error = "";
      return true;
    }catch(e){
      _error = e.toString();
      print(_error);
    }
    return false;
  }


  Future<User> getUser(String uid) async {
    return _api.getUser(uid);
  }

  //Added Functions for changing database structure

  Stream<QuerySnapshot> getTeamMembersStream(String teamId) {
    if (_currentCourse == null) return null;
    return _userRef.where('teams', arrayContains: teamId).snapshots();
  }

  Stream<QuerySnapshot> getClassMates(){
    if(_currentCourse == null) return null;
    return _userRef.where('courses', arrayContains: _currentCourse.id).snapshots();
  }

  Stream<QuerySnapshot> getTeams() {
    if (_currentCourse == null) return null;
    return _currentCourse.availableTeamsStream;
  }

  Stream<QuerySnapshot> getCourses(){
    return _api.getCoursesStream();
  }




  Stream<QuerySnapshot> getConvsersations(){
    if(_currentCourse == null || _currentUser == null) return null;
    return _currentCourse.conversationRef.where('related', arrayContains: _currentUser.id).snapshots();
  }

  Future<void> sendRegularMessage(String toId, String conversationId, String content) async{
    String type = "regular";
    Message temp = Message(content, currentUser.id, toId, "regular", "pending", "");
    await _api.createMessage(currentCourse.id, conversationId, temp);
  }

  Future<bool> createApplication(Team team) async {
    //QuerySnapshot currentConversation = await _currentCourse.conversationRef.where("related", arrayContains: fromId).where("related", arrayContains: toId).getDocuments();
//    DocumentSnapshot team = await _currentCourse.teamsRef.document(teamId).get();
//    Team team = await _api.getTeam(_currentCourse.id, teamId);

    try {
      String content = "Hey, I would like to join your team: ${team
          .name} in ${_currentCourse.id}";
      Message temp = Message(
          content, _currentUser.id, team.leader, "application", "pending",
          team.id);
      //if(currentConversation.documents.length != 0){
      //  conversationId = currentConversation.documents[0].documentID;
      //  await _api.createMessage(courseId, conversationId, temp);
      //}
      //else{
      String conversationId = await _api.createConversation(
          _currentCourse.id, _currentUser.id, team.leader);
      await _api.createMessage(_currentCourse.id, conversationId, temp);
      _error = "";
      return true;
    }catch(e){
      _error = e.toString();
    }
    return false;
    //}
//    return conversationId;
  }

  Future<void> acceptApplication(Message message, String conversationId) async {
    DocumentReference temp = _currentCourse.conversationRef.document(conversationId).collection("messages").document(message.id);
    temp.updateData({
      "status": "responded"
    });
    DocumentSnapshot newSnapshot = await _userRef.document(message.from).get();
    String courseId = _currentCourse.id;
    if(newSnapshot.data["course_team"][courseId] == null){
      _api.joinTeam(message.from, courseId, message.team);
    }
  }
  Future<void> rejectApplication(Message message, String conversationId) async {
    DocumentReference temp = _currentCourse.conversationRef.document(conversationId).collection("messages").document(message.id);
    temp.updateData({
      "status": "responded"
    });
  }

  //Functions in creating and response to applications.
  /*
  Future<void> createApplications(String fromID, String toID, String teamID, String courseID) async{

    DocumentSnapshot fromRef = await _currentCourse.membersRef.document(fromID).get();
    DocumentSnapshot toRef = await _currentCourse.membersRef.document(toID).get();
    DocumentSnapshot teamRef = await _currentCourse.teamsRef.document(teamID).get();
    DocumentReference application = await _currentCourse.applicationRef.add({
      'from' : fromID,
      'to': toID,
      'status': "pending",
      'team': teamID,
      'fromName': fromRef.data["email"],
      'toName': toRef.data["email"],
      'teamName': teamRef.data["name"]
    });
    application.updateData({
      "id": application.documentID
    });
  }

  Future<void> acceptApplication(Notifi notification) async{
    DocumentReference from = _currentCourse.membersRef.document(notification.from);
    DocumentReference team = _currentCourse.teamsRef.document(notification.team);
    DocumentSnapshot teamSnapshot = await team.get();
    DocumentSnapshot fromSnapshot = await from.get();
    if(teamSnapshot.data["available_spots"] > 0 && fromSnapshot.data["team"] == null){
      DocumentReference note = _currentCourse.applicationRef.document(notification.id);
      note.updateData({
        "status": "accepted"
      });
      from.updateData({
        "team": notification.team
      });
      team.updateData({
        "available_spots": teamSnapshot.data["available_spots"] - 1
      });
    }
    else{
      print("error in adding applicant into team");
    }
  }

  Future<void> rejectApplication(Notifi notification) async{
    DocumentReference note = _currentCourse.applicationRef.document(notification.id);
    note.updateData({
      "status": "rejected"
    });
  }

  Future <void> createInvitations(String fromID, String toID, String teamID, String courseID) async{
    DocumentSnapshot fromRef = await _currentCourse.membersRef.document(fromID).get();
    DocumentSnapshot toRef = await _currentCourse.membersRef.document(toID).get();
    DocumentSnapshot teamRef = await _currentCourse.teamsRef.document(teamID).get();

    DocumentReference invitation = await _currentCourse.invitationRef.add({
      'from': fromID,
      'to': toID,
      'status': 'pending',
      'team': teamID,
      'fromName': fromRef.data["email"],
      'toName': toRef.data['email'],
      'teamName': teamRef.data["name"]
    });
    invitation.updateData({
      "id": invitation.documentID
    });
  }

  Future<void> acceptInvitation(Notifi notification) async{
    DocumentReference to = _currentCourse.membersRef.document(notification.to);
    DocumentReference team = _currentCourse.teamsRef.document(notification.from);
    DocumentSnapshot teamSnapshot = await team.get();
    DocumentSnapshot toSnapshot = await to.get();
    if(teamSnapshot.data["available_spots"] > 0 && toSnapshot.data["team"] == null){
      DocumentReference note = _currentCourse.invitationRef.document(notification.id);
      note.updateData({
        "status": "accepted"
      });
      to.updateData({
        "team": notification.team
      });
      team.updateData({
        "available_spots": teamSnapshot.data["available_spots"] - 1
      });
    }
    else{
      print("error in accepting invitaitons");
    }
  }

  Future<void> rejectInvitation(Notifi notification) async{
    DocumentReference note = _currentCourse.invitationRef.document(notification.id);
    note.updateData({
      "status": "rejected"
    });
  }
  */

}
