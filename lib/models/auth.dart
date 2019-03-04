import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';


class Auth extends Model{
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool _isSignedIn;
  bool get isSignedIn => _isSignedIn;

  bool _isAppLoading = true;
  bool get isAppLoading => _isAppLoading;


  Auth(){
    print("Auth Initialized");
    loadCurrentUser();
  }


  void loadCurrentUser() async {
    _isAppLoading = true;
    notifyListeners();
    FirebaseUser user = await _firebaseAuth.currentUser();

    _isAppLoading = false;
    _isSignedIn = (user != null && user.uid.length > 0) ? true : false;
    notifyListeners();
  }


  // TODO: implement error catching that notifies error message listener in login/signup page

  void signInUser(String email, String password) async {
    try {
      FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      DocumentSnapshot userSnap = await _firestore.collection('users').document(
          user?.uid).get();

      if (userSnap != null && userSnap.exists) {
        _isSignedIn = true;
      } else {
        _isSignedIn = false;
      }
      notifyListeners();
    }
    catch(error){
      print(error.toString());
    }
  }

  Future<void> registerUser(
      String email, String password, String firstName, String lastName) async {

    try {
      FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      _firestore.collection('users').document(user.uid).setData({
        'email': email,
        'uid': user.uid.toString(),
        'first_name': firstName,
        'last_name': lastName,
        'courses': []
      });
    }catch(error){
      print(error.toString());
    }

  }

  void signOut() async {
    await _firebaseAuth.signOut();
    _isSignedIn = false;
    notifyListeners();
  }


}