import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:healthcare_fraud_detection/components/custom_text_field.dart';
import 'package:healthcare_fraud_detection/screens/admin_home_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  static const String id = 'admin_login_screen';

  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  GlobalKey<FormState> _key = GlobalKey();
  bool _validate = false;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  String userName, password;

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: NeumorphicAppBar(
          centerTitle: true,
          padding: 15.0,
          buttonStyle: NeumorphicStyle(
            boxShape: NeumorphicBoxShape.circle(),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'Sign In',
            style: TextStyle(color: Colors.black, fontSize: 30.0),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              autovalidate: _validate,
              child: Neumorphic(
                margin: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 15.0),
                style: NeumorphicStyle(
                  depth: 5,
                  intensity: 1,
                  shape: NeumorphicShape.concave,
                  lightSource: LightSource.topLeft,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 15.0),
                  width: double.infinity,
                  // height: 500,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: NeumorphicText(
                          'Admin',
                          style: NeumorphicStyle(
                            depth: 10,
                            color: Color(0xff1CB542),
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextField(
                            hintText: 'Username',
                            controller: _userNameController,
                            onSaved: (String val) {
                              userName = val;
                            },
                            validator: (String value) {
                              String testUser = 'admin';
                              if (value.length == 0) {
                                return "*Required";
                              } else if (value != testUser) {
                                return "User Doesn\'t exist";
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                          ),
                          CustomTextField(
                            hintText: 'Password',
                            obscureText: true,
                            controller: _passwordController,
                            onSaved: (String val) {
                              password = val;
                            },
                            validator: (String value) {
                              String testPassword = 'admin';
                              if (value.length == 0) {
                                return "*Required";
                              } else if (value != testPassword) {
                                return "User Doesn\'t exist";
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.done,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Username: admin, Password: admin',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: GestureDetector(
                          onTap: _formValidator,
                          child: Neumorphic(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            drawSurfaceAboveChild: true,
                            style: NeumorphicStyle(
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(25.0)),
                              depth: 10,
                              border: NeumorphicBorder(color: Colors.black87),
                              intensity: 1,
                              color: Color(0xff1CB542),
                              // lightSource: LightSource.topLeft,
                              shape: NeumorphicShape.concave,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 25.0),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 25.0,
                                ),
                              ),
                            ),
                          ),
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

  _formValidator() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      Navigator.pushReplacementNamed(context, AdminHomeScreen.id);
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}
