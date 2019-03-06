import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/user.dart';


class UserModel extends Model{
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;



  bool _isAppLoading = true;
  bool get isAppLoading => _isAppLoading;

  User _currentUser;
  User get currentUser => _currentUser;

  String _error = "";
  String get error => _error;


  UserModel(){
    print("User Model Initialized");
//    loadCurrentUser();
  }


  Future<bool> loadCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if(user != null && user.uid.length > 0){
      DocumentSnapshot userSnap = await _firestore.document('/users/${user.uid}').get();
      if(userSnap != null && userSnap.data != null){
        _currentUser = User.fromSnapshotData(userSnap.data);
        return true;
      }
    }
    return false;
  }


  // TODO: implement error catching that notifies error message listener in login/signup page

  Future<bool> signInUser(String email, String password) async {
    try {
      FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      DocumentSnapshot userSnap = await _firestore.document('/users/${user.uid}').get();
      if (userSnap != null && userSnap.data != null) {
        _currentUser = User.fromSnapshotData(userSnap.data);
        return true;
      }
    }
    catch(error){
      print(error.toString());
      _error = error.toString();
    }
    return false;
  }

  Future<bool> registerUser(
      String email, String password, String firstName, String lastName) async {
    try {
      FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      await _firestore.collection('users').document(user.uid).setData({
        'email': email,
        'uid': user.uid.toString(),
        'first_name': firstName,
        'last_name': lastName,
        'courses': []
      });
      return true;

    }catch(error){
      print(error.toString());
    }
    return false;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    return;
  }


}