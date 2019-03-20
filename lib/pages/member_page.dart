import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/objects/course_member.dart';
import 'package:teamup_app/objects/user.dart';
import 'package:teamup_app/models/user_model.dart';

class MemberPage extends StatefulWidget {
  final CourseMember member;
  MemberPage({this.member});

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  User user;

  Widget _makeBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20.0),
        ),
        _makeHeader(context),
        _makeAttributeList(context),
      ],
    );
  }

  Widget _makeHeader(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(widget.member.photoURL),
            radius: 40.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            '${widget.member.firstName} ${widget.member.lastName}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(widget.member.headline,
              style: TextStyle(fontSize: 18.0, color: Colors.black54)),
        ),
      ],
    );
  }

  Widget _makeAttributeList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: user != null
          ? Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Email",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Text(user.email,
                        style: TextStyle(fontSize: 16.0, color: Colors.black54))
                  ],
                ),
                //TODO: Add all the attributes for a user here
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //Whenever page is built, load more user data and display it here
    ScopedModel.of<UserModel>(context, rebuildOnChange: true)
        .getUser(widget.member.id)
        .then((u) {
      setState(() {
        user = u;
      });
    });

    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.member.firstName} ${widget.member.lastName}'),
        ),
        body: _makeBody(context));
  }
}
