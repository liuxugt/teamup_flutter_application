import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/course_model.dart';
import 'package:teamup_app/models/home_model.dart';
import 'package:teamup_app/pages/home_page.dart';




class CoursePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CourseModel>(
      builder: (context, child, model){
        if(model.isCourseLoading)
          return Center(child: CircularProgressIndicator());

        HomeModel home = HomeModel();
        return ScopedModel<HomeModel>(
            model: home,
            child: HomePage(),
        );
      }
    );
  }
}
