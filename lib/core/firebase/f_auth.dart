import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:tamirci/locale_keys.dart';

final class FAuth {
  const FAuth._();

  static Future<String?> _function(Future function) async {
    try {
      await function;

      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return "error";
    }
  }

  static Future<String?> signUp(String email, String password) async {
    return await _function(FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    ));
  }

  static Future<String?> logIn(String email, String password) async {
    return await _function(FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password));
  }

  static Future<String?> signOut() async {
    return await _function(FirebaseAuth.instance.signOut());
  }

  static Future<String?> forgetPass(String email) async {
    final fun = FirebaseAuth.instance.sendPasswordResetEmail(email: email);

    return _function(fun);
  }

  static Future<String?> changeLanguage(String code) async {
    return await _function(
        FirebaseAuth.instance.setLanguageCode(code.toLowerCase()));
  }

  static Future<String?> reAuth(String email, String pass) async {
    final u = FirebaseAuth.instance.currentUser;
    if (u == null) return null;

    final credential = EmailAuthProvider.credential(
        email: email.trim(), password: pass.trim());

    final fun = u.reauthenticateWithCredential(credential);

    return await _function(fun);
  }

  static Future<String?> sendVerification() async {
    final f = FirebaseAuth.instance.currentUser?.sendEmailVerification();

    return await _function(f!);
  }

  static String errorLocal(String code) {
    if (kDebugMode) {
      print(code);
    }
    switch (code) {
      case "invalid-credential":
        return LocaleKeys.wrongCredentials;
      case "invalid-email":
        return LocaleKeys.invalidEmail;
      default:
        return "Error";
    }
  }

  static bool get isLoggedIn {
    return FirebaseAuth.instance.currentUser != null;
  }

  static User get user {
    return FirebaseAuth.instance.currentUser!;
  }

  static String get uid {
    // if (kDebugMode) {
    //   return "ehFYZX6DHubIDrSrosmSQlIUfMw1";
    // }
    return user.uid;
  }

  static Future<bool> isEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    return user.emailVerified;
  }
}
