import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firestore_provider.dart';

class Repository {
  final _firebaseProvider = FirebaseProvider();

  Future<int> signIn(String email, String password) =>
      _firebaseProvider.signIn(email, password);

  Future<void> registerUser(
          String email, String password, String firstName, String lastName) =>
      _firebaseProvider.registerUser(email, password, firstName, lastName);

  Future<FirebaseUser> getCurrentUser() => _firebaseProvider.getCurrentUser();


}
