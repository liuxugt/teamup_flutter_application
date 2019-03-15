
class CourseUser {
  String _firstName;
  String _lastName;
  String _email;
  bool _isAvailable;
  String teamId;



  CourseUser.fromSnapshotData(Map<String, dynamic> data){
    _firstName = data['first_name'];
    _lastName = data['last_name'];
    _email = data['email'];
    _isAvailable = data['is_available'];
    teamId = data['team'];


  }

  String get firstName => _firstName;

  bool get isAvailable => _isAvailable;

  String get email => _email;

  String get lastName => _lastName;



}