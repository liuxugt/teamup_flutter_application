import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teamup_app/models/course.dart';
import 'user.dart';

class CourseModel extends Model {
  final Firestore _firestore = Firestore.instance;

  final User _currentUser;
  Course _currentCourse;
  String _currentCourseId = "No Courses";
  bool _isCourseLoading = true;
//  String _error = "";
  int _pageIndex = 0;
  bool _hasCourse = false;

  CourseModel(this._currentUser){
//    _currentUser = user;
    loadData();
  }


  void loadData() async {
    print('Course Load Data Called');
    if (_currentUser.courseIds.isNotEmpty) {
      // TODO: make the user's courses be an array of IDs
      String courseId = _currentUser.courseIds.first;
      // TODO: make this use the ID of the course rather than a reference
//      DocumentSnapshot courseSnap = await _currentUser.courseIds.first.ref.get();
      DocumentSnapshot courseSnap = await _firestore.document('/courses/${courseId}').get();
      if (courseSnap != null && courseSnap.data != null) {
        _currentCourseId = courseId;
        _hasCourse = true;
        _currentCourse = Course.fromSnapshot(courseSnap);
      }
    }
    _isCourseLoading = false;
    notifyListeners();
  }

  void changePage(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  //Getters
  User get currentUser => _currentUser;
  Course get currentCourse => _currentCourse;
  bool get isCourseLoading => _isCourseLoading;
  String get courseId => _currentCourseId;
  int get pageIndex => _pageIndex;
  bool get hasCourse => _hasCourse;
}
