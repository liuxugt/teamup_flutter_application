import 'package:cloud_firestore/cloud_firestore.dart';

class Application{
  String _fromId;
  String _toId;
  String _status;
  String _teamId;

  Application.fromSnapshot(DocumentSnapshot application){
    Map<String, dynamic> data = application.data;
    this._fromId = data['from'];
    this._toId = data['to'];
    this._status = data['status'];
    this._teamId = data['team'];
  }

  Application.fromSnapshotData(Map<String, dynamic> data){
    this._fromId = data['from'];
    this._toId = data['to'];
    this._status = data['status'];
    this._teamId = data['team'];
  }

  String get fromId => _fromId;
  String get toId => _toId;
  String get Status => _status;
}