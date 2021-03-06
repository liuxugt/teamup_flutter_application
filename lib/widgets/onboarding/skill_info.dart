import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/onboarding_model.dart';

class SkillInfoTab extends StatefulWidget {
  @override
  _SkillInfoTabState createState() => _SkillInfoTabState();
}

class _SkillInfoTabState extends State<SkillInfoTab> {

//  String _skills;
//
//  @override
//  void initState() {
//    _skills = '';
//    super.initState();
//  }

  @override
  Widget build(BuildContext context) {
    return ListView(
//      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          height: 32.0,
        ),
        Text(
          "Tell people about your expertise and skills",
          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
        ),
        Container(
          height: 32.0,
        ),
        TextField(
          maxLines: 5,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              hintText: 'e.g. javascript or project management',
              border: OutlineInputBorder()
          ),
          onChanged: (value) => ScopedModel.of<OnboardingModel>(context, rebuildOnChange: false).skills = value,
        ),
        Container(
          height: 32.0,
        )
      ],
    );
  }
}
