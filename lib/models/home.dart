import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user.dart';

class Home extends Model {
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //Instantiation
  String _courseId = "No Courses";
  User _user;
  bool _isHomeLoading = true;
  String _error = "";
  int _pageIndex = 0;
  bool _hasCourse = false;



  Stream<QuerySnapshot> _classmatesStream;

//
//  Home(){
//    print('Home Initialized');
//    loadData();
//  }




  void loadData() async {
    print('Home Load Data Called');
    _isHomeLoading = true;
    notifyListeners();
    FirebaseUser user = await _firebaseAuth.currentUser();
    if(user != null && user.uid.length > 0){
      DocumentSnapshot userSnap = await _firestore.document('/users/${user.uid}').get();
      _user = User.fromSnapshotData(userSnap?.data);
      print('User ${_user.firstName} loaded');
      if(_user.courses.isNotEmpty) {
        _hasCourse = true;
        _courseId = _user.courses[0].name;
        _classmatesStream = _user.courses[0].ref.collection('members').snapshots();
      }
    }else{
      _error = "No User Logged In";
    }
    _isHomeLoading = false;
    notifyListeners();
  }



  void changePage(int index){
    _pageIndex = index;
    notifyListeners();
  }


  //Getters
  User get user => _user;
  bool get isHomeLoading => _isHomeLoading;
  String get courseId => _courseId;
  Stream<QuerySnapshot> get classmatesStream => _classmatesStream;
  int get pageIndex => _pageIndex;
  bool get hasCourse => _hasCourse;



}