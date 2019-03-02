import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ProjectPage extends StatefulWidget {
  final DocumentSnapshot projectSnap;

  ProjectPage({this.projectSnap});

  @override
  State<StatefulWidget> createState() => new _ProjectPageState();
}


class _ProjectPageState extends State<ProjectPage>{


  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: Text(widget.projectSnap.data['name'].toString()),
      ),
      body: Center(
        child: Text(widget.projectSnap.data.toString()),
      ),
    );
  }

}