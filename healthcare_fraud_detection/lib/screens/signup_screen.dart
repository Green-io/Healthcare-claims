import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:healthcare_fraud_detection/components/alert_dialog_box.dart';
import 'package:healthcare_fraud_detection/components/custom_text_field.dart';
import 'package:healthcare_fraud_detection/components/user.dart';
import 'package:healthcare_fraud_detection/screens/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = 'signup_screen';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();
  Map<String, dynamic> addUser;
  String firstName, lastName, email, mobile, password, confirmPassword;
  bool _validate = false;
  bool showSpinner = false;
  File _imageFile;
  final _picker = ImagePicker();

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
            'Create New Account',
            style: TextStyle(color: Colors.black, fontSize: 25.0),
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.fromLTRB(14.0, 0, 14.0, 14.0),
              child: Form(
                key: _key,
                autovalidate: _validate,
                child: formUI(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> _pickImageFromGallery() async {
    final PickedFile pickedFile =
        await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      this._imageFile = File(pickedFile.path);
    });
  }

  Future<Null> _pickImageFromCamera() async {
    final PickedFile pickedFile =
        await _picker.getImage(source: ImageSource.camera);
    setState(() {
      this._imageFile = File(pickedFile.path);
    });
  }

  _onCameraClick() {
    final action = CupertinoActionSheet(
      message: Text(
        "Add profile picture",
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text("Choose from gallery"),
          isDefaultAction: false,
          onPressed: () async {
            await _pickImageFromGallery();
            Navigator.pop(context);
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Take a picture"),
          isDestructiveAction: false,
          onPressed: () async {
            await _pickImageFromCamera();
            Navigator.pop(context);
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  // Future<Widget> _getImage(
  //     BuildContext context, String folderName, String imageName) async {
  //   Image image;
  //   await FireStorageService.loadImage(context, folderName, imageName)
  //       .then((value) {
  //     image = Image.network(
  //       value.toString(),
  //       fit: BoxFit.scaleDown,
  //     );
  //   });
  //   return image;
  // }

  Widget formUI() {
    return Column(
      children: [
        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: IconButton(
        //     icon: Icon(
        //       Icons.chevron_left,
        //       size: 40.0,
        //     ),
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 8.0),
        //   child: Align(
        //     alignment: Alignment.topLeft,
        //     child: Text(
        //       'Create New Account',
        //       style: TextStyle(
        //         color: Colors.black,
        //         fontWeight: FontWeight.bold,
        //         fontSize: 25.0,
        //       ),
        //     ),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CircleAvatar(
                radius: 65.0,
                backgroundColor: Colors.grey.shade400,
                child: ClipOval(
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: this._imageFile == null
                        ? Image.asset(
                            'assets/images/placeholder.jpg',
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            this._imageFile,
                            fit: BoxFit.cover,
                          ),
                    // FutureBuilder(
                    //   future: _getImage(context, 'profilepic', 'instadp.jpg'),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.connectionState == ConnectionState.done) {
                    //       return Container(
                    //         child: snapshot.data,
                    //       );
                    //     }
                    //     if (snapshot.connectionState ==
                    //         ConnectionState.waiting) {
                    //       return Container(
                    //         child: CircularProgressIndicator(),
                    //       );
                    //     }
                    //     return Container(
                    //       child: Image.asset(
                    //         'assets/images/placeholder.jpg',
                    //         fit: BoxFit.cover,
                    //       ),
                    //     );
                    //   },
                    // ),
                    // Image.asset(
                    //   'assets/images/placeholder.jpg',
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                ),
              ),
              Positioned(
                left: 80,
                right: 0,
                child: FloatingActionButton(
                  backgroundColor: Color(0xff1CB542).withOpacity(0.6),
                  child: Icon(Icons.camera_alt),
                  mini: true,
                  onPressed: _onCameraClick,
                ),
              )
            ],
          ),
        ),
        CustomTextField(
          hintText: 'First Name',
          onSaved: (String val) {
            firstName = val;
          },
          controller: _firstNameController,
          validator: (val) => val.length == 0 ? '*Required' : null,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
        ),
        CustomTextField(
          hintText: 'Last Name',
          onSaved: (String val) {
            lastName = val;
          },
          controller: _lastNameController,
          validator: (val) => val.length == 0 ? '*Required' : null,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
        ),
        CustomTextField(
          hintText: 'Mobile Number',
          validator: (String value) {
            String pattern = r'(^[0-9]*$)';
            RegExp regExp = RegExp(pattern);
            if (value.length == 0) {
              return "*Required";
            } else if (!regExp.hasMatch(value)) {
              return "Must contain only digits";
            }
            return null;
          },
          controller: _mobileController,
          onSaved: (String val) {
            mobile = val;
          },
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
        ),
        CustomTextField(
          hintText: 'Email Address',
          validator: (String value) {
            Pattern pattern =
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
            RegExp regex = RegExp(pattern);
            if (!regex.hasMatch(value))
              return 'Enter a valid email address';
            else
              return null;
          },
          onSaved: (String val) {
            email = val;
          },
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
        ),
        CustomTextField(
          hintText: 'Password',
          obscureText: true,
          validator: (String value) {
            if (value.length < 6)
              return 'Password must be more than 5 characters';
            else
              return null;
          },
          controller: _passwordController,
          onSaved: (String val) {
            password = val;
          },
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
        ),
        CustomTextField(
          hintText: 'Confirm Password',
          textInputAction: TextInputAction.done,
          validator: (val) {
            if (_passwordController.text != val) {
              return 'Password doesn\'t match';
            } else if (val.length == 0) {
              return '*Required';
            } else {
              return null;
            }
          },
          obscureText: true,
          onSaved: (String val) {
            confirmPassword = val;
          },
          onFieldSubmitted: (_) {
            _sendToServer();
          },
        ),
        NeumorphicButton(
          margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
          provideHapticFeedback: true,
          onPressed: _sendToServer,
          style: NeumorphicStyle(
            depth: 10.0,
            intensity: 1,
            shape: NeumorphicShape.convex,
            boxShape: NeumorphicBoxShape.roundRect(
              BorderRadius.circular(12),
            ),
          ),
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "Sign Up",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20.0,
            ),
          ),
        ),
      ],
    );
  }

  _sendToServer() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      setState(() {
        showSpinner = true;
      });
      // var firebaseUser = await FirebaseAuth.instance.currentUser();
      var profilePicURL = '';

      try {
        final newUser = await FireBase()
            .fireBaseInstance
            .createUserWithEmailAndPassword(email: email, password: password);
        if (newUser != null) {
          Navigator.pushReplacementNamed(context, LoginScreen.id);
        }
        var addedUser = await FireBase().fireBaseInstance.currentUser();
        if (_imageFile != null) {
          profilePicURL = await FireBase()
              .uploadUserImageToFireStorage(_imageFile, addedUser.uid);
        }

        addUser = {
          "firstName": _firstNameController.text,
          "lastName": _lastNameController.text,
          "mobile": _mobileController.text,
          "email": _emailController.text,
          "password": _passwordController.text,
          "profilePictureURL": profilePicURL,
        };
        FireBase()
            .fireStoreInstance
            .collection("users")
            .document(addedUser.uid)
            .setData(addUser)
            .whenComplete(() async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('email', email);
          print("Added to the database");
        });
        setState(() {
          showSpinner = false;
        });
      } catch (e) {
        setState(() {
          showSpinner = false;
        });
        (e as PlatformException).code != 'ERROR_EMAIL_ALREADY_IN_USE'
            ? showAlertDialog(context, 'Failed', 'Couldn\'t sign up')
            : showAlertDialog(context, 'Failed',
                'Email already in use. Please pick another email address');
        print(e.toString());
      }
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

// class FireStorageService extends ChangeNotifier {
//   FireStorageService();
//   static Future<dynamic> loadImage(
//       BuildContext context, String folder, String image) async {
//     return await FirebaseStorage.instance
//         .ref()
//         .child(folder)
//         .child(image)
//         .getDownloadURL();
//   }
// }
