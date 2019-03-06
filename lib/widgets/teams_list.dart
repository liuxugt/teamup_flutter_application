import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/pages/team_page.dart';

class TeamsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {

      if (!model.hasCourse) return Center(child: Text('No Courses'));

      return StreamBuilder<QuerySnapshot>(
          stream: model.currentCourse.teamsRef.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text('Error: %{snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                return ListView(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return new ListTile(
                        leading: document['is_full']
                            ? Icon(
                                Icons.brightness_1,
                                color: Colors.green,
                              )
                            : Icon(Icons.brightness_1, color: Colors.red),
                        title: new Text(document['name']),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TeamPage(teamId: document.documentID)));
                        });
                  }).toList(),
                );
            }
          });
    });
  }
}
