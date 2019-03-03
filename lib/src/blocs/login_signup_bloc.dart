import 'package:teamup_app/src/resources/repository.dart';
import 'package:teamup_app/src/ui/widgets/bloc_provider.dart';

class LoginSignupBloc implements BlocBase{
  final _repository = Repository();
  String _email;
  String _password;


  @override
  void dispose() {
    // TODO: implement dispose
  }

}