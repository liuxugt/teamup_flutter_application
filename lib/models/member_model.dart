import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/objects/course_member.dart';
import 'package:teamup_app/objects/user.dart';
import 'package:teamup_app/services/api.dart';

class MemberModel extends Model{

  User user;
  API api = API();

  final CourseMember member;
  MemberModel({this.member}){
    _loadUser();
  }

  Future<void> _loadUser() async {
    user = await api.getUser(member.id);
    notifyListeners();
  }


  bool get userLoaded => user != null;

}