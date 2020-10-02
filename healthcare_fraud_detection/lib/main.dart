import 'package:flutter/material.dart';
import 'package:healthcare_fraud_detection/screens/admin_home_screen.dart';
import 'package:healthcare_fraud_detection/screens/admin_login_screen.dart';
import 'package:healthcare_fraud_detection/screens/claimform_screen.dart';
import 'package:healthcare_fraud_detection/screens/home_screen.dart';
import 'package:healthcare_fraud_detection/screens/info_screen.dart';
import 'package:healthcare_fraud_detection/screens/login_screen.dart';
import 'package:healthcare_fraud_detection/screens/signup_screen.dart';
import 'package:healthcare_fraud_detection/screens/welcome_screen.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  runApp(email == null
      ? FraudDetection()
      : NeumorphicApp(
          title: 'Healthcare Claims Fraud Detection',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
          theme: NeumorphicThemeData(
            baseColor: Colors.white.withOpacity(0.9),
            lightSource: LightSource.topLeft,
            depth: 10,
          ),
          initialRoute: HomeScreen.id,
          routes: {
            WelcomeScreen.id: (context) => WelcomeScreen(),
            LoginScreen.id: (context) => LoginScreen(),
            SignUpScreen.id: (context) => SignUpScreen(),
            HomeScreen.id: (context) => HomeScreen(),
            ClaimFormScreen.id: (context) => ClaimFormScreen(),
            AdminLoginScreen.id: (context) => AdminLoginScreen(),
            AdminHomeScreen.id: (context) => AdminHomeScreen(),
            InfoScreen.id: (context) => InfoScreen(),
          },
          home: HomeScreen()));
}

class FraudDetection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      title: 'Healthcare Claims Fraud Detection',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: NeumorphicThemeData(
        baseColor: Colors.white.withOpacity(0.9),
        lightSource: LightSource.topLeft,
        depth: 10,
      ),
      darkTheme: NeumorphicThemeData(
        baseColor: Colors.blueGrey[900],
        lightSource: LightSource.topLeft,
        depth: 5,
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        SignUpScreen.id: (context) => SignUpScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        ClaimFormScreen.id: (context) => ClaimFormScreen(),
        AdminLoginScreen.id: (context) => AdminLoginScreen(),
        AdminHomeScreen.id: (context) => AdminHomeScreen(),
        InfoScreen.id: (context) => InfoScreen(),
      },
    );
  }
}
