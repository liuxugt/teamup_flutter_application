
class User {
  String _firstName;
  String _lastName;
  String _email;
  List<String> _courseIds = [];
  List<String> _teamIds = [];
  Map<String, dynamic> _courseTeam = {};

  String _uid;
  String _photoURL;
  bool onboardComplete;

  List<String> _languages = [];
  DateTime _birthdate;
  String _gender;
  String _headline;
  String _skills;
  String _strengths;
  List<bool> _unavailable = [];
  String _major = '';
  String _yearOfStudy = '';


//  _printVariables(){
//    print('first name: $_firstName');
//    print('last name: $_lastName');
//    print('email: $_email');
//    print('courses : ${_courseIds.toString()}');
//    print('uid: $_uid');
//  }
  //check if user is in a team for this course
  bool inTeamForCourse(String courseId){
    if(_courseTeam[courseId] == null){
      return false;
    }else{
      return true;
    }
  }



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
    if(data.containsKey('teams') && data['teams'] is List){
      for(int i = 0; i < data['teams'].length; i++){
        _teamIds.add(data['teams'][i]);
        print('in loading process');
        print(data['teams'][i]);
      }
    }
    if(data.containsKey('course_team') && data['course_team'] is Map){
      data['course_team'].forEach((key,value) =>
        _courseTeam[key] = value
      );
    }

    if (data.containsKey('attributes')) {
      if (data['attributes']['skills'] is String)
        _skills = data['attributes']['skills'];

      if (data['attributes']['headline'] is String)
        _headline = data['attributes']['headline'];

      if (data['attributes']['strengths'] is String)
        _strengths = data['attributes']['strengths'];

      if (data['attributes']['year_of_study'] is String)
        _yearOfStudy = data['attributes']['year_of_study'];

      if (data['attributes']['major'] is String)
        _major = data['attributes']['major'];


      if (data['attributes']['languages'] is List && data['attributes']['languages'].length > 0)
        for (int i = 0; i < data['attributes']['languages'].length; i++) {
          _languages.add(data['attributes']['languages'][i]);
        }
    }





    onboardComplete = data['onboard_complete'];
//    _birthdate = data['attributes']['birthdate'];
  }


  String get firstName => _firstName;
  String get id => _uid;
  List<String> get courseIds => _courseIds;
  List<String> get teamIds => _teamIds;
  Map get courseTeam => _courseTeam;
  String get email => _email;
  String get lastName => _lastName;
  String get photoURL => _photoURL;


  String get major => _major;
  String get yearOfStudy => _yearOfStudy;
  String get skills => _skills;
  String get gender => _gender;
  String get headline => _headline;
  DateTime get birthdate => _birthdate;
  String get strengths => _strengths;
  List<String> get languages => _languages;

  List<bool> get unavailable => _unavailable;

  set setSkills(String skill) => _skills = skill;
  set setHeadline(String headline) => _headline = headline;
  set setStrengths(String strength) => _strengths = strength;
  set setPhoto(String photoURL) => _photoURL = photoURL;

  String get subtitle => (_headline != null && _headline.isNotEmpty) ? _headline :_email;

  String get profilePageSubtitle {
    String returnString = '';
    if(_headline != null && _headline.isNotEmpty){
      returnString += _headline;
    }
    if(_yearOfStudy != null && _yearOfStudy.isNotEmpty){
      returnString += ', $_yearOfStudy';
    }
    if(_major != null && _major.isNotEmpty){
      returnString += ', ' + _major;
    }
    return returnString;
  }

}