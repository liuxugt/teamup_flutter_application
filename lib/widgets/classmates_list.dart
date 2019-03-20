import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/course_member.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/pages/profile_page.dart';

class ClassmatesList extends StatelessWidget {
  Widget _makeClassmateCard(CourseMember member, BuildContext context) {
    return Card(
      elevation: 1.0,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(220, 220, 220, .5)),
        child: ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(member.photoURL)),
            title: Text('${member.firstName} ${member.lastName}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(member.headline),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(member: member)));
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      if (!model.hasCourse) return Center(child: Text('No Courses'));

      return StreamBuilder<QuerySnapshot>(
          stream: model.currentCourse.availableMembersStream,
          builder: (context, snapshot) {
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
                            CourseMember.fromSnapshot(document), context)
                        : Container(
                            height: 0.0,
                          );
//                    return ListTile(
//                      leading: document.data['is_available']
//                          ? Icon(
//                              Icons.brightness_1,
//                              color: Colors.green,
//                            )
//                          : Icon(Icons.brightness_1, color: Colors.red),
//                      title: Text(
//                          '${document.data['first_name']} ${document.data['last_name']}'),
//                      onTap: () {
//                        Navigator.of(context).push(MaterialPageRoute(
//                            builder: (context) => ProfilePage()));
//                      },
//                    );
                  }).toList(),
                );
            }
          });
    });
  }
}
