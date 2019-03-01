import 'package:flutter/material.dart';
import 'package:teamup_app/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamup_app/util/drawer.dart';

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
  final db = Firestore.instance;
  int _currentIndex = 0;
  DocumentSnapshot userData;
  DocumentSnapshot course;
  var courseData;
  int _numCourses;
  List<String> _courses = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    userData = await db.collection('users').document(widget.userId).get();

    courseData = await _getCourse();
    for (var i = 0; i < courseData.length; i++) {
      _courses.add(courseData[i]['name']);
    }

//    setState(() {
//      userData = data;
////      _numCourses = userData.data['courses'].length;
//    });

//    for (var i = 0; i < courses.length; i++) {
//      DocumentReference courseRef = courses[i]['ref'];
//      course = await courseRef.get();
//      print(course.data);
//    }
//
//    print(courses[0].toString());
//    print(courseData.toString());
  }

  Future<List<Map<K, V>>> _getCourse<K, V>() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .document(widget.userId)
        .get();
    if (querySnapshot.exists &&
        querySnapshot.data.containsKey('courses') &&
        querySnapshot.data['courses'] is List) {
      // Create a new List<String> from List<dynamic>
      return List<Map<K, V>>.from(querySnapshot.data['courses']);
    }
    return [];
  }


  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  void onTabTapped(int index){
    setState((){
      _currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Teamup'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _signOut,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadUserData,
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
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
              title: new Text('Inbox')
            )
          ]
      ),
      body: Center(
        child: Center(
          child: userData != null ? Text(userData.data['uid']) : Text('Nothing here...')
          )
        ),
      drawer: CustomDrawer(userData, (){})
//        // Add a ListView to the drawer. This ensures the user can scroll
//        // through the options in the Drawer if there isn't enough vertical
//        // space to fit everything.
//        child: ListView(
//          // Important: Remove any padding from the ListView.
//          padding: EdgeInsets.zero,
//          children: <Widget>[
//            DrawerHeader(
//              child: Text(userData.data['first_name'] + " " + userData.data['last_name']),
//              decoration: BoxDecoration(
//                color: Colors.blue,
//              ),
//            ),
//            ListTile(
//              title: Text(""),
//              onTap: () {
//                // Update the state of the app
//                // ...
//                // Then close the drawer
//                Navigator.pop(context);
//              },
//            ),
//            ListTile(
//              title: Text('Item 2'),
//              onTap: () {
//                // Update the state of the app
//                // ...
//                // Then close the drawer
//                Navigator.pop(context);
//              },
//            ),
//          ],
//
//        ),

      );
  }
}


