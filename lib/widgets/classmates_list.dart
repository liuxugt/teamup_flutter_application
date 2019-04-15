import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/pages/profile_page.dart';
import 'package:teamup_app/objects/user.dart';

class ClassmatesList extends StatelessWidget {
  Widget _makeClassmateCard(User user, BuildContext context) {
//    return Card(
//      elevation: 1.0,
//      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//      child: Container(
//        decoration: BoxDecoration(color: Color.fromRGBO(220, 220, 220, .5)),
//        child:
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.photoURL),
          radius: 24.0,
        ),
        title: Text('${user.firstName} ${user.lastName}',
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(user.subtitle),
        trailing: Container(
            width: 96.0,
            child: Center(child: user.inTeamForCourse(
                ScopedModel.of<UserModel>(context, rebuildOnChange: false)
                    .currentCourse
                    .id)
                ? Text("TEAMED", style: TextStyle(color: Color.fromRGBO(161, 166, 187, 1.0)),)
                : Text("AVAILABLE", style: TextStyle(color: Color.fromRGBO(90, 133, 236, 1.0)),)
              //Icon(Icons.brightness_1, color: Color.fromRGBO(90, 133, 236, 1.0), size: 22.0,)
     ,)
       ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    user: user,
                  )));
        });
//      ),
//    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      //print("in classmateList");
      //print(model.currentCourse.name);
      if (!model.hasCourse) return Center(child: Text('No Courses'));

      return StreamBuilder<QuerySnapshot>(
          stream: model.getClassMates(),
          builder: (context, snapshot) {
//            List<Widget> children = [
////              const Padding(
////                padding: EdgeInsets.all(20.0),
////                child: Text(
////                  "A",
////                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
////                ),
////              )
//            ];
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
