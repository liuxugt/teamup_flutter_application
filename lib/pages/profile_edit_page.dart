import 'package:flutter/material.dart';
import 'package:teamup_app/objects/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/objects/team.dart';


class ProfileEditPage extends StatefulWidget {

  final User user;
  ProfileEditPage({this.user});

  @override
  State<StatefulWidget> createState() => new ProfileEditPageState(user: this.user);
}

class ProfileEditPageState extends State<ProfileEditPage>{
  final User user;
  String headline;
  String skills;
  String strengths;
  TextEditingController headlineController = new TextEditingController();
  TextEditingController skillsController = new TextEditingController();
  TextEditingController strengthsController = new TextEditingController();
  ProfileEditPageState({this.user}){
    headline = user.headline;
    skills = user.skills;
    strengths = user.strengths;
    headlineController.text = headline;
    skillsController.text = skills;
    strengthsController.text = strengths;
  }


  Widget _makeBody() {
    //return Text("Body");

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
          child: Container(
            width: 100.0,
            child: TextField(
              controller: headlineController,
              onChanged: (value){headline = value;},
              textAlign: TextAlign.center,
            ),
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
                  "Skills",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                Container(
                  width: 100.0,
                  child: TextField(
                    controller: skillsController,
                    onChanged: (value) =>{skills = value},
                    textAlign: TextAlign.center,
                    ),
                )
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
                Container(
                  width: 100.0,
                  child: TextField(
                    controller: strengthsController,
                    onChanged: (value) =>{strengths = value},
                    textAlign: TextAlign.center,
                  ),
                )
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
                Container(
                  width: 100.0,
                  child: Text(user.languages.toString().replaceAll(new RegExp('[\\[\\]]'), ''),
                    style: TextStyle(fontSize: 16.0, color: Colors.black54), textAlign: TextAlign.end,),
                )
              ],
            ),

            //TODO: Add all the attributes for a user here
          ],
        )
    );
  }

  Widget _makeFAB(BuildContext context){
      return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          ScopedModel.of<UserModel>(context, rebuildOnChange: false).updateUser(
              headline, skills, strengths);
          Navigator.pop(context);
        }
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${user.firstName} ${user.lastName}'),
      ),
      body: _makeBody(),
      floatingActionButton: _makeFAB(context),
    );
  }
}
