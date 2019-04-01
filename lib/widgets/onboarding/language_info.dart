import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/onboarding_model.dart';

class LanguageInfoTab extends StatefulWidget {
  @override
  _LanguageInfoTabState createState() => _LanguageInfoTabState();
}

class _LanguageInfoTabState extends State<LanguageInfoTab> {
  final List<String> languages = ['English', 'Spanish', 'Korean', 'Mandarin', 'Japanese', 'French', 'German'];

  List<String> _languageItems;

  @override
  void initState() {
    _languageItems = <String>[];
    super.initState();
  }

  Iterable<Widget> get languageWidgets sync* {
    for (String language in languages) {
      yield Padding(
        padding: const EdgeInsets.all(4.0),
        child: FilterChip(
          avatar: CircleAvatar(),
          label: Text(language),
          selected: _languageItems.contains(language),
          onSelected: (bool value) {
            setState(() {
              if (value) {
                _languageItems.add(language);
              } else {
                _languageItems.removeWhere((String item) => item == language);
              }
            });
            ScopedModel.of<OnboardingModel>(context,
                rebuildOnChange: false)
                .languages = _languageItems;
            print (_languageItems);

          },
        ),
      );
    }
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
          "Waht lanauges are you fluent in?",
          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
        ),

        Wrap(
          children: languageWidgets.toList(),
        ),


        Container(
          height: 32.0,
        ),



//        Container(
//          height: 32.0,
//        ),
//        Text(
//          "Major area of study",
//          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
//        ),
//        DropdownButton(
//          isExpanded: true,
//          value: _majorValue,
//          items: _majorItems,
//          onChanged: (value) {
//            setState(() {
//              _majorValue = value;
//            });
//            ScopedModel.of<OnboardingModel>(context, rebuildOnChange: false)
//                .major = value;
//          },
//        ),
//        Container(
//          height: 32.0,
//        ),
//        Text(
//          "Year of study",
//          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
//        ),
//        DropdownButton(
//          isExpanded: true,
//          value: _yearOfStudyValue,
//          items: _yearOfStudyItems,
//          onChanged: (value) {
//            setState(() {
//              _yearOfStudyValue = value;
//            });
//            ScopedModel.of<OnboardingModel>(context, rebuildOnChange: false)
//                .yearOfStudy = value;
//          },
//        ),
      ],
    );
  }
}
