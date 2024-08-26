import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webrtc_chat/core/components/errors/exceptions/firebase_exceptions.dart';
import 'package:webrtc_chat/core/components/errors/exceptions/format_exceptions.dart';
import 'package:webrtc_chat/core/components/models/user.dart';

class UserServices {
  final _db = FirebaseFirestore.instance;

  Future<void> saveUserInfo(UserModel newUser) async {
    try {
      await _db.collection('Users').doc(newUser.id).set(newUser.toMap());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<void> updateUserInfo(String userId, Map<String, dynamic> data) async {
    try {
      await _db.collection('Users').doc(userId).update(data);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<UserModel> fetchUserByID(String userId) async {
    try {
      final userRef = await _db.collection('Users').doc(userId).get();

      return UserModel.fromMap(userRef.data()!);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final usersRef = await _db.collection('Users').get();

      return usersRef.docs
          .map((user) => UserModel.fromMap(user.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }
}
