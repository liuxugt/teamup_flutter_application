import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/course_model.dart';
import 'package:teamup_app/models/home_model.dart';
import 'package:teamup_app/models/user_model.dart';
import 'package:teamup_app/widgets/classmates_list.dart';
import 'package:teamup_app/widgets/notifications_list.dart';

class HomePage extends StatelessWidget {
//  List<Widget> _pages = ScopedModel.of<HomeModel>(context, rebuildOnChange: false).hasCourse ? <Widget>[ClassmatesList(), ClassmatesList(), NotificationList()];
//  final _pages = [ClassmatesList(), ClassmatesList(), NotificationList()];

  _buildBottomNav(context) {
    final items = [
      BottomNavigationBarItem(
          icon: Icon(Icons.person), title: Text('Classmates')),
      BottomNavigationBarItem(icon: Icon(Icons.group), title: Text('Teams')),
      BottomNavigationBarItem(
          icon: Icon(Icons.email), title: Text('Notifications'))
    ];

    return ScopedModelDescendant<HomeModel>(builder: (context, child, model) {
      return BottomNavigationBar(
          onTap: (index) {
//              ScopedModel.of<HomeModel>(context, rebuildOnChange: true)
//                  .changePage(index);
//          _pageController.jumpToPage(index);
            model.changePage(index);
          },
          currentIndex: model.pageIndex,
          items: items);
    });
  }

  _buildBody(context) {
    return ScopedModelDescendant<HomeModel>(builder: (context, child, model) {
      final bool hasCourse =
          ScopedModel.of<CourseModel>(context, rebuildOnChange: false)
              .hasCourse;
      final int pageIndex =
          ScopedModel.of<HomeModel>(context, rebuildOnChange: false).pageIndex;

      if (!hasCourse) return Center(child: Text('No Courses'));

      switch (pageIndex) {
        case 0:
          return ClassmatesList();
        case 1:
          return ClassmatesList();
        case 2:
          return NotificationList();
      }
    });
  }

  _buildAppBar(context) {
    return AppBar(
      title: Text(ScopedModel.of<CourseModel>(context, rebuildOnChange: false)
          .currentCourse.name),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () =>
              ScopedModel.of<UserModel>(context, rebuildOnChange: false)
                  .signOut(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(context),
        bottomNavigationBar: _buildBottomNav(context),
        body: _buildBody(context),
//        ScopedModel.of<HomeModel>(context, rebuildOnChange: true).isHomeLoading
//            ? Center(child: CircularProgressIndicator())
//            : ScopedModel.of<HomeModel>(context, rebuildOnChange: false).hasCourse
//                ? [ClassmatesList(), ClassmatesList(), NotificationList()][ScopedModel.of<HomeModel>(context, rebuildOnChange: false).pageIndex]
//                : Center(child: Text("No Courses")),
        //TODO change this to make a drawer that doesnt reload bc user is always loaded
        drawer: null);
  }
}
