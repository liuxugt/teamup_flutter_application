import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/pages/team_page.dart';
import 'package:teamup_app/models/user_model.dart';


class NotificationList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _NotificationListState();

}

class _NotificationListState extends State<NotificationList>{
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.green
    );
  }

}