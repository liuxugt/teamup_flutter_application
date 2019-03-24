import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/onboarding_model.dart';
import 'package:teamup_app/models/user_model.dart';

class HeadlineTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 32.0,
        ),
        Text(
          "Hi ${ScopedModel.of<UserModel>(context, rebuildOnChange: false).currentUser.firstName}!\nGive yourself a title to tell people what you do.",
          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
        ),
        Container(
          height: 32.0,
        ),
        TextField(
          maxLines: 1,
          decoration: InputDecoration(hintText: 'I am a ...'),
          onChanged: (value) => ScopedModel.of<OnboardingModel>(context, rebuildOnChange: false).headline = value,
        )
      ],
    );
  }
}
