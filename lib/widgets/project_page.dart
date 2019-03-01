import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ProjectPage extends StatefulWidget{
  ProjectPage({this.db, this.projectSnap});

  final Firestore db;
  final DocumentSnapshot projectSnap;


  @override
  State<StatefulWidget> createState() => new _ProjectPageState();

}

class _ProjectPageState extends State<ProjectPage>{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(widget.projectSnap.toString()),
    );
  }

}