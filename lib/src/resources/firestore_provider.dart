import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseProvider {
  Firestore _firestore = Firestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<int> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    DocumentSnapshot userSnap =
        await _firestore.collection('users').document(user.uid).get();

    return (userSnap != null && userSnap.data != null) ? 1 : 0;
  }

  Future<void> registerUser(
      String email, String password, String firstName, String lastName) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    return _firestore.collection('users').document(user.uid).setData({
      'email': email,
      'uid': user.uid.toString(),
      'first_name': firstName,
      'last_name': lastName
    });
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }


  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }



  Future<void> uploadGoal(String title, String documentId, String goal) async {
    DocumentSnapshot doc =
        await _firestore.collection("users").document(documentId).get();
    Map<String, String> goals = doc.data["goals"] != null
        ? doc.data["goals"].cast<String, String>()
        : null;
    if (goals != null) {
      goals[title] = goal;
    } else {
      goals = Map();
      goals[title] = goal;
    }
    return _firestore
        .collection("users")
        .document(documentId)
        .setData({'goals': goals, 'goalAdded': true}, merge: true);
  }

  Stream<DocumentSnapshot> myGoalList(String documentId) {
    return _firestore.collection("users").document(documentId).snapshots();
  }

  Stream<QuerySnapshot> othersGoalList() {
    return _firestore
        .collection("users")
        .where('goalAdded', isEqualTo: true)
        .snapshots();
  }

  void removeGoal(String title, String documentId) async {
    DocumentSnapshot doc =
        await _firestore.collection("users").document(documentId).get();
    Map<String, String> goals = doc.data["goals"].cast<String, String>();
    goals.remove(title);
    if (goals.isNotEmpty) {
      _firestore
          .collection("users")
          .document(documentId)
          .updateData({"goals": goals});
    } else {
      _firestore
          .collection("users")
          .document(documentId)
          .updateData({'goals': FieldValue.delete(), 'goalAdded': false});
    }
  }
}
