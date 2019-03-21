import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Notification{
  String _fromId;
  String _toId;
  String _status;
  String _team;

  Notification.fromSnapshot(DocumentSnapshot notification){
    Map<String, dynamic> data = notification.data;
    this._fromId = data['from'];
    this._toId = data["to"];
    this._status = data["status"];
    this._team = data["team"];
  }
  Notification.fromSnapshotData(Map<String, dynamic> data){
    this._fromId = data['from'];
    this._toId = data["to"];
    this._status = data["status"];
    this._team = data["team"];
  }

  String get from => _fromId;
  String get to => _toId;
  String get status => _status;
  String get team => _team;

}