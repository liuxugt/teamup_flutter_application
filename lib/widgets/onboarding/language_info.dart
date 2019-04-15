import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/onboarding_model.dart';

class LanguageInfoTab extends StatefulWidget {
  @override
  _LanguageInfoTabState createState() => _LanguageInfoTabState();
}

class _LanguageInfoTabState extends State<LanguageInfoTab> {
  final List<String> languages = [
    'English',
    'Spanish',
    'Korean',
    'Mandarin',
    'Japanese',
    'French',
    'German',
    'Hindi',
    'Arabic',
    'Bengali',
    'Indonesian'
  ];

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
//          backgroundColor: Color.fromRGBO(90, 133, 236, 0.5),
          selectedColor: Color.fromRGBO(90, 133, 236, 1.0),
          avatar: CircleAvatar(backgroundColor: Color.fromRGBO(90, 133, 236, 1.0),),
          label: Text(language, style: (_languageItems.contains(language)) ? TextStyle(color: Colors.white) : null),
          selected: _languageItems.contains(language),
          onSelected: (bool value) {
            setState(() {
              if (value) {
                _languageItems.add(language);
              } else {
                _languageItems.removeWhere((String item) => item == language);
              }
            });
            ScopedModel.of<OnboardingModel>(context, rebuildOnChange: false)
                .languages = _languageItems;
          },
        ),
      );
    }
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
          "What lanauges are you fluent in?",
          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
        ),

        Container(
          height: 64.0,
        ),

        Wrap(
          children: languageWidgets.toList(),
        ),

        Container(
          height: 32.0,
        ),

      ],
    );
  }
}
