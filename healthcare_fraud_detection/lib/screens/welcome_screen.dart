import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:healthcare_fraud_detection/screens/admin_login_screen.dart';
import 'package:healthcare_fraud_detection/screens/login_screen.dart';
import 'package:healthcare_fraud_detection/screens/signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: NeumorphicText(
                        'Welcome',
                        style: NeumorphicStyle(
                          depth: 10,
                          color: Color(0xff1CB542),
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Neumorphic(
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.concave,
                        boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(10),
                        ),
                        depth: 8,
                        intensity: 1,
                        lightSource: LightSource.topLeft,
                        color: Colors.white.withOpacity(0.90),
                      ),
                      child: Image.asset(
                        'assets/images/Insurance-pana.png',
                      ),
                    ),
                    NeumorphicButton(
                      margin: EdgeInsets.only(top: 46),
                      provideHapticFeedback: true,
                      onPressed: () {
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(10),
                        ),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?',
                            style: TextStyle(fontSize: 18),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, SignUpScreen.id);
                            },
                            child: Text(
                              ' Register here',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xff1CB542),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Or Are you an Admin?',
                            style: TextStyle(fontSize: 18),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, AdminLoginScreen.id);
                            },
                            child: Text(
                              ' Login here!',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
