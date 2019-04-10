import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/objects/course.dart';

class SelectCoursePage extends StatelessWidget {
  _showConfirmDialog(Course course, BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirm Joining Course ${course.id}"),
            content: Text(
                "Are you sure you would like to register for ${course.id}: ${course.name}?"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              FlatButton(
                onPressed: () {
                  ScopedModel.of<UserModel>(context, rebuildOnChange: true).joinCourse(course);
                  Navigator.of(context).pop();
                },
                child: Text('Yes'),
              ),
            ],
          );
        });
  }

  Widget _makeCourseCard(Course course, BuildContext context) {
    return Card(
      elevation: 0.0,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(220, 220, 220, .5)),
        child: ListTile(
            title:
                Text(course.id, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(course.name),
            onTap: () => _showConfirmDialog(course, context)),
      ),
    );
  }

  Widget _makeJoinsedCourseCard(Course course, BuildContext context) {
    return Card(
      elevation: 0.0,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(220, 220, 220, .5)),
        child: ListTile(
            title:
            Text("${course.id} (Joined)", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(course.name),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Join Course"),),
      body: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        return StreamBuilder<QuerySnapshot>(
            stream: model.getCourses(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Text('Error: %{snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  return ListView(
                      children: snapshot.data.documents.map((document) {
                        if(document?.data != null){
                          Course course = Course.fromSnapshot(document);

                          return (model.currentUser.courseIds.contains(course.id)) ?
                              _makeJoinsedCourseCard(course, context)
                              : _makeCourseCard(course, context);
                        }
                        return Container();


//                    return (document?.data != null)
//                        ? _makeCourseCard(Course.fromSnapshot(document), context)
//                        : Container();
                  }).toList());
              }
            });
      }),
    );
  }
}
