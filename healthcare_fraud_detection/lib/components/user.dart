import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FireBase {
  final fireStoreInstance = Firestore.instance;
  final fireBaseInstance = FirebaseAuth.instance;
  final fireBaseStorageInstance = FirebaseStorage.instance;
  StorageReference storage = FirebaseStorage.instance.ref();

  Future<String> uploadUserImageToFireStorage(File image, String userID) async {
    StorageReference upload = storage.child("profilepic/$userID.png");
    StorageUploadTask uploadTask = upload.putFile(image);
    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    return downloadUrl.toString();
  }
}
