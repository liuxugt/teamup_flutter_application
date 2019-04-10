import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/services/api.dart';
import 'dart:io';

class OnboardingModel extends Model{

  final API _api = API();

  String headline = '';
  String gender = '';
  String major;
  String yearOfStudy;
  DateTime birthDate;
  List<String> languages = [];
  String skills = '';
  String strengths = '';
  List<bool> availabilities = [];
  int iceBreakers = 0;
  File image;
  String pictureURL;



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

    if(availabilities.length != 0)
      attributes['availabilities'] = availabilities;

    attributes['icebreakers'] = iceBreakers;
    attributes['birthdate'] = birthDate;


    if (image != null) {
      pictureURL = await _api.uploadPicture(currentUserId, image);
      await _api.updateUserPhoto(currentUserId, pictureURL);
    }

    await _api.updateUserAttributes(currentUserId, attributes);
    await _api.markOnboardingComplete(currentUserId);
  }


}