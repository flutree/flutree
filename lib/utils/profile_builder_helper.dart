import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileBuilderHelper {
  /// Allows pick/capture image, upload to Storage bucket, and returns `url`.
  static Future<String?> updateProfilePicture(ImageSource source) async {
    FirebaseAuth _authInstance = FirebaseAuth.instance;
    FirebaseStorage _storageInstance = FirebaseStorage.instance;
    XFile? pickedFile;

    pickedFile = await ImagePicker().pickImage(
        source: source, imageQuality: 70, maxWidth: 300, maxHeight: 200);

    if (pickedFile == null) return null;

    File _image = File(pickedFile.path);
    String url;
    Reference reference =
        _storageInstance.ref('userdps').child(_authInstance.currentUser!.uid);

    // if already exist, it will be overwritten
    await reference.putFile(_image);
    url = await reference.getDownloadURL();

    return url;
  }
}
