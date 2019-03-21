import 'package:cloud_firestore/cloud_firestore.dart';

class invitation{
  String _fromId;
  String _toId;
  String _status;

  invitation.fromSnapshot(DocumentSnapshot invitation){
    Map<String, dynamic> data = invitation.data;
    _fromId = data["from"];
    _toId  = data["to"];
    _status = data["status"];
  }
  invitation.fromSnapshotData(Map<String, dynamic> data){
    _fromId = data["from"];
    _toId = data["to"];
    _status = data["status"];
  }

  String get fromId => _fromId;
  String get toId => _toId;
  String get status => _status;
}