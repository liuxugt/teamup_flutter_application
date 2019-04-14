import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/onboarding_model.dart';

class AvailabilityInfoTab extends StatefulWidget {
  @override
  _AvailabilityInfoTabState createState() => _AvailabilityInfoTabState();
}

class _AvailabilityInfoTabState extends State<AvailabilityInfoTab> {
  List<bool> _availabilities;

  static final hours = 12;
  static final days = 7;

  List<List<int>> index = List<List<int>>.generate(hours, (i) => List<int>.generate(days, (j) => i * days + j));
  List<Container> hourList = [];

  @override
  void initState() {
    _availabilities = new List<bool>.filled(hours * days, false);
    super.initState();
    hourList.add(Container(height: 16, child: Text(""),));
    for (int i = 0; i < hours; i++) {
      hourList.add(
        Container(height: 32,
          child:  Text("${i + 8}"),
          alignment: Alignment(0.0, 0.0)),);
    }
  }

  List<TableRow> test() {
    List<TableRow> res;
    res = index.map((List<int> hour) => TableRow(
        decoration: new BoxDecoration(
//          border: Border.all(color: Colors.red),
        ),
        children: hour.map((int cur) => GestureDetector(
          onTap: () {setState(() {
            _availabilities[cur] = !_availabilities[cur];
            ScopedModel.of<OnboardingModel>(context, rebuildOnChange: false).availabilities = _availabilities;
          });
          },
          child: AnimatedContainer(duration: const Duration(milliseconds: 300),
              height: 32.0,
              color: _availabilities[cur]
                  ? Colors.blue
                  : Colors.white,
              child: Center(
                child: _availabilities[cur]
                    ? Text("X", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                    : Text(""),
              )
          ),
        )).toList(),
    )).toList();
    return res;
  }


  @override
  Widget build(BuildContext context) {
    return ListView(
//      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          height: 32.0,
        ),
        const Text.rich(
          TextSpan(
            style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
            children: <TextSpan>[
              TextSpan(text: 'What time are you'),
              TextSpan(
                text: ' unavailable ',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w900,
                  color: Colors.blue)),
              TextSpan(text: 'for team work?'),
            ],
          ),
        ),
        Container(
          height: 32.0,
        ),
//        Container(
//          height: 32.0,
//          child:Row(children: <Widget>[
//            Container(width: 32,),
//            Expanded(
//              child: Text('S', textAlign: TextAlign.center),
//            ),
//            Expanded(
//              child: Text('M', textAlign: TextAlign.center),
//            ),
//            Expanded(
//              child: Text('T', textAlign: TextAlign.center),
//            ),
//            Expanded(
//              child: Text('W', textAlign: TextAlign.center),
//            ),
//            Expanded(
//              child: Text('T', textAlign: TextAlign.center),
//            ),
//            Expanded(
//              child: Text('F', textAlign: TextAlign.center),
//            ),
//            Expanded(
//              child: Text('S', textAlign: TextAlign.center),
//            ),
//          ],)
//        ),
        Container(
          height: 600,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                width: 32,
                child: Column(children: hourList,
                ),
              ),
//              Container(
////                width: 300,
//                child: Table(
//                  defaultColumnWidth: FixedColumnWidth(48.0),
//                  border: TableBorder.all(color: Colors.grey),
//                  children: test(),
////                  children: new List.from(test())..insert(0, TableRow(
////                    decoration: new BoxDecoration(
////                      border: Border.all(color: Colors.red),
////                    ),
////
////                    children: [
////                      Text("S"),
////                      Text("M"),
////                      Text("T"),
////                      Text("W"),
////                      Text("T"),
////                      Text("F"),
////                      Text("S"),
////                    ]
//                ),
//              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child:Row(
                        children: <Widget>[
                          Container(
                              width: 48,
                              child: Text("S", textAlign: TextAlign.center)),
                          Container(
                              width: 48,
                              child: Text("M", textAlign: TextAlign.center)),
                          Container(
                              width: 48,
                              child: Text("T", textAlign: TextAlign.center)),
                          Container(
                              width: 48,
                              child: Text("W", textAlign: TextAlign.center)),
                          Container(
                              width: 48,
                              child: Text("T", textAlign: TextAlign.center)),
                          Container(
                              width: 48,
                              child: Text("F", textAlign: TextAlign.center)),
                          Container(
                              width: 48,
                              child: Text("S", textAlign: TextAlign.center)),
                        ],
                      ),),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Table(
                            defaultColumnWidth: FixedColumnWidth(48.0),
                            border: TableBorder.all(color: Colors.grey),
                            children: test(),
                          )
                        ],
                      ),
                    ),
                  ],
                ),


//                child: Table(
//                defaultColumnWidth: FixedColumnWidth(48.0),
//                border: TableBorder.all(color: Colors.grey),
//                children: test(),
//                )
              )
            ],
          )
        ),
      ]);
  }
}
