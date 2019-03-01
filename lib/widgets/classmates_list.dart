import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ClassmatesList extends StatefulWidget{

  ClassmatesList({this.courseRef, this.db});

  final DocumentReference courseRef;
  final Firestore db;

  @override
  State<StatefulWidget> createState() => new _ClassmatesListState();



}

class _ClassmatesListState extends State<ClassmatesList>{
  
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: widget.courseRef.collection('members').snapshots(),
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
                    onTap: (){},
                  );
                }).toList(),
              );
          }
        }
    );
  }

}

