import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double dropDownValue;
  double pricePackage = 0,
      gramsBrand = 112,
      lbPerRoll = 0,
      lbPerPackage = 0,
      lbFactor = 0,
      pricePerLb = 0,
      priceRounded = 0,
      gramsPerPackage,
      kgPerPackage,
      kgFactor,
      pricePerKg;
  int rollNumber = 4;
  int weightTypeNumber = 0;
  int paperTypeNumber = 0;
  var weightName = 'lb';

  static const Map<String, double> brandRoll = {
    'Amazon Presto! Ultra Soft Mega': 132.92,
    'Charmin Ultra Strong Mega': 122.52,
    'Scott 1000': 163.62,
    'Seventh Generation': 100.44,
    'Target Up & Up 1000': 188.05
  };

  final Map<int, Widget> rollSegmentNumber = const <int, Widget>{
    4: Text('4'),
    6: Text('6'),
    9: Text('9'),
    12: Text('12'),
    18: Text('18'),
    24: Text('24'),
    30: Text('30'),
    36: Text('36'),
    48: Text('48')
  };

  final Map<int, Widget> weightType = const <int, Widget>{
    0: Text('lb'),
    1: Text('kg')
  };

  final Map<int, Widget> paperType = const <int, Widget>{
    0: Text('Toilet Paper'),
    1: Text('Paper Towel')
  };

  void calculateValue() {
    setState(() {
      if (weightTypeNumber == 0) {
        gramsBrand = dropDownValue;
        lbPerRoll = gramsBrand * 0.0022;
        lbPerPackage = rollNumber * lbPerRoll;
        lbFactor = 1 / lbPerPackage;
        pricePerLb = lbFactor * pricePackage;
        priceRounded = double.parse((pricePerLb).toStringAsFixed(2));
        weightName = 'lb';
      } else {
        gramsBrand = dropDownValue;
        gramsPerPackage = rollNumber * gramsBrand;
        kgPerPackage = gramsPerPackage / 1000;
        kgFactor = 1 / kgPerPackage;
        pricePerKg = kgFactor * pricePackage;
        priceRounded = double.parse((pricePerKg).toStringAsFixed(2));
        weightName = 'kg';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text('Find the toilet paper with the best value!')),
        resizeToAvoidBottomPadding: false,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: <Widget>[
            Padding(padding: const EdgeInsets.only(top: (5))),
            Container(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      CupertinoSlidingSegmentedControl(
                        children: weightType,
                        thumbColor: Colors.tealAccent[700],
                        onValueChanged: (int val) {
                          setState(() {
                            weightTypeNumber = val;
                            print('Weight type number $weightTypeNumber');
                          });
                        },
                        groupValue: weightTypeNumber,
                      ),
                      CupertinoSlidingSegmentedControl(
                        children: paperType,
                        thumbColor: Colors.tealAccent[700],
                        onValueChanged: (int val) {
                          setState(() {
                            paperTypeNumber = val;
                            print('Weight type number $paperTypeNumber');
                          });
                        },
                        groupValue: paperTypeNumber,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.fromLTRB(0, 40, 0, 40),
                    child: Text('\$$priceRounded/$weightName',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 60))),
                ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                      value: dropDownValue,
                      icon: Icon(Icons.touch_app),
                      iconSize: 30,
                      iconEnabledColor: Colors.deepOrange[300],
                      hint: Text('Choose toilet paper brand'),
                      isExpanded: true,
                      items: brandRoll
                          .map((brand, weight) {
                            return MapEntry(
                                brand,
                                DropdownMenuItem<double>(
                                  value: weight,
                                  child: Text(brand),
                                ));
                          })
                          .values
                          .toList(),
                      onChanged: (double newValue) {
                        setState(() {
                          dropDownValue = newValue;
                        });
                      }),
                ),
                Padding(padding: const EdgeInsets.only(top: 30)),
                //TextField(textAlign: TextAlign.center,keyboardType: TextInputType.number, onChanged: (val) {rollNumber = double.parse(val);},
                //decoration: InputDecoration(hintText: 'Enter #rolls in package', hintStyle: TextStyle(color: Colors.blueGrey[200]),border: InputBorder.none,enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30),borderSide: BorderSide(color: Colors.black)))),
                Text('Choose # of rolls in package:',
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 15)),
                Padding(padding: const EdgeInsets.only(top: 10)),
                CupertinoSlidingSegmentedControl(
                  children: rollSegmentNumber,
                  thumbColor: Colors.tealAccent[700],
                  onValueChanged: (int val) {
                    setState(() {
                      rollNumber = val;
                    });
                  },
                  groupValue: rollNumber,
                ),
                Padding(padding: const EdgeInsets.only(top: 40)),
                TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    pricePackage = double.parse(val);
                  },
                  decoration: InputDecoration(
                      hintText: 'Enter \$ package',
                      hintStyle: TextStyle(color: Colors.blueGrey[200]),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.black))),
                ),
                Padding(padding: const EdgeInsets.only(top: 70)),
                ButtonTheme(
                  minWidth: 150,
                  height: 50,
                  child: RaisedButton(
                      onPressed: calculateValue,
                      child: Text(
                        'Calculate',
                        style: TextStyle(fontSize: 20),
                      ),
                      textColor: Colors.white,
                      color: Colors.tealAccent[700]),
                )
              ],
            ),
          ]),
        ));
  }
}
