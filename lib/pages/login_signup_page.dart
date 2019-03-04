import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/auth.dart';

class LoginSignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginSignUpPageState();
}

enum FormMode { LOGIN, SIGNUP }

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  final _formKey = new GlobalKey<FormState>();
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
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Login & Signup'),
        ),
        body: Center(child: _showBody()));
  }


  Widget _showBody() {
    return new Container(
        padding: EdgeInsets.all(24.0),
        child: new Form(
          key: _formKey,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _showNameInput(),
              _showEmailInput(),
              _showPasswordInput(),
              _showPrimaryButton(),
              _showSecondaryButton(),
              _showErrorMessage(),
            ],
          ),
        ));
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 16.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _showNameInput() {
    if (_formMode == FormMode.SIGNUP) {
      return new Row(
        children: <Widget>[
          new Flexible(
              child: new Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
                  child: new TextFormField(
                    maxLines: 1,
                    decoration: new InputDecoration(hintText: 'First Name'),
                    validator: (value) =>
                        value.isEmpty ? 'Can\'t be empty' : null,
                    onSaved: (value) => _firstName = value,
                  ))),
          new Flexible(
            child: new TextFormField(
              maxLines: 1,
              decoration: new InputDecoration(hintText: 'Last Name'),
              validator: (value) => value.isEmpty ? 'Can\'t be empty' : null,
              onSaved: (value) => _lastName = value,
            ),
          )
        ],
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _showEmailInput() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: new InputDecoration(
              hintText: 'Email',
              icon: new Icon(
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
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value,
      ),
    );
  }

  Widget _showSecondaryButton() {
    return new FlatButton(
      child: _formMode == FormMode.LOGIN
          ? new Text('Create an account',
              style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300))
          : new Text('Have an account? Sign in',
              style:
                  new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
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
            title: new Text('Signup Successful'),
            content: new Text(
                'Your account has been successfully created, you may now login'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text('Okay'),
              )
            ],
          );
        });
  }

  Widget _showPrimaryButton() {
    return ScopedModelDescendant<Auth>(builder: (context, child, auth) {
      return RaisedButton(
        color: Colors.blue,
        onPressed: () async {
          setState(() {
            _isLoading = true;
          });
          if(_validateAndSave()) {
            if (_formMode == FormMode.LOGIN) {
              auth.signInUser(_email, _password);
            } else {
              await auth.registerUser(_email, _password, _firstName, _lastName);
              _showSuccessfulRegistration();
            }
          }
          setState(() {
            _isLoading = false;
          });
        },
        child: _isLoading ?
            new CircularProgressIndicator(
              backgroundColor: Colors.white,
            )
            : _formMode == FormMode.LOGIN
            ? new Text('Login',
                style: new TextStyle(fontSize: 20.0, color: Colors.white))
            : new Text('Create account',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
      );
    });
  }
}
