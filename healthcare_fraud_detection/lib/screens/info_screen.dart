import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class InfoScreen extends StatelessWidget {
  static const String id = 'info_screen';
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
            'About',
            style: TextStyle(color: Colors.black, fontSize: 30.0),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
          child: Neumorphic(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
            style: NeumorphicStyle(
              depth: 8,
              intensity: 1,
              shape: NeumorphicShape.convex,
              lightSource: LightSource.topLeft,
            ),
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: NeumorphicText(
                      'Healthcare Claims Fraud Detection',
                      style: NeumorphicStyle(
                        depth: 10,
                        color: Color(0xff1CB542),
                      ),
                      textStyle: NeumorphicTextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Neumorphic(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 16),
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.convex,
                      boxShape: NeumorphicBoxShape.circle(),
                    ),
                    child: Image.asset(
                      'assets/images/healthcare-app-logo.png',
                      height: 100,
                      width: 100,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: [
                        Text(
                          'This application aims to flag healthcare claims based on policy details, process and analyze them using AI to decide if the nature of the claim is false or not. The user can make a claim using the app after registration by logging in and filling the details on the form and admin can retrieve the processed claims whether it is true or false.',
                          maxLines: 10,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 16,
                            height: 1.3,
                            color: Color(0xff384C54),
//                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            'The app is developed using flutter framework.',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontFamily: 'Avenir',
                              fontSize: 15,
                              color: Color(0xff384C54),
//                            fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 15),
                    child: Column(
                      children: [
                        Text(
                          'Created by',
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 20,
                            color: Color(0xff1CB542),
//                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          'Green.io',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
//                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'v1.0.0',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
