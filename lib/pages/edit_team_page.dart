import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
//import 'package:teamup_app/objects/user.dart';
import 'package:teamup_app/objects/team.dart';
import 'package:teamup_app/models/user_model.dart';

class EditTeamPage extends StatefulWidget {
  final Team providedTeam;
  EditTeamPage({this.providedTeam});

  @override
  _EditTeamPageState createState() => _EditTeamPageState();
}

class _EditTeamPageState extends State<EditTeamPage> {

  Team _currentTeam;

  @override
  void initState() {
    _currentTeam = widget.providedTeam;
    _memberTraits = ["Me"];
    for(int i = 0; i < _currentTeam.availableSpots; i++){
      String role = _currentTeam.roles[i];
      _memberTraits.add(role);
    }
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  final List<String> _teamMateTraitOptions = [
    "Anyone",
    "Product Manager",
    "Content Strategist",
    "UX researcher",
    "UX designer",
    "UI designer",
    "Interaction designer",
    "Motion designer",
    "Front-End designer",
    "Front-End developer",
    "Mobile app developer",
    "Full-Stack Developer",
    "Software Developer",
    "Data Scientist",
    "Quality Assurance",
    "Technical Lead"
  ];

  bool _isLoading = false;
  List<String> _memberTraits;
  String _error = "";


  int get _teamSize => _memberTraits.length;


  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Team"),
      ),
      body: _makeBody(),
    );
  }

  Widget _makeBody() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: ListView(
          scrollDirection: Axis.vertical,
//        crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _makeTeamNameInput(),
            _makeTeamDescriptionInput(),
            _makeTeamMateIconList(),
            _makeTips(),
            _makeError(),
            _makeFinishButton(),
          ],
        ),
      ),
    );
  }

  Widget _makeTeamNameInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Team Name'),
          TextFormField(
            maxLines: 1,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Name',
            ),
            initialValue: _currentTeam.name,
            validator: (value) =>
            value.isEmpty ? 'Team Name can\'t be empty' : null,
            onSaved: (value) => _currentTeam.name = value,
          )
        ],
      ),
    );
  }

  Widget _makeTeamDescriptionInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Write down your project ideas'),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Ideas',
            ),
            validator: (value) =>
            value.isEmpty ? 'Description can\'t be empty' : null,
            onSaved: (value) => _currentTeam.description = value,
            initialValue: _currentTeam.description,
          )
        ],
      ),
    );
  }



  Widget _makeTeamMateIconList() {
    return Container(
      height: 120.0,
      margin: EdgeInsets.symmetric(vertical: 16.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: ClampingScrollPhysics(),
        children: _makeTeamMemberIcons(),
      ),
    );
  }

  List<Widget> _makeTeamMemberIcons() {
    List<Widget> icons = [];
//    icons.add(_teamMateIcon());
    for (int i = 0; i < _teamSize; i++) {
      icons.add(_teamMateIcon(i));
    }
    return icons;
  }

  Widget _teamMateIcon(int idx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        IconButton(
          iconSize: 48,
          icon: Icon(
            Icons.account_circle,
            color: Colors.grey[400],
          ),
          onPressed: () => idx == 0 ? null : _showEditTeamMate(idx),
        ),
        Container(
          child: Center(
              child: Text(
                _memberTraits[idx],
                textAlign: TextAlign.center,
              )),
          width: 70.0,
        )
      ],
    );
  }

  _showEditTeamMate(int idx) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Edit teammate role'),
            children: _makeDialogOptions(context, idx),
          );
        });
  }

  List<Widget> _makeDialogOptions(BuildContext context, int idx) {
    List<Widget> options = [];
    for (int i = 0; i < _teamMateTraitOptions.length; i++) {
      options.add(SimpleDialogOption(
        onPressed: () {
          setState(() {
            _memberTraits[idx] = _teamMateTraitOptions[i];
          });
          Navigator.of(context).pop();
        },
        child: Text(_teamMateTraitOptions[i]),
      ));
    }
    options.add(FlatButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Text("Cancel"),
      textColor: Colors.blue,
    ));
    return options;
  }





  Widget _makeTips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Center(
        child: Text(
          'Tip: Click on the icon to edit teammate roles',
          style: TextStyle(color: Colors.black26),
        ),
      ),
    );
  }

  Widget _makeError(){
    if(_error.isEmpty){
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Center(
        child: Text(
          _error,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _makeFinishButton() {
    return Center(
      child: _isLoading
          ? CircularProgressIndicator()
          : FlatButton(
        onPressed: () async {
          if (_validateAndSave()) {

            setState(() {
              _isLoading = true;
            });

            _currentTeam.roles = _memberTraits.sublist(1);

            bool successful = await ScopedModel.of<UserModel>(context,
                rebuildOnChange: false)
                .modifyTeam(_currentTeam);
            setState(() {
              _isLoading = false;
            });
            if (successful) {

              await ScopedModel.of<UserModel>(context,
                  rebuildOnChange: false).changeCourse();

              await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Team Modified Succesfully!"),
                      content: Text(
                          "Your team has been edited"),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).popUntil(ModalRoute.withName('/home'));
                          },
                          child: Text('Okay!'),
                        )
                      ],
                    );
                  });
            }else{
              setState(() {
                _error = ScopedModel.of<UserModel>(context,
                    rebuildOnChange: false).error;
              });
            }
          }
        },
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 48.0, vertical: 8.0),
          child: Text('DONE'),
        ),
        color: Colors.blue,
        textColor: Colors.white,
      ),
    );
  }
}
