import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:healthcare_fraud_detection/components/custom_text_field.dart';
import 'package:confetti/confetti.dart';
import 'package:healthcare_fraud_detection/components/user.dart';
import 'package:healthcare_fraud_detection/screens/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

// var _isSelected = false;
String policyNumber;

class ClaimFormScreen extends StatefulWidget {
  static const String id = 'claimform_screen';

  @override
  _ClaimFormScreenState createState() => _ClaimFormScreenState();
}

class _ClaimFormScreenState extends State<ClaimFormScreen> {
  GlobalKey<FormState> _key = GlobalKey();
  TextEditingController _insuranceClaimAmountController =
      TextEditingController();
  TextEditingController _ipAnnualReimbursementController =
      TextEditingController();
  TextEditingController _opAnnualReimbursementController =
      TextEditingController();
  TextEditingController _policyNumberController = TextEditingController();
  ConfettiController _controllerCenter;
  bool _pending = false;
  DateTime pickedDate;
  var age = 0;
  var numberOfDisease = 0;
  var isSelectedHeartFailure = false;
  var isSelectedAlzheimer = false;
  var isSelectedKidneyDisease = false;
  var isSelectedCancer = false;
  var isSelectedObstructivePulmonary = false;
  var isSelectedDepression = false;
  var isSelectedDiabetes = false;
  var isSelectedIschemicHeart = false;
  var isSelectedOsteoporosis = false;
  var isSelectedRheumatoidArthritis = false;
  var isSelectedStroke = false;

  var insuranceClaimAmount = 0;
  var ipAnnualReimbursementAmt = 0;
  var opAnnualReimbursementAmt = 0;

  bool patientOut = false;
  bool _validate = false;
  bool showSpinner = false;

  @override
  void initState() {
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 1));
    super.initState();
    pickedDate = DateTime.now();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    _insuranceClaimAmountController.dispose();
    _ipAnnualReimbursementController.dispose();
    _opAnnualReimbursementController.dispose();
    _policyNumberController.dispose();
    super.dispose();
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        pickedDate = date;
        age = DateTime.now().year - pickedDate.year;
      });
      print(age);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: NeumorphicAppBar(
          centerTitle: true,
          buttonStyle: NeumorphicStyle(
            boxShape: NeumorphicBoxShape.circle(),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'Fill Details',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Form(
            key: _key,
            autovalidate: _validate,
            child: Neumorphic(
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
              style: NeumorphicStyle(
                depth: 10,
                intensity: 1,
                shape: NeumorphicShape.convex,
                lightSource: LightSource.topLeft,
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 15.0),
                  width: double.infinity,
                  // height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextField(
                        hintText: 'Policy No.',
                        controller: _policyNumberController,
                        onSaved: (String val) {
                          policyNumber = val;
                        },
                        textInputAction: TextInputAction.done,
                        validator: (val) =>
                            val.length == 0 ? '*Required' : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Neumorphic(
                          margin: const EdgeInsets.symmetric(horizontal: 20.0),
                          drawSurfaceAboveChild: true,
                          style: NeumorphicStyle(
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(25.0)),
                            depth: 10,
                            border: NeumorphicBorder(color: Colors.black87),
                            intensity: 1,
                            // lightSource: LightSource.topLeft,
                            shape: NeumorphicShape.concave,
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: (BorderRadius.circular(25.0)),
                            ),
                            title: Text(
                              "DOB: ${pickedDate.day}/${pickedDate.month}/${pickedDate.year}",
                              textAlign: TextAlign.start,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            leading: Icon(Icons.date_range),
                            trailing: Icon(Icons.arrow_drop_down),
                            onTap: _pickDate,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Neumorphic(
                          padding: const EdgeInsets.all(10.0),
                          margin: const EdgeInsets.symmetric(horizontal: 20.0),
                          drawSurfaceAboveChild: true,
                          style: NeumorphicStyle(
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(25.0)),
                            depth: 10,
                            border: NeumorphicBorder(color: Colors.black87),
                            intensity: 1,
                            // lightSource: LightSource.topLeft,
                            shape: NeumorphicShape.concave,
                          ),
                          child: Wrap(
                            spacing: 5.0,
                            runSpacing: 3.0,
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  'Select the diseases',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                              CustomChipWidget(
                                chipName: 'Heart Failure',
                                selected: isSelectedHeartFailure,
                                onSelected: (isSelected) {
                                  setState(() {
                                    isSelectedHeartFailure = isSelected;
                                    if (isSelected) {
                                      numberOfDisease++;
                                    } else {
                                      numberOfDisease--;
                                    }
                                  });
                                },
                              ),
                              CustomChipWidget(
                                chipName: 'Cancer',
                                selected: isSelectedCancer,
                                onSelected: (isSelected) {
                                  setState(() {
                                    isSelectedCancer = isSelected;
                                    if (isSelected) {
                                      numberOfDisease++;
                                    } else {
                                      numberOfDisease--;
                                    }
                                  });
                                },
                              ),
                              CustomChipWidget(
                                chipName: 'Alzheimer',
                                selected: isSelectedAlzheimer,
                                onSelected: (isSelected) {
                                  setState(() {
                                    isSelectedAlzheimer = isSelected;
                                    if (isSelected) {
                                      numberOfDisease++;
                                    } else {
                                      numberOfDisease--;
                                    }
                                  });
                                },
                              ),
                              CustomChipWidget(
                                chipName: 'Kidney Disease',
                                selected: isSelectedKidneyDisease,
                                onSelected: (isSelected) {
                                  setState(() {
                                    isSelectedKidneyDisease = isSelected;
                                    if (isSelected) {
                                      numberOfDisease++;
                                    } else {
                                      numberOfDisease--;
                                    }
                                  });
                                },
                              ),
                              CustomChipWidget(
                                chipName: 'Obstructive Pulmonary',
                                selected: isSelectedObstructivePulmonary,
                                onSelected: (isSelected) {
                                  setState(() {
                                    isSelectedObstructivePulmonary = isSelected;
                                    if (isSelected) {
                                      numberOfDisease++;
                                    } else {
                                      numberOfDisease--;
                                    }
                                  });
                                },
                              ),
                              CustomChipWidget(
                                chipName: 'Depression',
                                selected: isSelectedDepression,
                                onSelected: (isSelected) {
                                  setState(() {
                                    isSelectedDepression = isSelected;
                                    if (isSelected) {
                                      numberOfDisease++;
                                    } else {
                                      numberOfDisease--;
                                    }
                                  });
                                },
                              ),
                              CustomChipWidget(
                                chipName: 'Diabetes',
                                selected: isSelectedDiabetes,
                                onSelected: (isSelected) {
                                  setState(() {
                                    isSelectedDiabetes = isSelected;
                                    if (isSelected) {
                                      numberOfDisease++;
                                    } else {
                                      numberOfDisease--;
                                    }
                                  });
                                },
                              ),
                              CustomChipWidget(
                                chipName: 'Stroke',
                                selected: isSelectedStroke,
                                onSelected: (isSelected) {
                                  setState(() {
                                    isSelectedStroke = isSelected;
                                    if (isSelected) {
                                      numberOfDisease++;
                                    } else {
                                      numberOfDisease--;
                                    }
                                  });
                                },
                              ),
                              CustomChipWidget(
                                chipName: 'Ischemic Heart Disease',
                                selected: isSelectedIschemicHeart,
                                onSelected: (isSelected) {
                                  setState(() {
                                    isSelectedIschemicHeart = isSelected;
                                    if (isSelected) {
                                      numberOfDisease++;
                                    } else {
                                      numberOfDisease--;
                                    }
                                  });
                                },
                              ),
                              CustomChipWidget(
                                chipName: 'Osteoporosis',
                                selected: isSelectedOsteoporosis,
                                onSelected: (isSelected) {
                                  setState(() {
                                    isSelectedOsteoporosis = isSelected;
                                    if (isSelected) {
                                      numberOfDisease++;
                                    } else {
                                      numberOfDisease--;
                                    }
                                  });
                                },
                              ),
                              CustomChipWidget(
                                chipName: 'Rheumatoid Arthritis',
                                selected: isSelectedRheumatoidArthritis,
                                onSelected: (isSelected) {
                                  setState(() {
                                    isSelectedRheumatoidArthritis = isSelected;
                                    if (isSelected) {
                                      numberOfDisease++;
                                    } else {
                                      numberOfDisease--;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      CustomTextField(
                        hintText: 'Insurance Claim Reimburse Amount',
                        controller: _insuranceClaimAmountController,
                        keyboardType: TextInputType.number,
                        validator: (val) =>
                            val.length == 0 ? '*Required' : null,
                        onSaved: (String val) {
                          insuranceClaimAmount = int.parse(val);
                        },
                        textInputAction: TextInputAction.done,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Neumorphic(
                          margin: const EdgeInsets.symmetric(horizontal: 20.0),
                          drawSurfaceAboveChild: true,
                          style: NeumorphicStyle(
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(25.0)),
                            depth: 10,
                            border: NeumorphicBorder(color: Colors.black87),
                            intensity: 1,
                            // lightSource: LightSource.topLeft,
                            shape: NeumorphicShape.concave,
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            title: Text('Out Patient Only'),
                            trailing: NeumorphicSwitch(
                              onChanged: (bool value) {
                                setState(() {
                                  this.patientOut = value;
                                  print(patientOut);
                                });
                              },
                              value: this.patientOut,
                            ),
                          ),
                        ),
                      ),
                      patientOut == false
                          ? CustomTextField(
                              hintText: 'In Patient Annual Reimburse Amount',
                              controller: _ipAnnualReimbursementController,
                              keyboardType: TextInputType.number,
                              validator: (val) =>
                                  val.length == 0 ? '*Required' : null,
                              onSaved: (String val) {
                                ipAnnualReimbursementAmt = int.parse(val);
                              },
                            )
                          : SizedBox(height: 10.0),
                      CustomTextField(
                        hintText: 'Out Patient Annual Reimburse Amount',
                        controller: _opAnnualReimbursementController,
                        keyboardType: TextInputType.number,
                        validator: (val) =>
                            val.length == 0 ? '*Required' : null,
                        onSaved: (String val) {
                          opAnnualReimbursementAmt = int.parse(val);
                        },
                      ),
                      NeumorphicButton(
                        margin: const EdgeInsets.symmetric(vertical: 15.0),
                        onPressed: () {
                          _controllerCenter.play();
                          _sendToServer();
                        },
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.convex,
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> _httpGet(String url) async {
    setState(() {
      this._pending = true;
      this.showSpinner = true;
    });
    try {
      final http.Response response = await http.get(url);
      final parsed = await compute(jsonDecode, response.body);
      print('Parsed Json Object = $parsed');
      setState(() {
        print(response.body);
      });
      var currentUser = await FireBase().fireBaseInstance.currentUser();
      FireBase()
          .fireStoreInstance
          .collection('users')
          .document(currentUser.uid)
          .setData({
        "policyNumber": _policyNumberController.text,
        "status": parsed,
      }, merge: true).whenComplete(() {
        print("success");
      });
      setState(() {
        this.showSpinner = false;
      });

      print(url);
    } catch (e) {
      print(e);
    }
    setState(() {
      this._pending = false;
    });
  }

  _sendToServer() {
    int ChronicCond_Alzheimer = isSelectedAlzheimer ? 1 : 0;
    int ChronicCond_Heartfailure = isSelectedHeartFailure ? 1 : 0;
    int ChronicCond_KidneyDisease = isSelectedKidneyDisease ? 1 : 0;
    int ChronicCond_Cancer = isSelectedCancer ? 1 : 0;
    int ChronicCond_ObstrPulmonary = isSelectedObstructivePulmonary ? 1 : 0;
    int ChronicCond_Depression = isSelectedDepression ? 1 : 0;
    int ChronicCond_Diabetes = isSelectedDiabetes ? 1 : 0;
    int ChronicCond_IschemicHeart = isSelectedIschemicHeart ? 1 : 0;
    int ChronicCond_Osteoporasis = isSelectedOsteoporosis ? 1 : 0;
    int ChronicCond_rheumatoidarthritis = isSelectedRheumatoidArthritis ? 1 : 0;
    int ChronicCond_stroke = isSelectedStroke ? 1 : 0;
    int Patient_IN = patientOut ? 0 : 1;
    if (_key.currentState.validate()) {
      _key.currentState.save();
      if (_pending != null) {
        this._httpGet(
            'https://hfraud.herokuapp.com/api?amt1=${insuranceClaimAmount}&d1=${ChronicCond_Alzheimer}&d2=${ChronicCond_Heartfailure}&d3=${ChronicCond_KidneyDisease}&d4=${ChronicCond_Cancer}&d5=${ChronicCond_ObstrPulmonary}&d6=${ChronicCond_Depression}&d7=${ChronicCond_Diabetes}&d8=${ChronicCond_IschemicHeart}&d9=${ChronicCond_Osteoporasis}&d10=${ChronicCond_rheumatoidarthritis}&d11=${ChronicCond_stroke}&amt2=${ipAnnualReimbursementAmt}&amt3=${opAnnualReimbursementAmt}&age=${age}&patin=${Patient_IN}&nod=${numberOfDisease}');
      }

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              titlePadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
              contentPadding: const EdgeInsets.all(8.0),
              title: Text('Your claim is under process for verification',
                  textAlign: TextAlign.center),
              titleTextStyle: TextStyle(color: Colors.purple, fontSize: 17.0),
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset('assets/images/done-animation.gif'),
                    ConfettiWidget(
                      confettiController: _controllerCenter,
                      blastDirection: pi / 2,
                      shouldLoop: true,
                      blastDirectionality: BlastDirectionality.explosive,
                      numberOfParticles: 20,
                      gravity: 0.5,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, HomeScreen.id);
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(color: Colors.purple, fontSize: 15.0),
                    ),
                  ),
                ),
              ],
            );
          });
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}

class CustomChipWidget extends StatefulWidget {
  final String chipName;
  final bool selected;
  final Function(bool) onSelected;
  CustomChipWidget({this.chipName, this.onSelected, this.selected});

  @override
  _CustomChipWidgetState createState() => _CustomChipWidgetState();
}

class _CustomChipWidgetState extends State<CustomChipWidget> {
  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipName),
      selected: widget.selected,
      onSelected: widget.onSelected,
    );
  }
}
