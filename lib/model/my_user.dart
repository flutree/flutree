import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyUser {
  static final FirebaseAuth _authInstance = FirebaseAuth.instance;
  static final FirebaseFirestore _fireInstance = FirebaseFirestore.instance;
  static String profileCode = _authInstance.currentUser!.uid.substring(0, 5);
  static DocumentReference userDocument =
      _fireInstance.collection('users').doc(profileCode);
  static String? imageUrl;

  static void setupInitialDoc() async {
    userDocument.set({
      'creationDate': FieldValue.serverTimestamp(),
      'authUid': _authInstance.currentUser!.uid,
      'dpUrl': _authInstance.currentUser!.photoURL ??
          'https://picsum.photos/seed/$profileCode/200',
      'nickname': _authInstance.currentUser!.displayName,
    });
  }
}
