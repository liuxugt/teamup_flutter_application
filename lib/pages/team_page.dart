import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/home_model.dart';


class TeamPage extends StatelessWidget {

//
//  _onFloatingButtonPressed(){
//
//    Map<String, dynamic> data = {
//      'name': widget.userSnap.data['first_name'] + ' ' + widget.userSnap.data['last_name'],
//      'ref' : widget.userSnap.reference
//    };
//    widget.projectSnap.reference.collection('members').add(data);
//  }
//
//
//  _buildMemberList(){
//    return StreamBuilder<QuerySnapshot>(
//        stream: ,
//        builder: (BuildContext context,
//            AsyncSnapshot<QuerySnapshot> snapshot) {
//          if (snapshot.hasError)
//            return new Text('Error: %{snapshot.error}');
//          switch (snapshot.connectionState) {
//            case ConnectionState.waiting:
//              return new Center(child: new CircularProgressIndicator());
//            default:
//              return new ListView(
//                children: snapshot.data.documents
//                    .map((DocumentSnapshot document) {
//                  return new ListTile(
//                    title: new Text(document['name']),
//                    onTap: () {
//                      Navigator.of(context).push(
//                          MaterialPageRoute(
//                              builder: (context) => ProfilePage()));
//                    },
//                  );
//                }).toList(),
//              );
//          }
//        });
//  }

  static final String route = "Team-Page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Team Page')),
      body: ScopedModelDescendant<HomeModel>(
          builder: (builder, child, model){
            return Center(child: CircularProgressIndicator());
          }
      ),
    );

//    return Scaffold(
//        appBar: new AppBar(
//          title: Text(widget.projectSnap.data['name'].toString()),
//        ),
//        body: Column(
//          children: <Widget>[
//            Padding(
//              padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
//              child: Text('Description: ${widget.projectSnap.data['description']}'),
//            ),
//            Padding(
//              padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
//              child: Text('Team Members',
//                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
//            ),
//            Flexible(
//              child: _buildMemberList(),
//            )
//          ],
//        ),
//      floatingActionButton: FloatingActionButton(
//          child: Icon(Icons.add),
//          onPressed: _onFloatingButtonPressed),
//    );
  }
}
