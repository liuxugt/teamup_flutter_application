import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ProfilePage extends StatefulWidget {
  final DocumentReference profileRef;

  ProfilePage({this.profileRef});

  @override
  State<StatefulWidget> createState() => new _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage>{

  DocumentSnapshot _profileSnap;
  String _profileName = "";

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  _loadData() async {
    DocumentSnapshot snap = await widget.profileRef.get();
    setState(() {
      _profileSnap = snap;
      _profileName = '${snap.data['first_name']} ${snap.data['last_name']}';
    });

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(_profileName),
      ),
      body: Center(
        child: _profileSnap == null ? CircularProgressIndicator() : Text(_profileSnap.data.toString()),
      ),
    );
  }

}