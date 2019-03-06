
class User {
  String _firstName;
  String _lastName;
  String _email;
  List<String> _courseIds = [];
  String _uid;

  _printVariables(){
    print('first name: $_firstName');
    print('last name: $_lastName');
    print('email: $_email');
    print('courses : ${_courseIds.toString()}');
    print('uid: $_uid');
  }


  User.fromSnapshotData(Map<String, dynamic> data){
    _firstName = data['first_name'];
    _lastName = data['last_name'];
    _email = data['email'];
    _uid = data['uid'];
    if(data.containsKey('courses') && data['courses'] is List){
      List<String> temp = [];
      for(int i = 0; i < data['courses'].length; i++){
//        temp.add(new CourseCover(data['courses'][i]));
          temp.add(data['courses'][i]);
      }
      _courseIds = temp;
    }

//    _printVariables();
  }

  String get firstName => _firstName;

  String get id => _uid;

  List<String> get courseIds => _courseIds;

  String get email => _email;

  String get lastName => _lastName;


}

//class CourseCover {
//  String _name;
//  DocumentReference _ref;
//
//  CourseCover(Map<dynamic, dynamic> course){
//    _name = course['name'];
//    _ref = course['ref'];
//  }
//
//  String get name => _name;
//  DocumentReference get ref => _ref;
//
//}
