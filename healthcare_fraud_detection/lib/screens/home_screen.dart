import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:healthcare_fraud_detection/components/user.dart';
import 'package:healthcare_fraud_detection/screens/claimform_screen.dart';
import 'package:healthcare_fraud_detection/screens/info_screen.dart';
import 'package:healthcare_fraud_detection/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map data;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchData();
  }

  void getCurrentUser() async {
    try {
      var addedUser = await FireBase().fireBaseInstance.currentUser();
      FireBase()
          .fireStoreInstance
          .collection("users")
          .document(addedUser.uid)
          .get()
          .then((value) => print(value.data));
    } catch (e) {
      print(e);
    }
  }

  fetchData() async {
    try {
      var addedUser = await FireBase().fireBaseInstance.currentUser();
      DocumentReference documentReference = FireBase()
          .fireStoreInstance
          .collection("users")
          .document(addedUser.uid);
      documentReference.snapshots().listen((event) {
        if (this.mounted) {
          setState(() {
            data = event.data;
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Do you really want to exit the app?'),
              actions: [
                FlatButton(
                  child: Text(
                    'No',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                  child: Text(
                    'Yes',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> drawerKey = GlobalKey();
    return SafeArea(
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          key: drawerKey,
          drawer: Drawer(
            child: ListView(
              padding: const EdgeInsets.all(0.0),
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueGrey[900].withOpacity(.8),
                        Colors.blueGrey[900].withOpacity(.6),
                        Colors.blueGrey[900].withOpacity(.4),
                      ],
                    ),
                  ),
                  accountName: (data != null)
                      ? Text(
                          '${data['firstName'].toString().toUpperCase()} ${data['lastName'].toString().toUpperCase()}',
                          style: TextStyle(fontSize: 18.0),
                        )
                      : Text(''),
                  accountEmail: (data != null)
                      ? Text(
                          data['email'].toString(),
                          style: TextStyle(fontSize: 15.0),
                        )
                      : Text(''),
                  currentAccountPicture: Neumorphic(
                    style: NeumorphicStyle(
                      depth: 2.5,
                      // lightSource: LightSource.bottomRight,
                      boxShape: NeumorphicBoxShape.circle(),
                    ),
                    child: (data != null)
                        ? CircleAvatar(
                            backgroundImage: (data['profilePictureURL'] == '')
                                ? AssetImage('assets/images/placeholder.jpg')
                                // ? NetworkImage(data['profilePictureURL'])
                                : NetworkImage(data['profilePictureURL']),
                          )
                        : CircularProgressIndicator(),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.black87,
                  ),
                  title: Text('Home'),
                  trailing: Icon(
                    Icons.arrow_right,
                    color: Colors.black54,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.info,
                    color: Colors.black87,
                  ),
                  title: Text('Info'),
                  trailing: Icon(
                    Icons.arrow_right,
                    color: Colors.black54,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, InfoScreen.id);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.power_settings_new,
                    color: Colors.black87,
                  ),
                  title: Text('Logout'),
                  trailing: Icon(
                    Icons.arrow_right,
                    color: Colors.black54,
                  ),
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('email');
                    FireBase().fireBaseInstance.signOut();
                    Navigator.pushReplacementNamed(context, WelcomeScreen.id);
                  },
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 5.0),
                  height: 230,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/banner.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.view_headline,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            drawerKey.currentState.openDrawer();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, top: 12.0),
                          child: (data != null)
                              ? Text(
                                  'Hi ${data['firstName'].toString().toUpperCase()}!',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.0,
                                  ),
                                )
                              : Text(''),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ClaimFormScreen.id);
                  },
                  child: Container(
                    height: 240,
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.92),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[800],
                                blurRadius: 30,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          margin: const EdgeInsets.only(top: 50),
                        ),
                        Align(
                          child: Image.asset('assets/images/agreement.png'),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Claim Insurance Policy',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.deepPurple[900],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 250,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
