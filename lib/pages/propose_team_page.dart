import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/objects/team.dart';
import 'package:teamup_app/objects/user.dart';

class ProposeTeamPage extends StatefulWidget {
  final int maxGroupSize;
  ProposeTeamPage({this.maxGroupSize});

  @override
  _ProposeTeamPageState createState() => _ProposeTeamPageState();
}

class _ProposeTeamPageState extends State<ProposeTeamPage> {
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

  List<String> _teamMatesToInvite = [];
  String _teamName = "";
  String _teamDescription = "";
  bool _isLoading = false;
  List<String> _memberTraits;
  List<User> _usersToInvite = [];
  String _error = "";


  int get _teamSize => _memberTraits.length;

  @override
  void initState() {
//    _teamSize = widget.maxGroupSize;
    _memberTraits = ['Me'];
    for (int i = 1; i < widget.maxGroupSize; i++) {
      _memberTraits.add(_teamMateTraitOptions[0]);
    }
  }

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
        title: Text("New Team"),
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
            _makeTeamMateCounter(),
            _makeTeamMateIconList(),
//            _makeTeamPreferenceInput(),
            _makeInviteClassmatesButton(),
            _makeInvitedUsersList(),
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
            validator: (value) =>
                value.isEmpty ? 'Team Name can\'t be empty' : null,
            onSaved: (value) => _teamName = value,
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
            onSaved: (value) => _teamDescription = value,
          )
        ],
      ),
    );
  }

  Widget _makeTeamMateCounter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[Text("Team members"), _makeCounter()],
    );
  }

  Widget _makeTeamMateIconList() {
    return Container(
      height: 100.0,
      margin: EdgeInsets.symmetric(vertical: 16.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
//        shrinkWrap: true,
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

  Widget _makeCounter() {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: _decrementCount,
        ),
        Container(
          color: Colors.grey[200],
          child: Text(_teamSize.toString()),
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: _incrementCount,
        ),
      ],
    );
  }

  _incrementCount() {
    if (_teamSize < widget.maxGroupSize) {
//      _updateCounterBy(1);
      setState(() {
        _memberTraits.add("Member");
      });
    }
  }

  _decrementCount() {
    if (_teamSize > 1) {
//      _updateCounterBy(-1);
      setState(() {
        _memberTraits.removeLast();
      });
    }
  }

  Widget _makeInviteClassmatesButton() {
    return Center(
      child: FlatButton(
          onPressed: () => _openInviteTeamMates(context),
          child: Text(
            'invite classmates',
            style: TextStyle(color: Colors.blue, fontSize: 16.0),
          )),
    );
  }

  _openInviteTeamMates(BuildContext context) async {
    List<User> output = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => InviteTeamMatesScreen(
              maxSelection: _teamSize - 1,
            )));
    print("Output from Invite Page: $output");
    if (output != null && output.isNotEmpty) {
      setState(() {
        _usersToInvite = output;
      });
    }
  }

  _makeInvitedUsersList() {
    if (_usersToInvite.isEmpty) return Container();

    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: _usersToInvite.map((user) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.photoURL),
          ),
          title: Text("${user.firstName} ${user.lastName}"),
        );
      }).toList(),
    );
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
                  User currentUser =
                      ScopedModel.of<UserModel>(context, rebuildOnChange: false)
                          .currentUser;
                  Team team = Team(
                      availableSpots: _teamSize,
                      name: _teamName,
                      description: _teamDescription,
                      leaderId: currentUser.id,
                      roles: _memberTraits.sublist(1)
                  );
                  setState(() {
                    _isLoading = true;
                  });
                  bool successful = await ScopedModel.of<UserModel>(context,
                          rebuildOnChange: false)
                      .createTeamAndJoin(team);
                  setState(() {
                    _isLoading = false;
                  });
                  if (successful) {
                    await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Team Created Succesfully!"),
                            content: Text(
                                "Your team has been created and you have been added to it!"),
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

class InviteTeamMatesScreen extends StatefulWidget {
  final int maxSelection;
  InviteTeamMatesScreen({this.maxSelection});

  @override
  _InviteTeamMatesScreenState createState() => _InviteTeamMatesScreenState();
}

class _InviteTeamMatesScreenState extends State<InviteTeamMatesScreen> {
  List<UserItem> items = [];
  int _numSelected = 0;

  List<User> _getSelectedUsers() {
    List<User> selectedUsers = [];
    for (UserItem item in items) {
      if (item.isCheck) {
        selectedUsers.add(item.user);
      }
    }
    return selectedUsers;
  }

  bool _checkAndSelect(bool checkBoxSelected) {
    if (checkBoxSelected) {
      if (_numSelected < widget.maxSelection) {
        _numSelected++;
        return true;
      }
      return false;
    } else {
      _numSelected--;
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invite Classmates (Up to ${widget.maxSelection})'),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop(_getSelectedUsers());
        },
        child: Icon(Icons.check),
      ),
    );
  }

  _buildBody() {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      if (!model.hasCourse) return Center(child: Text('No Course!'));
      return StreamBuilder<QuerySnapshot>(
          stream: model.getClassMates(),
          builder: (context, snapshot) {
            //print(snapshot.data.documents);
            if (snapshot.hasError) return Text('Error: %{snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                return ListView(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    if (document?.data != null) {
                      User user = User.fromSnapshotData(document.data);
                      UserItem userItem =
                          UserItem(user, false, _checkAndSelect);
                      items.add(userItem);
//                      _teamMatesSelectedMap[user] = false;
                      return UserListItem(items.last);
                    } else {
                      return Container();
                    }
                  }).toList(),
                );
            }
          });
    });
  }
}

//
class UserItem {
  User user;
  bool isCheck;
  Function(bool) itemCallback;
  UserItem(this.user, this.isCheck, this.itemCallback);
}

class UserListItem extends StatefulWidget {
  final UserItem userItem;

  UserListItem(UserItem userItem)
      : userItem = userItem,
        super(key: new ObjectKey(userItem));

  @override
  UserItemState createState() {
    return new UserItemState(userItem);
  }
}

class UserItemState extends State<UserListItem> {
  final UserItem userItem;

  UserItemState(this.userItem);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (userItem.itemCallback(!userItem.isCheck)) {
          setState(() {
            userItem.isCheck = !userItem.isCheck;
          });
        }
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userItem.user.photoURL),
      ),
      trailing: Checkbox(
          value: userItem.isCheck,
          onChanged: (value) {
            if (userItem.itemCallback(value)) {
              setState(() {
                userItem.isCheck = value;
              });
            }
          }),
      title: Text("${userItem.user.firstName} ${userItem.user.lastName}"),
      subtitle: Text('${userItem.user.email}'),
    );
  }
}
