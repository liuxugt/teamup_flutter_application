import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/onboarding_model.dart';

class AvailabilityInfoTab extends StatefulWidget {
  @override
  _AvailabilityInfoTabState createState() => _AvailabilityInfoTabState();
}

class _AvailabilityInfoTabState extends State<AvailabilityInfoTab> {
  List<bool> _availabilities;

  final hours = 16;
  final days = 7;

  @override
  void initState() {
    _availabilities = new List(hours * days);
    super.initState();
  }

  List<List<int>> someListsOfNumbers = [
    List.generate(4, (int idx) => idx),
    List.generate(4, (int idx) => idx + 4),
    List.generate(4, (int idx) => idx + 8),
  ];

  List<List<bool>> test = List.filled(7, List.filled(12, false));



  Map<int, bool> pressedValues = Map.fromIterable(
    List.generate(12, (int idx) => idx),
    key: (item) => item,
    value: (item) => false,
  );

  @override
  Widget build(BuildContext context) {
    print(test.length);
    print(test[0].length);
    print(test[0][0]);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
          child: Table(
            border: TableBorder.all(),
            children: someListsOfNumbers
              .map((List<int> someList) => TableRow(
                children: someList
                  .map((int val) => GestureDetector(
                    onTap: () {
                      setState(() {
                        pressedValues[val] = !pressedValues[val];
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 700),
                      height: 56.0,
                      color: pressedValues[val]
                          ? Colors.red
                          : Colors.green,
                      child: Center(
                        child: pressedValues[val]
                            ? Text(val.toString())
                            : Text(""),
                      ))))
                .toList()))
            .toList())),
        Container(
          height: 32.0,
        )
      ],
    );
  }
}
