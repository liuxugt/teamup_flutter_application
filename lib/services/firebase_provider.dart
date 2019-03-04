import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseProvider {
  Firestore _firestore = Firestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<DocumentSnapshot> signIn(String email, String password) async {

    // First try to sign in user with authentication
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);


    DocumentSnapshot userSnap;
    //if authentication provides a user with a uid, then fetch the association from firestore
    if(user != null && user.uid.length > 0){
      userSnap = await _firestore.collection('users').document(user.uid).get();
    }else{
      return null;
    }
    //if authenticated and firestore data, return the user snapshot
    return (userSnap != null && userSnap.data != null) ? userSnap : null;

  }

  Future<void> registerUser(
      String email, String password, String firstName, String lastName) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    return _firestore.collection('users').document(user.uid).setData({
      'email': email,
      'uid': user.uid.toString(),
      'first_name': firstName,
      'last_name': lastName,
      'courses': []
    });
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }


  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }




}
