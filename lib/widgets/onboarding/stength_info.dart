import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/onboarding_model.dart';

enum Strengths {
  strategicThinking,
  influencing,
  executing,
  relationshipBuilding
}

class StrengthInfoTab extends StatefulWidget {
  @override
  _StrengthInfoTabState createState() => _StrengthInfoTabState();
}

class _StrengthInfoTabState extends State<StrengthInfoTab> {
  Strengths _strength;

  @override
  void initState() {
    _strength = Strengths.influencing;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          height: 32.0,
        ),
        Text(
          "Which of the following best fit your team strength",
          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
        ),
        Container(
          height: 32.0,
        ),
        Container(
          height: 240.0,
          child: new ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
//              Container(
//                height: 240.0,
//                child: Column(
//                  children: <Widget>[
//                    RadioListTile<Strengths>(
//                      title: const Text('Strategic Thinking'),
//                      value: Strengths.strategicThinking,
//                      groupValue: _strength,
//                      onChanged: (Strengths value) {
//                        setState(() {
//                          _strength = value;
//                          ScopedModel.of<OnboardingModel>(context,
//                                  rebuildOnChange: false)
//                              .strengths = value.toString();
//                        });
//                      },
//                    ),
//                    Image.asset('assets/thinking.png')
//                  ],
//                ),
//              ),
              Container(
                width: 240.0,
                alignment: Alignment.topCenter,
                decoration: new BoxDecoration(
                  image: DecorationImage(
                    image: new AssetImage('assets/thinking.png'),
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter
                  ),
                  shape: BoxShape.rectangle,
                ),
                child: new RadioListTile<Strengths>(
                  title: const Text('Strategic Thinking'),
                  value: Strengths.strategicThinking,
                  groupValue: _strength,
                  onChanged: (Strengths value) {
                    setState(() {
                      _strength = value;
                      ScopedModel.of<OnboardingModel>(context,
                              rebuildOnChange: false)
                          .strengths = value.toString();
                    });
                  },
                ),
              ),
              Container(
                width: 240.0,
                alignment: Alignment.topCenter,
                decoration: new BoxDecoration(
                  image: DecorationImage(
                    image: new AssetImage('assets/influencing.png'),
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter,
                  ),
                  shape: BoxShape.rectangle,
                ),
                child: new RadioListTile<Strengths>(
                  title: const Text('Influencing'),
                  value: Strengths.influencing,
                  groupValue: _strength,
                  onChanged: (Strengths value) {
                    setState(() {
                      _strength = value;
                      ScopedModel.of<OnboardingModel>(context,
                              rebuildOnChange: false)
                          .strengths = value.toString();
                    });
                  },
                ),
              ),
              Container(
                width: 240.0,
                decoration: new BoxDecoration(
                  image: DecorationImage(
                    image: new AssetImage('assets/executing.png'),
                    fit: BoxFit.contain,
                  ),
                  shape: BoxShape.rectangle,
                ),
                child: new RadioListTile<Strengths>(
                  title: const Text('Executing'),
                  value: Strengths.executing,
                  groupValue: _strength,
                  onChanged: (Strengths value) {
                    setState(() {
                      _strength = value;
                      ScopedModel.of<OnboardingModel>(context,
                              rebuildOnChange: false)
                          .strengths = value.toString();
                    });
                  },
                ),
              ),
              Container(
                width: 240.0,
                decoration: new BoxDecoration(
                  image: DecorationImage(
                    image: new AssetImage('assets/relationbuilding.png'),
                    fit: BoxFit.contain,
                  ),
                  shape: BoxShape.rectangle,
                ),
                child: new RadioListTile<Strengths>(
                  title: const Text('Relationship Building'),
                  value: Strengths.relationshipBuilding,
                  groupValue: _strength,
                  onChanged: (Strengths value) {
                    setState(() {
                      _strength = value;
                      ScopedModel.of<OnboardingModel>(context,
                              rebuildOnChange: false)
                          .strengths = value.toString();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 32.0,
        )
      ],
    );
  }
}
