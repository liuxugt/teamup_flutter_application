import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teamup_app/models/course.dart';
import 'user.dart';

class HomeModel extends Model {
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User _currentUser;
  Course _currentCourse;
  String _courseId = "No Courses";
  bool _isHomeLoading = true;
//  String _error = "";
  int _pageIndex = 0;
  bool _hasCourse = false;

  HomeModel(User user) {
    _currentUser = user;
    loadData();
  }

  Stream<QuerySnapshot> _projectsStream;
  Stream<QuerySnapshot> _classmatesStream;

  void loadData() async {
    print('Home Load Data Called');
    if (_currentUser.courses.isNotEmpty) {
      // TODO: make the user's courses be an array of IDs
      String courseId = _currentUser.courses.first.name;
      // TODO: make this use the ID of the course rather than a reference
      DocumentSnapshot courseSnap = await _currentUser.courses.first.ref.get();
      if (courseSnap != null && courseSnap.data != null) {
        _courseId = courseId;
        _hasCourse = true;
        _currentCourse = Course.fromSnapshot(courseSnap);
      }
    }
    _isHomeLoading = false;
    notifyListeners();
  }

  void changePage(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  //Getters
  User get currentUser => _currentUser;
  Course get currentCourse => _currentCourse;
  bool get isHomeLoading => _isHomeLoading;
  String get courseId => _courseId;
  Stream<QuerySnapshot> get classmatesStream => _classmatesStream;
  Stream<QuerySnapshot> get projectsStream => _projectsStream;
  int get pageIndex => _pageIndex;
  bool get hasCourse => _hasCourse;
}
