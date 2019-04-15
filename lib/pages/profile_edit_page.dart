import 'package:flutter/material.dart';
import 'package:teamup_app/objects/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teamup_app/widgets/profile_data_type.dart';
import 'dart:io';

class ProfileEditPage extends StatefulWidget {
  final User user;
  ProfileEditPage({this.user});

  @override
  State<StatefulWidget> createState() =>
      new ProfileEditPageState(user: this.user);
}

class ProfileEditPageState extends State<ProfileEditPage> {
  final User user;
  String headline;
  String skills;
  String strengths;
  String major;
  String yearofStudy;
  TextEditingController headlineController = new TextEditingController();
  TextEditingController skillsController = new TextEditingController();
  TextEditingController majorController = new TextEditingController();
  TextEditingController yearController = new TextEditingController();
  File _image;

  final List<String> languages = ProfileDataType.languages;

  final List<String> strengthList = [
    'strategicThinking',
    'influencing',
    'executing',
    'relationshipBuilding',
  ];

  List<String> selectedLanguage;
  //List<LanguageOption> languageOptions;
  ProfileEditPageState({this.user}) {
    headline = user.headline;
    skills = user.skills;
    strengths = user.strengths;
    selectedLanguage = user.languages;
    major = user.major;
    yearofStudy = user.yearOfStudy;

    headlineController.text = headline;
    skillsController.text = skills;
    majorController.text = major;
    yearController.text = yearofStudy;
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      ScopedModel.of<UserModel>(context, rebuildOnChange: false)
          .updateUserPhoto(image);
    });
  }

  Widget _makeBody() {
    //return Text("Body");

    return ListView(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
            ),
            _makeHeader(),
            _makeAttributeList(),
          ],
        )
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
          child: IconButton(
            icon: Icon(Icons.camera),
            onPressed: () {
              getImage();
            },
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
            Row(
              children: <Widget>[
                Container(
                  width: 100,
                  child: Text(
                    "Major",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
                Flexible(
                  child: TextField(
                    controller: majorController,
                    onChanged: (value) {
                      major = value;
                    },
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 100,
                  child: Text(
                    "Year",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
                Flexible(
                  child: TextField(
                    controller: yearController,
                    onChanged: (value) {
                      yearofStudy = value;
                    },
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

            Row(
              children: <Widget>[
                Container(
                  width: 100,
                  child: Text(
                    "headline",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
                Flexible(
                  child: TextField(
                    controller: headlineController,
                    onChanged: (value) {
                      headline = value;
                    },
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

            Row(
              children: <Widget>[
                Container(
                  width: 100,
                  child: Text(
                    "Skills",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
                Flexible(
                  child: TextField(
                    controller: skillsController,
                    onChanged: (value) => {skills = value},
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),

            Row(
              children: <Widget>[
                Container(
                  width: 100,
                  child: Text(
                    "Strength",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
                Flexible(
                  child: Center(
                    child: FlatButton(
                        textColor: Color.fromRGBO(90, 133, 236, 1.0),
                        child: Text(user.strengths),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SimpleDialog(
                                  title: Text("choose a strengths"),
                                  children: _makestrengthsOptions(context),
                                );
                              });
                        }),
                  ),
                )
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 100.0,
                  child: Text(
                    "Languages",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
                Flexible(
                  child: Center(
                    child: FlatButton(
                      textColor: Color.fromRGBO(90, 133, 236, 1.0),
                      child: Text(user.languages
                          .toString()
                          .replaceAll(new RegExp('[\\[\\]]'), '')),
                      onPressed: () {
                        _makeLanguageDialog(context);
                      },
                    ),
                  ),
                )
              ],
            ),

            //TODO: Add all the attributes for a user here
          ],
        ));
  }

  Widget _makeFAB(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.done),
        backgroundColor: Color.fromRGBO(90, 133, 236, 1.0),
        onPressed: () {
          //print(user.skills);
          ScopedModel.of<UserModel>(context, rebuildOnChange: false).updateUser(
              headline,
              skills,
              strengths,
              selectedLanguage,
              major,
              yearofStudy);
          Navigator.of(context).popUntil(ModalRoute.withName('/home');
        });
  }

  List<Widget> _makestrengthsOptions(BuildContext context) {
    List<Widget> options = [];
    for (int i = 0; i < strengthList.length; i++) {
      options.add(SimpleDialogOption(
        onPressed: () {
          setState(() {
            strengths = strengthList[i];
            user.setStrengths = strengthList[i];
          });
          Navigator.of(context).pop();
        },
        child: Text(strengthList[i]),
      ));
    }
    options.add(FlatButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Text("Cancel"),
      textColor: Color.fromRGBO(90, 133, 236, 1.0),
    ));
    return options;
  }

  void _makeLanguageDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("select languages"),
            content: ListView(
                children: languages.map((language) {
              return _makeLanguageOption(context, language);
            }).toList()),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  bool _selectLanguage(String language, bool checkboxSelected) {
    if (!selectedLanguage.contains(language)) {
      setState(() {
        selectedLanguage.add(language);
      });
    } else {
      setState(() {
        selectedLanguage.remove(language);
      });
    }
    print(selectedLanguage);
    return true;
  }

  Widget _makeLanguageOption(BuildContext context, String language) {
    LanguageOption temp = new LanguageOption(
        language, selectedLanguage.contains(language), _selectLanguage);
    return LanguageListUnit(language: temp);
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

class LanguageOption {
  String language;
  bool isCheck;
  Function(String, bool) itemCallback;
  LanguageOption(this.language, this.isCheck, this.itemCallback);
}

class LanguageListUnit extends StatefulWidget {
  final LanguageOption language;

  LanguageListUnit({this.language});
  @override
  State<StatefulWidget> createState() =>
      new LanguageListUnitState(language: language);
}

class LanguageListUnitState extends State<LanguageListUnit> {
  final LanguageOption language;
  LanguageListUnitState({this.language});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(language.language),
      onTap: () {
        if (language.itemCallback(language.language, language.isCheck)) {
          setState(() {
            language.isCheck = !language.isCheck;
          });
        }
      },
      trailing: Checkbox(
        value: language.isCheck,
        onChanged: (value) {
          if (language.itemCallback(language.language, value)) {
            setState(() {
              language.isCheck = value;
            });
          }
        },
      ),
    );
  }
}
