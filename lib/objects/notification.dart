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

  Notifi.fromSnapshot(DocumentSnapshot notification){
    Map<String, dynamic> data = notification.data;
    this._fromId = data['from'];
    this._toId = data["to"];
    this._status = data["status"];
    this._team = data["team"];
    this._teamName = data["team_name"];
    this._fromName = data["from_name"];
    this._toName = data["to_name"];
  }
  Notifi.fromSnapshotData(Map<String, dynamic> data){
    this._fromId = data['from'];
    this._toId = data["to"];
    this._status = data["status"];
    this._team = data["team"];
    this._teamName = data["team_name"];
    this._fromName = data["from_name"];
    this._toName = data["to_name"];
  }

  String get from => _fromId;
  String get to => _toId;
  String get status => _status;
  String get team => _team;
  String get fromName => _fromName;
  String get toName => _toName;
  String get teamName => _teamName;

}