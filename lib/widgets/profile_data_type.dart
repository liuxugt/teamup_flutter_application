import 'package:flutter/material.dart';

class ProfileDataType {

  //  A list of languages that are available
  static final List<String> languages = [
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


  static final hours = 12;
  static final days = 7;

  static final List<List<int>> calendarIndex = List<List<int>>.generate(hours, (i) => List<int>.generate(days, (j) => i * days + j));
  static final List<int> hourList = new List<int>.generate(hours, (int index) => index + 8);
}

