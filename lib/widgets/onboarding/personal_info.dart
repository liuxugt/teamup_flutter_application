import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/onboarding_model.dart';

class PersonalInfoTab extends StatefulWidget {
  @override
  _PersonalInfoTabState createState() => _PersonalInfoTabState();
}

class _PersonalInfoTabState extends State<PersonalInfoTab> {
  final List<String> genderOptions = ['', 'Male', 'Female'];
  final List<String> majorOptions = [
    '',
    'CMPE',
    'HCI',
    'CS',
    'CE',
    'AE',
    'ME',
    'MSE'
  ];

  final List<String> yearOfStudyOptions = [
    '',
    'Freshman',
    'Sophomore',
    'Junior',
    'Senior',
    'Super-Senior',
    'Masters',
    'PhD'
  ];

  List<DropdownMenuItem<String>> _getDropDownMenuItems(List<String> options) {
    List<DropdownMenuItem<String>> items = new List();
    for (String option in options) {
      items.add(DropdownMenuItem(value: option, child: Text(option)));
    }
    return items;
  }

  DateTime _birthDate = DateTime.now();

  final double _titleFontSize = 24.0;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _birthDate,
        firstDate: DateTime(1990, 8),
        lastDate: DateTime(2020, 12));
    if (picked != null && picked != _birthDate)
      setState(() {
        _birthDate = picked;
        _birthDateUpdated = true;
        ScopedModel.of<OnboardingModel>(context, rebuildOnChange: false)
            .birthDate = _birthDate;
      });
  }

  bool _birthDateUpdated = false;
  String _genderValue;
  String _majorValue;
  String _yearOfStudyValue;

  List<DropdownMenuItem<String>> _genderItems;
  List<DropdownMenuItem<String>> _majorItems;
  List<DropdownMenuItem<String>> _yearOfStudyItems;

  @override
  void initState() {
    _genderValue = genderOptions[0];
    _majorValue = majorOptions[0];
    _yearOfStudyValue = yearOfStudyOptions[0];
    _genderItems = _getDropDownMenuItems(genderOptions);
    _majorItems = _getDropDownMenuItems(majorOptions);
    _yearOfStudyItems = _getDropDownMenuItems(yearOfStudyOptions);
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "Gender",
                  style: TextStyle(fontSize: _titleFontSize, fontWeight: FontWeight.bold),
                ),
                DropdownButton(
                  value: _genderValue,
                  items: _genderItems,
                  onChanged: (value) {
                    setState(() {
                      _genderValue = value;
                    });
                    ScopedModel.of<OnboardingModel>(context,
                            rebuildOnChange: false)
                        .gender = value;
                  },
//                  onSaved: (value) => _gender = value,
                )
              ],
            ),
            Column(
              children: <Widget>[
                Text(
                  "Date of Birth",
                  style: TextStyle(fontSize: _titleFontSize, fontWeight: FontWeight.bold),
                ),
                FlatButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                      (_birthDateUpdated)
                          ? "${_birthDate.day}/${_birthDate.month}/${_birthDate.year}"
                          : 'Select Date',
                      style: TextStyle(fontSize: 18.0, color: Color.fromRGBO(90, 133, 236, 1.0)),
                    )),
              ],
            )
          ],
        ),
        Container(
          height: 32.0,
        ),
        Text(
          "Major area of study",
          style: TextStyle(fontSize: _titleFontSize, fontWeight: FontWeight.bold),
        ),
        DropdownButton(
          isExpanded: true,
          value: _majorValue,
          items: _majorItems,
          onChanged: (value) {
            setState(() {
              _majorValue = value;
            });
            ScopedModel.of<OnboardingModel>(context, rebuildOnChange: false)
                .major = value;
          },
        ),
        Container(
          height: 32.0,
        ),
        Text(
          "Year of study",
          style: TextStyle(fontSize: _titleFontSize, fontWeight: FontWeight.bold),
        ),
        DropdownButton(
          isExpanded: true,
          value: _yearOfStudyValue,
          items: _yearOfStudyItems,
          onChanged: (value) {
            setState(() {
              _yearOfStudyValue = value;
            });
            ScopedModel.of<OnboardingModel>(context, rebuildOnChange: false)
                .yearOfStudy = value;
          },
        ),
      ],
    );
  }
}
