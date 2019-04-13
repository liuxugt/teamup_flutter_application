import 'package:flutter/material.dart';
import 'package:teamup_app/objects/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/objects/team.dart';
import 'package:teamup_app/pages/profile_edit_page.dart';


class ProfilePage extends StatelessWidget {

  User user;
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
          child: Text(user.email,
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
                      "headline",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Text(user.subtitle,
                        style: TextStyle(fontSize: 16.0, color: Colors.black54))
                  ],
                ),
                (user.skills == null || user.skills.isEmpty) ? Container() :
                Container(
                  height: 16.0,
                ),
                (user.skills == null || user.skills.isEmpty) ? Container() :
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Skills",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Container(
                      width: 200.0,
                      child: Text(user.skills,
                          style: TextStyle(fontSize: 16.0, color: Colors.black54), textAlign: TextAlign.end,),
                    )
                  ],
                ),
                (user.strengths == null || user.strengths.isEmpty) ? Container() :
                Container(
                  height: 16.0,
                ),
                (user.strengths == null || user.strengths.isEmpty) ? Container() :
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Strength",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Text(user.strengths,
                        style: TextStyle(fontSize: 16.0, color: Colors.black54), textAlign: TextAlign.end)
                  ],
                ),
                (user.languages.isEmpty) ? Container() :
                Container(
                  height: 16.0,
                ),
                (user.languages.isEmpty) ? Container() :
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Languages",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Container(
                      width: 200.0,
                      child: Text(user.languages.toString().replaceAll(new RegExp('[\\[\\]]'), ''),
                          style: TextStyle(fontSize: 16.0, color: Colors.black54), textAlign: TextAlign.end,),
                    )
                  ],
                ),
                /*
                (user.languages.isEmpty) ? Container() :
                Container(
                  height: 16.0,
                ),
                (user.languages.isEmpty) ? Container() :
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Languages",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Container(
                      width: 200.0,
                      child: Text(user.languages.toString().replaceAll(new RegExp('[\\[\\]]'), ''),
                        style: TextStyle(fontSize: 16.0, color: Colors.black54), textAlign: TextAlign.end,),
                    )
                  ],
                ),
                */
                //TODO: Add all the attributes for a user here
              ],
            )
    );
  }

  Widget _makeFAB(BuildContext context){
    if(user.id == ScopedModel.of<UserModel>(context, rebuildOnChange: false).currentUser.id){
      return FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileEditPage(user: user)));
        }
      );
    }
    if(user.inTeamForCourse(
        ScopedModel.of<UserModel>(context, rebuildOnChange: false)
            .currentCourse
            .id) || !ScopedModel.of<UserModel>(context, rebuildOnChange: false).userInTeam){
      print("here");
      return Container(height: 0.0);
    }
    else{
      return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Team current = ScopedModel.of<UserModel>(context, rebuildOnChange: false).currentTeam;
          print("Team Id to send invitation is");
          print(current.id);
          await ScopedModel.of<UserModel>(context, rebuildOnChange: false).createInvitation(current, user.id);
            print("here");
            showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
                  title: Text("Invitation Confirmation"),
                  content: Text(
                      "Your Invitation has been successfully sent, check your inbox for updates!"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Okay!"),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                );
              }
            );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
      //user = ScopedModel.of<UserModel>(context, rebuildOnChange: true).currentUser;
      return Scaffold(
          appBar: AppBar(
            title: Text('${user.firstName} ${user.lastName}'),
          ),
          body: _makeBody(),
          floatingActionButton: _makeFAB(context),
      );
  }
}
