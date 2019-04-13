import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/onboarding_model.dart';

enum StrengthType {
  strategicThinking,
  influencing,
  executing,
  relationshipBuilding
}

class Strength{
  String imagePath;
  String description;
  String title;
  StrengthType strengthType;

  Strength(String name, String path, String desc, StrengthType type){
    title = name;
    imagePath = path;
    description = desc;
    strengthType = type;
  }
}

class StrengthInfoTab extends StatefulWidget {
  @override
  _StrengthInfoTabState createState() => _StrengthInfoTabState();
}


class _StrengthInfoTabState extends State<StrengthInfoTab> {
  StrengthType _strength;

  @override
  void initState() {
    _strength = StrengthType.influencing;
    super.initState();
  }

  final List<Strength> _strengthList = [
    Strength('Strategic Thinking','assets/thinking.png', 'I create new idea to solve problems, and look for the best way to move forward on it.', StrengthType.strategicThinking),
    Strength('Influencing', 'assets/influencing.png', 'I sell big ideas. I’m good at taking charge, speak up and be heard.', StrengthType.influencing),
    Strength('Executing','assets/executing.png', 'I put ideas into action. I get things done, with speed, precision, and accuracy.', StrengthType.executing),
    Strength('Relationship Building','assets/relationbuilding.png', 'I make relational connections that bind a group together around an idea or each other.', StrengthType.relationshipBuilding)
  ];

  List<Widget> _makeTiles(){
    List<Widget> tiles = [];
    for(Strength strength in _strengthList){
      tiles.add(
        Card(
          elevation: 2.0,
          child: Container(
            width: 240.0,
            child: Column(
              children: <Widget>[
                RadioListTile<StrengthType>(
                  title: Text(strength.title, style: TextStyle(fontWeight: FontWeight.bold),),
                  value: strength.strengthType,
                  groupValue: _strength,
                  onChanged: (StrengthType value) {
                    setState(() {
                      _strength = value;
                      ScopedModel.of<OnboardingModel>(context,
                          rebuildOnChange: false)
                          .strengths = value.toString();
                    });
                  },
                ),
                Image.asset(strength.imagePath, height: 180,),
                Expanded(
//                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  child: Center(child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(strength.description, style: TextStyle(color: Colors.grey),),
                  )),
                )
              ],
            ),
          ),
        )
      );
    }
    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
//      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: Text(
            "Which of the following best fit your team strength",
            style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
          ),
        ),

        Container(
          height: 350.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _makeTiles(),
//            children: <Widget>[
//
////              Container(
////                width: 240.0,
////                alignment: Alignment.topCenter,
////                decoration: new BoxDecoration(
////                  image: DecorationImage(
////                    image: new AssetImage('assets/influencing.png'),
////                    fit: BoxFit.contain,
////                    alignment: Alignment.bottomCenter,
////                  ),
////                  shape: BoxShape.rectangle,
////                ),
////                child: new RadioListTile<Strengths>(
////                  title: const Text('Influencing'),
////                  value: Strengths.influencing,
////                  groupValue: _strength,
////                  onChanged: (Strengths value) {
////                    setState(() {
////                      _strength = value;
////                      ScopedModel.of<OnboardingModel>(context,
////                              rebuildOnChange: false)
////                          .strengths = value.toString();
////                    });
////                  },
////                ),
////              ),
////              Container(
////                width: 240.0,
////                decoration: new BoxDecoration(
////                  image: DecorationImage(
////                    image: new AssetImage('assets/executing.png'),
////                    fit: BoxFit.contain,
////                  ),
////                  shape: BoxShape.rectangle,
////                ),
////                child: new RadioListTile<Strengths>(
////                  title: const Text('Executing'),
////                  value: Strengths.executing,
////                  groupValue: _strength,
////                  onChanged: (Strengths value) {
////                    setState(() {
////                      _strength = value;
////                      ScopedModel.of<OnboardingModel>(context,
////                              rebuildOnChange: false)
////                          .strengths = value.toString();
////                    });
////                  },
////                ),
////              ),
////              Container(
////                width: 240.0,
////                decoration: new BoxDecoration(
////                  image: DecorationImage(
////                    image: new AssetImage('assets/relationbuilding.png'),
////                    fit: BoxFit.contain,
////                  ),
////                  shape: BoxShape.rectangle,
////                ),
////                child: new RadioListTile<Strengths>(
////                  title: const Text('Relationship Building'),
////                  value: Strengths.relationshipBuilding,
////                  groupValue: _strength,
////                  onChanged: (Strengths value) {
////                    setState(() {
////                      _strength = value;
////                      ScopedModel.of<OnboardingModel>(context,
////                              rebuildOnChange: false)
////                          .strengths = value.toString();
////                    });
////                  },
////                ),
////              ),
//            ],
          ),
        ),

      ],
    );
  }
}
