import 'package:flutter/material.dart';
import 'dart:io';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/onboarding_model.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureTab extends StatefulWidget {
  @override
  _ProfilePictureTabState createState() => _ProfilePictureTabState();
}

class _ProfilePictureTabState extends State<ProfilePictureTab> {

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      ScopedModel.of<OnboardingModel>(context, rebuildOnChange: false).image = _image;
    });
  }

  @override
  void initState() {
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
          "Last Step!",
          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Container(
          height: 32.0,
        ),
        Text(
          "Upload your headshot",
          style: TextStyle(fontSize: 14.0, color: Colors.grey),
          textAlign: TextAlign.center,
        ),

        Container(
          child:  Center(
            child: _image == null
            ? Text('No image selected.')
                : Image.file(_image),
            ),
        ),
        Container(
          height: 32.0,
        ),
        Container(
          child: FloatingActionButton(
          onPressed: getImage,
          tooltip: 'Pick Image',
          child: Icon(Icons.add_a_photo),
          ),
        ),

      ],
    );
  }
}
