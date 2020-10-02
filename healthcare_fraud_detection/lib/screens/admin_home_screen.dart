import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:healthcare_fraud_detection/components/user.dart';

class AdminHomeScreen extends StatefulWidget {
  static const String id = 'admin_home_screen';

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
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
            'Hello Admin!',
            style: TextStyle(color: Colors.black, fontSize: 30.0),
          ),
        ),
        body: Neumorphic(
          margin: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
          style: NeumorphicStyle(
            depth: 8,
            intensity: 1,
            shape: NeumorphicShape.concave,
            lightSource: LightSource.topLeft,
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            width: double.infinity,
            // height: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: NeumorphicText(
                    'Insurance Claims',
                    style: NeumorphicStyle(
                      depth: 10,
                      color: Color(0xff1CB542),
                    ),
                    textStyle: NeumorphicTextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: StreamBuilder(
                    stream: FireBase()
                        .fireStoreInstance
                        .collection('users')
                        .snapshots(),
                    builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              var doc = snapshot.data.documents[index].data;
                              return doc['status'] != null
                                  ? ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                      title: Text(
                                        'Policy No. ${doc['policyNumber']}',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${doc['firstName']} ${doc['lastName']}',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            doc['email'],
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.red[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: doc['status']['isFraud']
                                          ? Container(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                              child: Text(
                                                'Rejected',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                            )
                                          : Container(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                              child: Text(
                                                'Approved',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                            ),
                                    )
                                  : SizedBox(
                                      height: 10,
                                    );
                            });
                      } else
                        return Text('Fetching data from server...');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
