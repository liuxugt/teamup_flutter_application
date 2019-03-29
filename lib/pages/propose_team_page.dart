import 'package:flutter/material.dart';

class ProposeTeamPage extends StatefulWidget {
  final int maxGroupSize;
  ProposeTeamPage({this.maxGroupSize});

  @override
  _ProposeTeamPageState createState() => _ProposeTeamPageState();
}

class _ProposeTeamPageState extends State<ProposeTeamPage> {
  final _formKey = GlobalKey<FormState>();
  String _teamName;
  String _teamDescription;
  int _teamSize;
  bool _isLoading = false;

  @override
  void initState() {
    _teamSize = widget.maxGroupSize;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _makeTeamNameInput(),
          _makeTeamDescriptionInput(),
          _makeTeamPreferenceInput(),
          _makeInviteClassmatesButton(),
          _makeTips(),
          _makeFinishButton(),
        ],
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
                value.isEmpty ? 'Team Name can\'t be empty' : null,
            onSaved: (value) => _teamDescription = value,
          )
        ],
      ),
    );
  }

  Widget _makeTeamPreferenceInput() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[Text("Team members"), _makeCounter()],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _makeTeamMemberIcons(),
          ),
        )
      ],
    );
  }

  List<Widget> _makeTeamMemberIcons() {
    List<Widget> icons = [];
    icons.add(_teamMateIcon(isCurrentUser: true));
    for (int i = 1; i < _teamSize; i++) {
      icons.add(_teamMateIcon());
    }
    return icons;
  }

  Widget _teamMateIcon({isCurrentUser = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        IconButton(
          iconSize: 48,
          icon: Icon(
            Icons.account_circle,
            color: Colors.grey[400],
          ),
          onPressed: () {
            //TODO: add popup to edit user
          },
        ),
        isCurrentUser ? Text('Me') : Text('Member')
      ],
    );
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
      _updateCounterBy(1);
    }
  }

  _decrementCount() {
    if (_teamSize > 1) {
      _updateCounterBy(-1);
    }
  }

  _updateCounterBy(int num) {
    setState(() {
      _teamSize += num;
    });
  }

  Widget _makeInviteClassmatesButton() {
    return Center(
      child: FlatButton(
          onPressed: () {},
          child: Text(
            'invite classmates',
            style: TextStyle(color: Colors.blue, fontSize: 16.0),
          )),
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

  Widget _makeFinishButton() {
    return Center(
      child: _isLoading ? CircularProgressIndicator() : FlatButton(
        onPressed: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 8.0),
          child: Text('DONE'),
        ),
        color: Colors.blue,
        textColor: Colors.white,
      ),
    );
  }
}
