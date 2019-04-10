import 'package:flutter/material.dart';
import 'package:teamup_app/objects/user.dart';


class ProfilePage extends StatelessWidget {

  final User user;
  ProfilePage({this.user});

  Widget _makeBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20.0),
        ),
        _makeHeader(),
        _makeAttributeList(),
      ],
    );
  }

  Widget _makeHeader() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(user.photoURL),
            radius: 40.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            '${user.firstName} ${user.lastName}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(user.headline == null ? "" : user.headline,
            style: TextStyle(fontSize: 16.0, color: Colors.black54),
          ),
        ),
// TODO: Add headline here
//        Padding(
//          padding: const EdgeInsets.all(4.0),
//          child: Text(user.headline,
//              style: TextStyle(fontSize: 18.0, color: Colors.black54)),
//        ),
      ],
    );
  }

  Widget _makeAttributeList() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Email",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Text(user.email,
                        style: TextStyle(fontSize: 16.0, color: Colors.black54))
                  ],
                ),
                Container(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Skill",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Text(user.skills == null ? "" : user.skills,
                        style: TextStyle(fontSize: 16.0, color: Colors.black54))
                  ],
                ),
                Container(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Strength",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Text(user.strengths == null ? "" : user.strengths,
                        style: TextStyle(fontSize: 16.0, color: Colors.black54))
                  ],
                ),
                Container(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Languages",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Text(user.languages.length == 0 ? "" : user.languages.toString().replaceAll(new RegExp('[\\[\\]]'), ''),
                        style: TextStyle(fontSize: 16.0, color: Colors.black54))
                  ],
                ),
                //TODO: Add all the attributes for a user here
              ],
            )
    );
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: Text('${user.firstName} ${user.lastName}'),
          ),
          body: _makeBody());
  }
}
