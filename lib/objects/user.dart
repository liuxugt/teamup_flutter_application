
class User {
  String _firstName;
  String _lastName;
  String _email;
  List<String> _courseIds = [];
  String _uid;
  String _photoURL;
  bool onboardComplete;

//  _printVariables(){
//    print('first name: $_firstName');
//    print('last name: $_lastName');
//    print('email: $_email');
//    print('courses : ${_courseIds.toString()}');
//    print('uid: $_uid');
//  }


  User.fromSnapshotData(Map<String, dynamic> data){
    _firstName = data['first_name'];
    _lastName = data['last_name'];
    _email = data['email'];
    _uid = data['uid'];
    _photoURL = data['photo_url'];
    if(data.containsKey('courses') && data['courses'] is List){
      for(int i = 0; i < data['courses'].length; i++){
          _courseIds.add(data['courses'][i]);
      }
    }
    onboardComplete = data['onboard_complete'];
//    _printVariables();
  }

  String get firstName => _firstName;
  String get id => _uid;
  List<String> get courseIds => _courseIds;
  String get email => _email;
  String get lastName => _lastName;
  String get photoURL => _photoURL;


}