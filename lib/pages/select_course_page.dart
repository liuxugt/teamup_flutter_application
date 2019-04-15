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
                onPressed: () async {
                  await ScopedModel.of<UserModel>(context, rebuildOnChange: true).joinCourse(course);
                  Navigator.of(context).popUntil(ModalRoute.withName('/home'));
                },
                child: Text('Yes'),
              ),
            ],
          );
        });
  }

  Widget _makeCourseCard(Course course, BuildContext context, {bool joined = false}) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromRGBO(90, 133, 236, 1), Color.fromRGBO(149, 138, 224, 1)])),
        child: ListTile(
            leading: Icon(Icons.bookmark_border,color: Colors.white,),
            title:
                Text(course.id, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            subtitle: Text(course.name, style: TextStyle(color: Colors.white),),
            trailing: (joined) ? Icon(Icons.done, color: Colors.white,): null,
            onTap: () => _showConfirmDialog(course, context)),
      ),
    );
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
                          return _makeCourseCard(course, context, joined: model.currentUser.courseIds.contains(course.id));
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
