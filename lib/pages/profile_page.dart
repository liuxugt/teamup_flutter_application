import 'package:flutter/material.dart';
import 'package:teamup_app/objects/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/objects/team.dart';
import 'package:teamup_app/pages/profile_edit_page.dart';
import 'package:teamup_app/pages/propose_team_page.dart';

class ProfilePage extends StatelessWidget {
  final Map<String, String> strengthMap = {
    'strategicThinking':
        'I create new idea to solve problems, and look for the best way to move forward on it.',
    'influencing':
        'I sell big ideas. I’m good at taking charge, speaking up and be heard.',
    'executing':
        'I put ideas into action. I get things done, with speed, precision, and accuracy.',
    'relationshipBuilding':
        'I make relational connections that bind a group together around an idea or each other.'
  };

  final User user;
  ProfilePage({this.user});

  Widget _makeBody() {
    print(strengthMap);
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
          child: Text(
            user.email,
            style: TextStyle(fontSize: 16.0, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _makeAttributeList() {
    return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: <Widget>[
            (user.profilePageSubtitle.isEmpty)
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Image(
                              image: AssetImage("./assets/grade.png"),
                              color: null,
                              height: 16,
                              width: 16),
                        ), //Logo
                        Flexible(
                            child: Text(user.profilePageSubtitle,
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.black54)))
                      ],
                    ),
                  ),
            (user.skills == null || user.skills.isEmpty)
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Image(
                              image: new AssetImage("./assets/skills.png"),
                              color: null,
                              height: 16,
                              width: 16),
                        ), //Logo
                        Flexible(
                          child: Text('Proficient in ${user.skills}',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black54)),
                        )
                      ],
                    ),
                  ),
            (user.strengths == null ||
                    user.strengths.isEmpty ||
                    !strengthMap.containsKey(user.strengths))
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Image(
                              image: new AssetImage("./assets/good_at.png"),
                              color: null,
                              height: 16,
                              width: 16),
                        ), //Logo
                        Expanded(
                            child: Text(strengthMap[user.strengths],
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.black54)))
                      ],
                    ),
                  ),
            (user.languages == null || user.languages.isEmpty)
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Image(
                              image: new AssetImage("./assets/language.png"),
                              color: null,
                              height: 16,
                              width: 16),
                        ), //Logo
                        Flexible(
                          child: Text(
                            'Speaks ${user.languages.toString().replaceAll(new RegExp('[\\[\\]]'), '')}',
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.black54),
                          ),
                        )
                      ],
                    ),
                  ),
            (user.unavailable == null || user.unavailable.isEmpty)
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Image(
                                image: new AssetImage(
                                    "./assets/time_availability.png"),
                                color: null,
                                height: 16,
                                width: 16),
                          ), //Logo
                          Text(
                            "Unavailable at",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                        ]),
                  )
          ],
        ));
  }

  Widget _makeFAB(BuildContext context) {
    //if this is your profile page
    if (user.id ==
        ScopedModel.of<UserModel>(context, rebuildOnChange: false)
            .currentUser
            .id) {
      return FloatingActionButton(
          child: Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileEditPage(user: user)));
          });
    }

    //if the user is already in a team
    if (user.inTeamForCourse(
        ScopedModel.of<UserModel>(context, rebuildOnChange: false)
            .currentCourse
            .id)) {
      return Container(height: 0.0);
    }

    //if the user is not in a team
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () async {
        Team current =
            ScopedModel.of<UserModel>(context, rebuildOnChange: false)
                .currentTeam;

        //if you are not on a team, suggest to make one
        if (current == null) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("You are not in a team!"),
                  content: Text(
                      "It looks like you're not in a team, would you like to create one?"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Cancel"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    FlatButton(
                      child: Text("Propose Team"),
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => ProposeTeamPage(
                                  maxGroupSize: ScopedModel.of<UserModel>(
                                          context,
                                          rebuildOnChange: false)
                                      .currentCourse
                                      .groupSize))),
                    )
                  ],
                );
              });
        } else {
          await ScopedModel.of<UserModel>(context, rebuildOnChange: false)
              .createInvitation(current, user.id);
          showDialog(
              context: context,
              builder: (context) {
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
              });
        }
      },
    );
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
