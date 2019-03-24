import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Notifi{
  String _fromId;
  String _toId;
  String _status;
  String _team;
  String _fromName;
  String _toName;
  String _teamName;
  String _id;

  Notifi.fromSnapshot(DocumentSnapshot notification){
    Map<String, dynamic> data = notification.data;
    this._fromId = data['from'];
    this._toId = data["to"];
    this._status = data["status"];
    this._team = data["team"];
    this._teamName = data["teamName"];
    this._fromName = data["fromName"];
    this._toName = data["toName"];
    this._id = data["id"];
  }
  Notifi.fromSnapshotData(Map<String, dynamic> data){
    this._fromId = data['from'];
    this._toId = data["to"];
    this._status = data["status"];
    this._team = data["team"];
    this._teamName = data["teamName"];
    this._fromName = data["fromName"];
    this._toName = data["toName"];
    this._id = data["id"];
  }

  String get from => _fromId;
  String get to => _toId;
  String get status => _status;
  String get team => _team;
  String get fromName => _fromName;
  String get toName => _toName;
  String get teamName => _teamName;
  String get id => _id;

}