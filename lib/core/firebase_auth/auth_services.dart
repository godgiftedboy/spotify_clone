import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spotify/core/utils.dart';

final authServicesProvider = Provider<AuthServices>((ref) => AuthServices());

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential?> authSignWithGoogle(BuildContext context) async {
    UserCredential? userCredential;
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      userCredential = await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "ERROR_NETWORK_REQUEST_FAILED":
          if (context.mounted) {
            showSnackBar(context, "ERROR_NETWORK_REQUEST_FAILED");
          }
          await GoogleSignIn().signOut();
          break;
        case "ERROR_INVALID_CREDENTIAL":
          if (context.mounted) {
            showSnackBar(
              context,
              "The supplied auth credential is malformed or has expired",
            );
          }
          await GoogleSignIn().signOut();
          break;
        case "user-disabled":
          await GoogleSignIn().signOut();
          if (context.mounted) {
            showSnackBar(
              context,
              "The user account has been disabled by an administrator",
            );
          }
          break;
        case "ERROR_USER_NOT_FOUND":
          await GoogleSignIn().signOut();
          if (context.mounted) {
            showSnackBar(
              context,
              "The user corresponding to the given email does not exist",
            );
          }
          break;
        default:
          await GoogleSignIn().signOut();
          if (context.mounted) {
            showSnackBar(
              context,
              "No internet Connection",
            );
          }
          break;
      }
    }
    return userCredential;
  }

  Future<void> googleSignOut() async {
    await _googleSignIn.signOut();
  }
}
