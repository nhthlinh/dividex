// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
 
// final GoogleSignIn _googleSignIn = GoogleSignIn();
// final FirebaseAuth _auth = FirebaseAuth.instance;

// Future<UserCredential?> signInWithGoogle() async {
//   try {
//     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//     if (googleUser == null) {
//       return null; // The user canceled the sign-in
//     }

//     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//     final AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken ?? googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );

//     return await _auth.signInWithCredential(credential);
//   } catch (e) {
//     debugPrint(e.toString());
//     return null;
//   }
// }