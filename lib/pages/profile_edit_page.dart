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

  final List<String> languages = [
    'English',
    'Spanish',
    'Korean',
    'Mandarin',
    'Japanese',
    'French',
    'German'
  ];

  List<String> selectedLanguage;
  //List<LanguageOption> languageOptions;
  ProfileEditPageState({this.user}){
    headline = user.headline;
    skills = user.skills;
    strengths = user.strengths;
    selectedLanguage = user.languages;
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
                Container(
                  width: 100.0,
                  child: TextField(
                    controller: headlineController,
                    onChanged: (value){headline = value;},
                    textAlign: TextAlign.center,
                  ),
                ),
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
                  width: 200.0,
                  child: FlatButton(
                    child: Text(user.languages.toString().replaceAll(new RegExp('[\\[\\]]'), '')),
                    onPressed: (){
                      _makeLanguageDialog(context);
                      },
                  ),
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
          //print(user.skills);
          ScopedModel.of<UserModel>(context, rebuildOnChange: false).updateUser(
              headline, skills, strengths, selectedLanguage);
          Navigator.pop(context);
        }
      );
  }

  void _makeLanguageDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("select languages"),
          content: ListView(
            children: languages.map((language) {return _makeLanguageOption(context, language);}).toList()
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    );
  }

  bool _selectLanguage(String language, bool checkboxSelected){
    if(!selectedLanguage.contains(language)){
      setState((){
        selectedLanguage.add(language);
      });
    }
    else{
      setState((){
        selectedLanguage.remove(language);
      });
    }
    print(selectedLanguage);
    return true;
  }
  Widget _makeLanguageOption(BuildContext context, String language){
    LanguageOption temp = new LanguageOption(language, selectedLanguage.contains(language), _selectLanguage);
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

class LanguageOption{
  String language;
  bool isCheck;
  Function(String, bool) itemCallback;
  LanguageOption(this.language, this.isCheck, this.itemCallback);
}

class LanguageListUnit extends StatefulWidget{
  final LanguageOption language;

  LanguageListUnit({this.language});
  @override
  State<StatefulWidget> createState() => new LanguageListUnitState(language: language);
}

class LanguageListUnitState extends State<LanguageListUnit>{
  final LanguageOption language;
  LanguageListUnitState({this.language});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(language.language),
      onTap: (){
        if(language.itemCallback(language.language, language.isCheck)){
          setState((){
            language.isCheck = !language.isCheck;
          });
        }
      },
      trailing: Checkbox(
        value: language.isCheck,
        onChanged: (value){
          if(language.itemCallback(language.language, value)){
            setState((){
              language.isCheck = value;
            });
          }
        },),
    );
  }
}