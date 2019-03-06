import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamup_app/models/course.dart';
import 'user.dart';

class HomeModel extends Model {
  final Firestore _firestore = Firestore.instance;

  final User _currentUser;
  Course _currentCourse;
  String _currentCourseId = "";
  bool _isCourseLoading = true;
//  String _error = "";
  bool _hasCourse = false;

  HomeModel(this._currentUser){
//    _currentUser = user;
    loadData();
  }


  void loadData() async {
    print('Course Load Data Called');
    print('Current user is ${_currentUser.firstName}');
    print('Current user\'s courses are ${_currentUser.courseIds}');
    if (_currentUser.courseIds.isNotEmpty) {
      // TODO: make the user's courses be an array of IDs
      String courseId = _currentUser.courseIds.first;
      // TODO: make this use the ID of the course rather than a reference
//      DocumentSnapshot courseSnap = await _currentUser.courseIds.first.ref.get();
      DocumentSnapshot courseSnap = await _firestore.document('/courses/$courseId').get();
      if (courseSnap != null && courseSnap.data != null) {
        _currentCourseId = courseId;
        _hasCourse = true;
        _currentCourse = Course.fromSnapshot(courseSnap);
      }
    }
    _isCourseLoading = false;
    notifyListeners();
  }


  void changeCourse(String courseId) async {
    DocumentSnapshot courseSnap = await _firestore.document('/courses/$courseId').get();
    if (courseSnap != null && courseSnap.data != null) {
      _currentCourseId = courseId;
      _currentCourse = Course.fromSnapshot(courseSnap);
    }
    notifyListeners();
  }




  //Getters
  User get currentUser => _currentUser;
  Course get currentCourse => _currentCourse;
  bool get isCourseLoading => _isCourseLoading;
  String get currentCourseId => _currentCourseId;
  bool get hasCourse => _hasCourse;
}
