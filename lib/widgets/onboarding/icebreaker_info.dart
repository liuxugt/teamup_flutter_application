import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/onboarding_model.dart';

class IcebreakerInfoTab extends StatefulWidget {
  @override
  _IcebreakerInfoTabState createState() => _IcebreakerInfoTabState();
}

class _IcebreakerInfoTabState extends State<IcebreakerInfoTab> {
  int _res;

  @override
  void initState() {
    _res = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
//      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          height: 32.0,
        ),
        Text(
          "Time for ice breaker quizzes!",
          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
        ),
        Container(
          height: 32.0,
        ),
        Container(
          height: 360.0,
          child: new ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Container(
                height: 180.0,
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  image: DecorationImage(
                    image: new AssetImage(
                        'assets/avengers.jpg',),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.rectangle,
                ),
                child: new RadioListTile<int>(
                  activeColor: Colors.white,
                  title: const Text('Marvel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 48.0),),
                  value: 0,
                  groupValue: _res,
                  onChanged: (int value) { setState(() { _res = value;
                  ScopedModel.of<OnboardingModel>(context, rebuildOnChange: false).iceBreakers = _res;}); },
                ),
              ),
              Container(
                height: 180.0,
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  image: DecorationImage(
                    image: new AssetImage(
                        'assets/dc.jpg'),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.rectangle,
                ),
                child: new RadioListTile<int>(
                  title: const Text('DC',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 48.0)),
                  value: 1,
                  activeColor: Colors.white,
                  groupValue: _res,
                  onChanged: (int value) { setState(() { _res = value;
                  ScopedModel.of<OnboardingModel>(context, rebuildOnChange: false).iceBreakers = _res;}); },
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
