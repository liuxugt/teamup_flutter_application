import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/user_model.dart';

class LoginSignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginSignUpPageState();
}

enum FormMode { LOGIN, SIGNUP }

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _errorMessage = "";
  String _firstName;
  String _lastName;

  // Initial form is login form
  FormMode _formMode = FormMode.LOGIN;
  bool _isLoading = false;


  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }


  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        appBar: AppBar(
//          title: Text(_formMode == FormMode.LOGIN ? 'Login' : 'Sign Up')
//        ),
        body: _showBody()
    );
  }




  Widget _showBody() {
    return Center(
//        padding: EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(24.0),
          child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
//            mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _showLogo(),
                _showNameInput(),
                _showEmailInput(),
                _showPasswordInput(),
                _showPrimaryButton(),
                _showSecondaryButton(),
                _showErrorMessage(),
              ],
            ),
          ),
        ));
  }


  Widget _showLogo(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 48),
      child: Center(child: Image.asset('assets/logo.png', height: 80, width: 80,)),
    );
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 16.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return Container(
        height: 0.0,
      );
    }
  }

  Widget _showNameInput() {
    if (_formMode == FormMode.SIGNUP) {
      return Row(
        children: <Widget>[
          Flexible(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
                  child: TextFormField(
                    maxLines: 1,
                    decoration: InputDecoration(hintText: 'First Name'),
                    validator: (value) =>
                        value.isEmpty ? 'Can\'t be empty' : null,
                    onSaved: (value) => _firstName = value,
                  ))),
          Flexible(
            child: TextFormField(
              maxLines: 1,
              decoration: InputDecoration(hintText: 'Last Name'),
              validator: (value) => value.isEmpty ? 'Can\'t be empty' : null,
              onSaved: (value) => _lastName = value,
            ),
          )
        ],
      );
    } else {
      return Container(
        height: 0.0,
      );
    }
  }

  Widget _showEmailInput() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'Email',
              icon: Icon(
                Icons.mail,
                color: Colors.grey,
              )),
          validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
          onSaved: (value) => _email = value,
        ));
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
            hintText: 'Password',
            icon: Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value,
      ),
    );
  }

  Widget _showSecondaryButton() {
    print('is loding is here: ${_isLoading.toString()}');
    if(_isLoading) return Center(child: CircularProgressIndicator());
    return FlatButton(
      child: _formMode == FormMode.LOGIN
          ? Text('Create an account',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300))
          : Text('Have an account? Sign in',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
      onPressed: _formMode == FormMode.LOGIN
          ? _changeFormToSignUp
          : _changeFormToLogin,
    );
  }

  _showSuccessfulRegistration(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Signup Successful'),
            content: Text(
                'Your account has been successfully created, you may now login'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  setState(() {
                    _formMode = FormMode.LOGIN;
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Okay'),
              )
            ],
          );
        });
  }

  Widget _showPrimaryButton() {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: RaisedButton(
            color: Color.fromRGBO(90, 133, 236, 1.0),
            onPressed: _onPrimaryButtonPressed,
            child: _formMode == FormMode.LOGIN
                ? Text('Login',
                    style: TextStyle(fontSize: 20.0, color: Colors.white))
                : Text('Create account',
                    style: TextStyle(fontSize: 20.0, color: Colors.white)),
          ),
        ),
      );
  }

  _onPrimaryButtonPressed() async {
    if(_validateAndSave()) {
      setState(() {
        _isLoading = true;
      });
      if (_formMode == FormMode.LOGIN) {
       if(await ScopedModel.of<UserModel>(context, rebuildOnChange: false).signInUser(_email, _password)){
         if(ScopedModel.of<UserModel>(context, rebuildOnChange: false).currentUser.onboardComplete){
           Navigator.pushReplacementNamed(context, '/home');
         }else{
           Navigator.pushReplacementNamed(context, '/onboarding');
         }
       }
      } else {
        if(await ScopedModel.of<UserModel>(context, rebuildOnChange: false).registerUser(_email, _password, _firstName, _lastName)){
          _showSuccessfulRegistration();
        }

      }
      setState(() {
        _isLoading = false;
        _errorMessage = ScopedModel.of<UserModel>(context, rebuildOnChange: true).error;
      });
    }else{
      setState(() {
        _errorMessage = "";
      });
    }
  }


}
