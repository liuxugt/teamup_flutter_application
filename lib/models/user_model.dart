import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/Course.dart';
import 'package:teamup_app/models/user.dart';


class UserModel extends Model{
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User _currentUser;
  Course _currentCourse;
  String _currentCourseId = "";
  bool _hasCourse = false;
  bool _isAppLoading = true;



  Course get currentCourse => _currentCourse;
  String get currentCourseId => _currentCourseId;
  bool get hasCourse => _hasCourse;
  bool get isAppLoading => _isAppLoading;
  User get currentUser => _currentUser;


  String _error = "";
  String get error => _error;


  UserModel(){
    print("User Model Initialized");
  }


  Future<bool> loadCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if(user != null && user.uid.length > 0){
      DocumentSnapshot userSnap = await _firestore.document('/users/${user.uid}').get();
      if(userSnap != null && userSnap.data != null){
        _currentUser = User.fromSnapshotData(userSnap.data);
        await _loadCourse();
        return true;
      }
    }
    return false;
  }


  Future<void> _loadCourse() async {
    if (_currentUser.courseIds.isNotEmpty) {
      String courseId = _currentUser.courseIds.first;
      DocumentSnapshot courseSnap = await _firestore.document('/courses/$courseId').get();
      if (courseSnap != null && courseSnap.data != null) {
        _currentCourseId = courseId;
        _hasCourse = true;
        _currentCourse = Course.fromSnapshot(courseSnap);
      }
    }
  }
  
  // TODO: implement error catching that notifies error message listener in login/signup page

  Future<bool> signInUser(String email, String password) async {
    try {
      FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      DocumentSnapshot userSnap = await _firestore.document('/users/${user.uid}').get();
      if (userSnap != null && userSnap.data != null) {
        _currentUser = User.fromSnapshotData(userSnap.data);
        await _loadCourse();
        return true;
      }
    }
    catch(error){
      print(error.toString());
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

    }catch(error){
      print(error.toString());
    }
    return false;
  }



  void changeCourse(String courseId) async {
    DocumentSnapshot courseSnap = await _firestore.document('/courses/$courseId').get();
    if (courseSnap != null && courseSnap.data != null) {
      _currentCourseId = courseId;
      _currentCourse = Course.fromSnapshot(courseSnap);
    }
    notifyListeners();
  }



  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _currentCourse = null;
    _currentCourseId = null;
    _currentUser = null;
    _hasCourse = false;
    return;
  }


}