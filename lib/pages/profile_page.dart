import 'package:flutter/material.dart';
import 'package:teamup_app/objects/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/objects/team.dart';
import 'package:teamup_app/pages/profile_edit_page.dart';
import 'package:teamup_app/pages/propose_team_page.dart';
import 'package:teamup_app/widgets/profile_data_type.dart';

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
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
            ),
            _makeHeader(),
            _makeAttributeList(),
//            _makeSchedule(),
          ],
        )
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
                  ),
            (user.unavailable == null || user.unavailable.isEmpty) ? Container() : _makeSchedule()
          ],
        ));
  }

  Widget _makeSchedule() {
    return Container(
        height: 500,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Container(
              width: 32,
              child: Column(children: ProfileDataType.hourList.map((int hour) =>
                  Container(height: 32,
                  child:  Text("${hour}"),
                  alignment: Alignment(0.0, 3.0))).toList(),
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    child:Row(
                      children: <Widget>[
                        Container(
                            width: 48,
                            child: Text("S", textAlign: TextAlign.center)),
                        Container(
                            width: 48,
                            child: Text("M", textAlign: TextAlign.center)),
                        Container(
                            width: 48,
                            child: Text("T", textAlign: TextAlign.center)),
                        Container(
                            width: 48,
                            child: Text("W", textAlign: TextAlign.center)),
                        Container(
                            width: 48,
                            child: Text("T", textAlign: TextAlign.center)),
                        Container(
                            width: 48,
                            child: Text("F", textAlign: TextAlign.center)),
                        Container(
                            width: 48,
                            child: Text("S", textAlign: TextAlign.center)),
                      ],
                    ),),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Table(
                          defaultColumnWidth: FixedColumnWidth(48.0),
                          border: TableBorder.all(color: Colors.grey),
                          children: ProfileDataType.calendarIndex.map((List<int> hour) => TableRow(
                            children: hour.map((int cur) => GestureDetector(
                              onTap: () {
//                                setState(() {
//                                _availabilities[cur] = !_availabilities[cur];
//                                ScopedModel.of<OnboardingModel>(context, rebuildOnChange: false).availabilities = _availabilities;
//                              });
                              },
                              child: AnimatedContainer(duration: const Duration(milliseconds: 300),
                                  height: 32.0,
                                  color: user.unavailable[cur]
                                      ? Color.fromRGBO(90, 133, 236, 1.0)
                                      : Colors.white,
                                  child: Center(
                                    child: user.unavailable[cur]
                                        ? Text("X", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                        : Text(""),
                                  )
                              ),
                            )).toList(),
                          )).toList(),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        )
    );
  }

  Widget _makeFAB(BuildContext context) {

    User currentUser = ScopedModel.of<UserModel>(context, rebuildOnChange: false)
        .currentUser;
    Team currentTeam = ScopedModel.of<UserModel>(context, rebuildOnChange: false).currentTeam;

    bool viewingUserInTeam = user.inTeamForCourse(
        ScopedModel.of<UserModel>(context, rebuildOnChange: false)
            .currentCourse
            .id);

    bool currentUserIsTeamLeadAndTeamNotFull = currentTeam != null && !currentTeam.isFull && currentTeam.leader == currentUser.id;


    //if this is your profile page
    if (user.id == currentUser.id) {
      return FloatingActionButton(
          child: Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileEditPage(user: user)));
          });
    }


    if(currentTeam == null && !viewingUserInTeam){
      return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
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
        },
      );
    }


    if(currentUserIsTeamLeadAndTeamNotFull && !viewingUserInTeam){
      return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
            await ScopedModel.of<UserModel>(context, rebuildOnChange: false)
                .createInvitation(currentTeam, user.id);
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
      );

    }





      return Container(height: 0.0);


    //if the user is not in a team
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
