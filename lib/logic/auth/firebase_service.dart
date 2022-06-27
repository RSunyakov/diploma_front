/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/user/user.dart' as u;

/// Упакованный сервис для связи с Firebase
class FirebaseService {
  //final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  Future<u.User> signInWithGoogle() async {
    try {
      var fbUser = _auth.currentUser;

      if (fbUser != null) {
        return u.User(
            name: NonEmptyString(fbUser.displayName ?? ''),
            // ignore: deprecated_member_use_from_same_package
            deprecatedToken: Token.tagged(fbUser.uid));
      }

      final account = await _googleSignIn.signIn();

      final authentication = await account!.authentication;

    */
/*  final credential = GoogleAuthProvider.credential(
        accessToken: authentication.accessToken,
        idToken: authentication.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);*//*


      fbUser = userCredential.user;

      return u.User(
          name: NonEmptyString(fbUser?.displayName ?? ''),
          // ignore: deprecated_member_use_from_same_package
          deprecatedToken: Token.tagged(fbUser?.uid ?? ''));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
*/
