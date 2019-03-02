import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teamup_app/widgets/project_page.dart';


class ProjectsList extends StatefulWidget{
  ProjectsList({this.courseRef, this.db, this.userSnap});

  final DocumentReference courseRef;
  final Firestore db;
  final DocumentSnapshot userSnap;


  @override
  State<StatefulWidget> createState() => new _ProjectsListState();


}

class _ProjectsListState extends State<ProjectsList>{

  @override
  void initState() {
//    print('THIS: ${widget.courseRef.toString()}');
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    //bool is_available = _userSnap.data.containsKey('courses')
    return widget.courseRef == null ? CircularProgressIndicator() : StreamBuilder<QuerySnapshot>(
      stream: widget.courseRef.collection('projects').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasError)
          return new Text('Error: %{snapshot.error}');
        switch (snapshot.connectionState){
          case ConnectionState.waiting:
            return new Center(child: new CircularProgressIndicator());
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document){
                return new ListTile(
                  leading: document['is_full'] ? Icon(Icons.brightness_1, color: Colors.green,) : Icon(Icons.brightness_1, color: Colors.red),
                  title: new Text(document['name']),
                  subtitle: new Text(document['description']),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectPage(projectSnap: document, courseRef: widget.courseRef, userSnap: widget.userSnap)));
                  },
                );
              }).toList(),
            );
        }
    }
    );
  }

}