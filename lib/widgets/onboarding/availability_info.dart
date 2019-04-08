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

  @override
  void initState() {
    _availabilities = new List<bool>.filled(hours * days, false);
    super.initState();
  }

  List<TableRow> test() {
    List<TableRow> res;
    res = index.map((List<int> hour) => TableRow(
        children: hour.map((int cur) => GestureDetector(
          onTap: () {setState(() {
            _availabilities[cur] = !_availabilities[cur];
            ScopedModel.of<OnboardingModel>(context, rebuildOnChange: false).availabilities = _availabilities;
          });
          },
          child: AnimatedContainer(duration: const Duration(milliseconds: 700),
              height: 32.0,
              color: _availabilities[cur]
                  ? Colors.blue
                  : Colors.white,
              child: Center(
                child: _availabilities[cur]
                    ? Text("X")
                    : Text(""),
              )
          ),
        )).toList()
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
        Container(
          height: 32.0,
          child:Row(children: <Widget>[
            Expanded(
              child: Text('S', textAlign: TextAlign.center),
            ),
            Expanded(
              child: Text('M', textAlign: TextAlign.center),
            ),
            Expanded(
              child: Text('T', textAlign: TextAlign.center),
            ),
            Expanded(
              child: Text('W', textAlign: TextAlign.center),
            ),
            Expanded(
              child: Text('T', textAlign: TextAlign.center),
            ),
            Expanded(
              child: Text('F', textAlign: TextAlign.center),
            ),
            Expanded(
              child: Text('S', textAlign: TextAlign.center),
            ),
          ],)
        ),
        Container(
          child: Table(
            border: TableBorder.all(color: Colors.grey),
              children: test(),
          ),
        ),
//        Container(
//          height: 32.0,
//          child:Row(
//            children: [
////              Expanded(
////                flex: 2, // 20%
////                child: Container(color: Colors.red),
////              ),
//              Expanded(
//                flex: 10, // 60%
//                child: Container(child: Table(
//                  border: TableBorder.all(color: Colors.grey),
//                  children: test(),
//                ),
//                ),
//              )
//            ]
//          )
//        )
      ]);
  }
}
