import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/member_model.dart';


class MemberPage extends StatelessWidget {
  Widget _makeBody(BuildContext context, MemberModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20.0),
        ),
        _makeHeader(context, model),
        _makeAttributeList(context, model),
      ],
    );
  }

  Widget _makeHeader(BuildContext context, MemberModel model) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(model.member.photoURL),
            radius: 40.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            '${model.member.firstName} ${model.member.lastName}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(model.member.headline,
              style: TextStyle(fontSize: 18.0, color: Colors.black54)),
        ),
      ],
    );
  }

  Widget _makeAttributeList(BuildContext context, MemberModel model) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: model.userLoaded
          ? Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Email",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Text(model.user.email,
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
    return ScopedModelDescendant<MemberModel>(builder: (context, child, model) {
      return Scaffold(
          appBar: AppBar(
            title: Text('${model.member.firstName} ${model.member.lastName}'),
          ),
          body: _makeBody(context, model));
    });
  }
}
