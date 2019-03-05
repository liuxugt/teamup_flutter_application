import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/course_model.dart';
import 'package:teamup_app/widgets/profile_page.dart';


class ClassmatesList extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
          stream: ScopedModel.of<CourseModel>(context, rebuildOnChange: false).currentCourse.membersRef.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasError)
              return Text('Error: %{snapshot.error}');
            switch (snapshot.connectionState){
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                return ListView(
                  children: snapshot.data.documents.map((DocumentSnapshot document){
                    return ListTile(
                      leading: document.data['is_available'] ? Icon(Icons.brightness_1, color: Colors.green,) : Icon(Icons.brightness_1, color: Colors.red),
                      title: Text('${document.data['first_name']} ${document.data['last_name']}'),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                      },
                    );
                  }).toList(),
                );
            }
          }
    );
  }

}

