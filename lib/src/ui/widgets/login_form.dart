import '../../utils/strings.dart';
import 'package:flutter/material.dart';
import '../../blocs/login_bloc_provider.dart';

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  LoginBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = LoginBlocProvider.of(context);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        emailField(),
        Container(margin: const EdgeInsets.only(top: 5.0, bottom: 5.0)),
        passwordField(),
        Container(margin: const EdgeInsets.only(top: 5.0, bottom: 5.0)),
        submitButton()
      ],
    );
  }

  Widget passwordField() {
    return StreamBuilder(
        stream: _bloc.password,
        builder: (context, AsyncSnapshot<String> snapshot) {
          return TextField(
            onChanged: _bloc.changePassword,
            obscureText: true,
            decoration: InputDecoration(
                icon: Icon(Icons.lock),
                hintText: StringConstant.passwordHint,
                errorText: snapshot.error),
          );
        });
  }

  Widget emailField() {
    return StreamBuilder(
        stream: _bloc.email,
        builder: (context, snapshot) {
          return TextField(
            onChanged: _bloc.changeEmail,
            decoration: InputDecoration(
                icon: Icon(Icons.mail),
                hintText: StringConstant.emailHint,
                errorText: snapshot.error),
          );
        });
  }

  Widget submitButton() {
    return StreamBuilder(
        stream: _bloc.signInStatus,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return button();
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget button() {
    return RaisedButton(
        child: Text(StringConstant.submit),
        onPressed: () {
          if (_bloc.validateFields()) {
            authenticateUser();
          } else {
            showErrorMessage();
          }
        });
  }

  void authenticateUser() {
//    _bloc.showProgressBar(true);
//    _bloc.submit().then((value) {
//      if (value == 0) {
//        //New User
//        _bloc.registerUser().then((value) {
//          Navigator.pushReplacement(
//              context,
//              MaterialPageRoute(
//                  builder: (context) => GoalsList(_bloc.emailAddress)));
//        });
//      } else {
//        //Already registered
//        Navigator.pushReplacement(
//            context,
//            MaterialPageRoute(
//                builder: (context) => GoalsList(_bloc.emailAddress)));
//      }
//    });
  }

  void showErrorMessage() {
    final snackbar = SnackBar(
        content: Text(StringConstant.errorMessage),
        duration: new Duration(seconds: 2));
    Scaffold.of(context).showSnackBar(snackbar);
  }
}
