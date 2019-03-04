import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/home_model.dart';
import 'package:teamup_app/widgets/project_page.dart';


class ProjectsList extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
        stream: ScopedModel.of<HomeModel>(context, rebuildOnChange: false).projectsStream,
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
                    leading: document['is_available'] ? Icon(Icons.brightness_1, color: Colors.green,) : Icon(Icons.brightness_1, color: Colors.red),
                    title: new Text(document['name']),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectPage()));
                    },
                  );
                }).toList(),
              );
          }
        }
    );
  }

}

