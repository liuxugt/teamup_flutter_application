import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Notifi{
  String _fromId;
  String _toId;
  String _status;
  String _team;
  String _fromFirst;
  String _fromLast;
  String _toFirst;
  String _toLast;
  String _teamName;
  String _id;
  String _type;
  //String[] relatedUser

  Notifi.fromSnapshot(DocumentSnapshot notification){
    Map<String, dynamic> data = notification.data;
    this._fromId = data['from'];
    this._toId = data["to"];
    this._status = data["status"];
    this._team = data["team"];
    this._teamName = data["team_name"];
    this._fromFirst = data["from_first"];
    this._fromLast = data["from_last"];
    this._toFirst = data["to_first"];
    this._toLast = data["to_last"];
    this._id = data["id"];
    this._type = data["type"];
  }
  Notifi.fromSnapshotData(Map<String, dynamic> data){
    this._fromId = data['from'];
    this._toId = data["to"];
    this._status = data["status"];
    this._team = data["team"];
    this._teamName = data["team_name"];
    this._fromFirst = data["from_first"];
    this._fromLast = data["from_last"];
    this._toFirst = data["to_first"];
    this._toLast = data["to_last"];
    this._id = data["id"];
    this._type = data["type"];
  }

  String get from => _fromId;
  String get to => _toId;
  String get status => _status;
  String get team => _team;
  String get fromFirst => _fromFirst;
  String get fromLast => _fromLast;
  String get toLast => _toLast;
  String get toFirst => _toFirst;
  String get teamName => _teamName;
  String get id => _id;
  String get type =>_type;
}