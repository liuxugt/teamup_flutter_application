import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/services/api.dart';

class OnboardingModel extends Model{

  final API _api = API();

  String headline = '';
  String gender = '';
  String birthDate;
  String major;
  String yearOfStudy;
  List<String> languages = [];
  String skills = '';
  String strengths = '';
  List<Map<String, String>> iceBreakers;


  submitAttributes() async {
    String currentUserId = (await _api.getCurrentUser()).uid;
    Map<String, dynamic> attributes = {};

    if(headline.isNotEmpty)
      attributes['headline'] = headline;

    if(gender.isNotEmpty)
      attributes['gender'] = gender;

    if(languages.length != 0)
      attributes['languages'] = languages;

    if(skills.isNotEmpty)
      attributes['skills'] = skills;

    if(strengths.isNotEmpty)
      attributes['strengths'] = strengths.substring(strengths.indexOf(('.')) + 1);

    _api.updateUserAttributes(currentUserId, attributes);
  }


}