import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/pages/profile_page.dart';
import 'package:teamup_app/objects/user.dart';

class ClassmatesList extends StatelessWidget {


  Widget _makeClassmateCard(User user, BuildContext context) {
    return Card(
      elevation: 1.0,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(220, 220, 220, .5)),
        child: ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(user.photoURL)),
            title: Text('${user.firstName} ${user.lastName}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(user.email),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(user: user,)));
            }
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      print("in classmateList");
      print(model.currentCourse.name);
      if (!model.hasCourse) return Center(child: Text('No Courses'));

      return StreamBuilder<QuerySnapshot>(
          stream: model.getClassMates(),
          builder: (context, snapshot) {
            //print(snapshot.data.documents);
            if (snapshot.hasError) return Text('Error: %{snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                return ListView(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return (document?.data != null)
                        ? _makeClassmateCard(
                            User.fromSnapshotData(document.data), context)
                        : Container(
                            height: 0.0,
                          );
                  }).toList(),
                );
            }
          });
    });
  }
}
