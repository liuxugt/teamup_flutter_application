import 'dart:async';
import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../utils/strings.dart';

class LoginBloc {
//  API Functions
  final _repository = Repository();
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _isSignedIn = BehaviorSubject<bool>();
  final _firstName = BehaviorSubject<String>();
  final _lastName = BehaviorSubject<String>();



//  streams
  Observable<String> get email => _email.stream.transform(_validateEmail);

  Observable<String> get password =>
      _password.stream.transform(_validatePassword);

  Observable<bool> get signInStatus => _isSignedIn.stream;

  String get emailAddress => _email.value;


//  sinks
  Function(String) get changeEmail => _email.sink.add;

  Function(String) get changePassword => _password.sink.add;

  Function(bool) get showProgressBar => _isSignedIn.sink.add;



  final _validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@')) {
      sink.add(email);
    } else {
      sink.addError(StringConstant.emailValidateMessage);
    }
  });

  final _validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 6) {
      sink.add(password);
    } else {
      sink.addError(StringConstant.passwordValidateMessage);
    }
  });

  Future<int> submit() {
    return _repository.signIn(_email.value, _password.value);
  }

  Future<void> registerUser() {
    return _repository.registerUser(
        _email.value, _password.value, _firstName.value, _lastName.value);
  }

  void dispose() async {
    await _email.drain();
    _email.close();
    await _password.drain();
    _password.close();
    await _isSignedIn.drain();
    _isSignedIn.close();
    await _firstName.drain();
    _firstName.close();
    await _lastName.drain();
    _lastName.close();
  }

  bool validateFields() {
    if (_email.value != null &&
        _email.value.isNotEmpty &&
        _password.value != null &&
        _password.value.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
