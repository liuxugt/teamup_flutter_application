import 'package:flutter/material.dart';
import 'login_bloc_old.dart';
export 'login_bloc_old.dart';
class LoginBlocProvider extends InheritedWidget{
  final bloc = LoginBloc();
  LoginBlocProvider({Key key, Widget child}) : super(key: key, child: child);


  static LoginBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(LoginBlocProvider) as LoginBlocProvider).bloc;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}