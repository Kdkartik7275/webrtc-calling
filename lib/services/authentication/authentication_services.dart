import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:webrtc_chat/core/components/errors/exceptions/firebase_auth_exceptions.dart';
import 'package:webrtc_chat/core/components/errors/exceptions/firebase_exceptions.dart';
import 'package:webrtc_chat/core/components/errors/exceptions/format_exceptions.dart';

class AuthenticationServices {
  final _auth = FirebaseAuth.instance;

  Future<String> sendCodeToPhoneNumber(String phoneNumber) async {
    Completer<String> completer = Completer();
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            throw TFirebaseAuthException(e.code).message;
          },
          codeSent: (String verificationId, int? resendToken) {
            completer.complete(verificationId);
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            completer.complete(verificationId);
          },
          timeout: const Duration(seconds: 30));
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
    return completer.future;
  }

  Future<UserCredential> verifyCode(
      String verificationId, String smsCode) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }
}
