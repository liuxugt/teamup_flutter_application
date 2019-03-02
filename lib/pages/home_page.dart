import 'package:flutter/material.dart';
import 'package:teamup_app/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamup_app/util/drawer.dart';
import 'package:teamup_app/widgets/classmates_list.dart';
import 'package:teamup_app/widgets/notifications_list.dart';
import 'package:teamup_app/widgets/projects_list.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Firestore db = Firestore.instance;

  int _currentTabIndex = 0;
  PageController _pageController;
  DocumentSnapshot _userSnap;

//  String _currentCourseName = "TeamUp";

  int _currentCourseIndex = 0;
  DocumentReference _courseRef;
  List<Widget> _pageChildren = [
    new Center(child: Text('Nothing to show')),
    new Center(child: Text('Nothing to show')),
    new Center(child: Text('Nothing to show')),
  ];




  @override
  void initState() {
    _loadUserData();
    _pageController = new PageController(
      initialPage: _currentTabIndex,
    );
    super.initState();
  }

  _loadUserData() async {
    DocumentSnapshot userSnap = await db.collection('users').document(widget.userId).get();
    setState(() {
      _userSnap = userSnap;
      _courseRef = userSnap.data.containsKey('courses') ? userSnap.data['courses'][_currentCourseIndex]['ref'] : null;
    });
    _updatePageChildren();
  }

  _updatePageChildren(){
//    print(selectedCourseRef.toString());
    if(_userSnap != null && _courseRef != null) {
      setState(() {
        _pageChildren = [
          new ClassmatesList(
              courseRef: _courseRef,
              db: db
          ),
          new ProjectsList(
              courseRef: _courseRef,
              db: db,
              userSnap: _userSnap,
          ),
          new NotificationList(),
        ];
      });
    }
  }

  _onDrawerCourseSelected(DocumentReference selectedCourseRef, int index){
    setState(() {
      _courseRef = selectedCourseRef;
      _currentCourseIndex = index;
    });
    _updatePageChildren();
  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: (_userSnap != null && _userSnap.data.containsKey('courses') && (_userSnap.data['courses'] as List).isNotEmpty) ? new Text(_userSnap.data['courses'][_currentCourseIndex]['name'].toString()) : const Text('No Courses'),
//        title: Text(_currentCourseName),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _signOut,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadUserData,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index){
//            this._pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.ease);
            _pageController.jumpToPage(index);
          },
          currentIndex: _currentTabIndex,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.person),
              title: new Text('Classmates')
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.group),
              title: new Text('Teams')
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.email),
              title: new Text('Notifications')
            )
          ]
      ),
      body: _userSnap == null ? Center(child: CircularProgressIndicator()) : PageView(
        controller: _pageController,
        onPageChanged: (index){
          setState(() {
            _currentTabIndex = index;
          });
        },
        children: _pageChildren,
      ),
        drawer: _userSnap == null ? null : CustomDrawer(_userSnap, _onDrawerCourseSelected, _currentCourseIndex)
    );


  }
}
