import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:healthcare_fraud_detection/components/alert_dialog_box.dart';
import 'package:healthcare_fraud_detection/components/custom_text_field.dart';
import 'package:healthcare_fraud_detection/components/user.dart';
import 'package:healthcare_fraud_detection/screens/home_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _key = GlobalKey();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _validate = false;
  String email, password;
  // final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: NeumorphicAppBar(
          centerTitle: true,
          color: Colors.transparent,
          buttonStyle: NeumorphicStyle(
            boxShape: NeumorphicBoxShape.circle(),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'Sign In',
            style: TextStyle(color: Colors.black, fontSize: 30.0),
          ),
        ),
        body: Neumorphic(
          margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          style: NeumorphicStyle(
            depth: 8,
            intensity: 1,
            shape: NeumorphicShape.concave,
            lightSource: LightSource.topLeft,
          ),
          child: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/healthcare-banner1.png'),
                colorFilter: ColorFilter.mode(
                    Colors.grey.withOpacity(0.15), BlendMode.dstATop),
                fit: BoxFit.fitHeight,
              ),
            ),
            child: ModalProgressHUD(
              inAsyncCall: showSpinner,
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _key,
                    autovalidate: _validate,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.only(top: 8.0),
                        //       child: IconButton(
                        //         icon: Icon(
                        //           Icons.chevron_left,
                        //           size: 40,
                        //         ),
                        //         onPressed: () {
                        //           Navigator.pop(context);
                        //         },
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.symmetric(horizontal: 21.0),
                        //       child: Text(
                        //         'Sign In',
                        //         style: TextStyle(
                        //           fontSize: 35.0,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(
                        //   height: 100.0,
                        // ),
                        CustomTextField(
                          hintText: 'example@live.com',
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (String val) {
                            email = val;
                          },
                          controller: _emailController,
                          validator: (String value) {
                            Pattern pattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regex = RegExp(pattern);
                            if (!regex.hasMatch(value))
                              return 'Enter a valid email address';
                            else
                              return null;
                          },
                          prefixIcon: Icon(Icons.email, color: Colors.grey),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        CustomTextField(
                          hintText: '********',
                          obscureText: true,
                          onSaved: (String val) {
                            password = val;
                          },
                          validator: (String value) {
                            if (value.length < 6)
                              return 'Password must be more than 5 characters';
                            else
                              return null;
                          },
                          controller: _passwordController,
                          textInputAction: TextInputAction.done,
                          prefixIcon: Icon(Icons.lock, color: Colors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: InkWell(
                            onTap: () {},
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                        NeumorphicButton(
                          margin: EdgeInsets.only(top: 15, bottom: 15),
                          provideHapticFeedback: true,
                          onPressed: () async {
                            if (_key.currentState.validate()) {
                              _key.currentState.save();
                              setState(() {
                                showSpinner = true;
                              });
                              try {
                                final oldUser = await FireBase()
                                    .fireBaseInstance
                                    .signInWithEmailAndPassword(
                                        email: _emailController.text.trim(),
                                        password:
                                            _passwordController.text.trim());
                                if (oldUser != null) {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString('email', email);
                                  Navigator.pushReplacementNamed(
                                      context, HomeScreen.id);
                                }
                                setState(() {
                                  showSpinner = false;
                                });
                              } catch (e) {
                                setState(() {
                                  showSpinner = false;
                                });
                                switch ((e as PlatformException).code) {
                                  case 'ERROR_INVALID_EMAIL':
                                    showAlertDialog(context, 'Error',
                                        'Email address is malformed.');
                                    break;
                                  case 'ERROR_WRONG_PASSWORD':
                                    showAlertDialog(context, 'Error',
                                        'Password does not match. Please type in the correct password.');
                                    break;
                                  case 'ERROR_USER_NOT_FOUND':
                                    showAlertDialog(context, 'Error',
                                        'No user corresponding to the given email address. Please register first.');
                                    break;
                                  case 'ERROR_USER_DISABLED':
                                    showAlertDialog(context, 'Error',
                                        'This user has been disabled');
                                    break;
                                  case 'ERROR_TOO_MANY_REQUESTS':
                                    showAlertDialog(context, 'Error',
                                        'There were too many attempts to sign in as this user.');
                                    break;
                                  case 'ERROR_OPERATION_NOT_ALLOWED':
                                    showAlertDialog(context, 'Error',
                                        'Email & Password accounts are not enabled');
                                    break;
                                }
                                print(e.toString());
                                return null;
                              }
                            } else {
                              setState(() {
                                _validate = true;
                              });
                            }
                          },
                          style: NeumorphicStyle(
                            depth: 5.0,
                            intensity: 1,
                            shape: NeumorphicShape.convex,
                            boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(12),
                            ),
                          ),
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 25.0,
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
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
