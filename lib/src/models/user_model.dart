import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String _firstName;
  String _lastName;
  String _email;
  List<CourseCover> _courses = [];
  String _uid;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    if(snapshot != null && snapshot.data != null){
      UserModel.fromSnapshotData(snapshot.data);
    }
  }

  UserModel.fromSnapshotData(Map<String, dynamic> data){
    _firstName = data['first_name'];
    _lastName = data['last_name'];
    _email = data['email'];
    _uid = data['uid'];
    if(data.containsKey('courses')){
      List<CourseCover> temp = [];
      for(int i = 0; i < data['courses'].length; i++){
        temp.add(new CourseCover(data['courses']));
      }
      _courses = temp;
    }
  }

  String get firstName => _firstName;

  String get uid => _uid;

  List<CourseCover> get courses => _courses;

  String get email => _email;

  String get lastName => _lastName;


}

class CourseCover {
  String _name;
  DocumentReference _ref;


  CourseCover(Map<String, dynamic> course){
    _name = course['name'];
    _ref = course['ref'];
  }

  String get name => _name;
  DocumentReference get ref => _ref;

}
