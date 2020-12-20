import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

import 'package:calculator_app/ad_manager.dart';

import 'package:admob_flutter/admob_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final advert = AdManager();

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
    'Charmin Essentials Mega 2-ply 352 sheets': 132.29,
    'Scott 1000': 163.62,
    'Seventh Generation': 100.44,
    'Target Up & Up 1000': 188.05
  };

  static const Map<String, double> paperTest = {
    'Bounty Essentials 2-ply 40 sheets': 128.09,
    'Scott Double 1-ply 110 sheets': 173.56,
    'Seventh Generation 2-ply 140 sheets': 244.95
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

  Map dropDownMap = brandRoll;

  var _controller = TextEditingController();

  void calculateValue() {
    if (dropDownValue == null) {
    } else {
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
  }

  void reset() {
    setState(() {
      dropDownValue = null;
      rollNumber = 4;
      pricePackage = 0;
      priceRounded = 0;
      _controller.clear();
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus.unfocus();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Admob.initialize(testDeviceIds: [AdManager.getappId()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Find the best value!')),
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
                            calculateValue();
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
                            dropDownValue = null;
                            rollNumber = 4;
                            pricePackage = 0;
                            priceRounded = 0;
                            _controller.clear();
                            if (val == 0) {
                              dropDownMap = brandRoll;
                            } else {
                              dropDownMap = paperTest;
                            }
                            calculateValue();
                          });
                        },
                        groupValue: paperTypeNumber,
                      ),
                      RaisedButton(
                          child: Text("Reset"),
                          color: Colors.white,
                          textColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.black54)),
                          onPressed: () => reset())
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
                      hint: Text('Tap here to choose a brand'),
                      isExpanded: true,
                      items: dropDownMap
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
                          calculateValue();
                        });
                      }),
                ),
                Padding(padding: const EdgeInsets.only(top: 30)),
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
                      calculateValue();
                    });
                  },
                  groupValue: rollNumber,
                ),
                Padding(padding: const EdgeInsets.only(top: 10)),
                TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: _controller,
                  onChanged: (val) {
                    pricePackage = double.parse(val);
                    calculateValue();
                  },
                  decoration: InputDecoration(
                      hintText: 'Enter \$ package',
                      hintStyle: TextStyle(color: Colors.blueGrey[200]),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.black))),
                ),
                AdmobBanner(
                    adUnitId: AdManager.getbannerAdUnitId(),
                    adSize: AdmobBannerSize.LARGE_BANNER),
              ],
            ),
          ]),
        ));
  }
}
