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
    //TODO: add max height and width to compress
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 400, maxWidth: 400);
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
    return ListView(
//      crossAxisAlignment: CrossAxisAlignment.stretch,
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

        Center(
          //TODO: check width and height constraints to show full image
          child:  Container(
            height: 250,
            width: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: (_image == null) ? DecorationImage(image: NetworkImage('http://rkhealth.com/wp-content/uploads/5.jpg'), fit: BoxFit.cover) : DecorationImage(image: FileImage(_image), fit: BoxFit.cover)
            ),
margin: EdgeInsets.all(24),
//            child: _image == null
//            ? Text('No image selected.')
//                : Image.file(_image, fit: BoxFit.fitWidth,),
            ),
        ),

        Container(
          child: FloatingActionButton(
            backgroundColor: Color.fromRGBO(90, 133, 236, 1.0),
          onPressed: getImage,
          tooltip: 'Pick Image',
          child: Icon(Icons.add_a_photo),
          ),
        ),

      ],
    );
  }
}
