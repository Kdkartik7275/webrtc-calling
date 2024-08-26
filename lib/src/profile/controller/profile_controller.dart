import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webrtc_chat/core/components/models/user.dart';
import 'package:webrtc_chat/core/utils/constants/app_pages.dart';
import 'package:webrtc_chat/core/utils/helpers/functions.dart';
import 'package:webrtc_chat/services/authentication/authentication_services.dart';
import 'package:webrtc_chat/services/storage/storage_service.dart';
import 'package:webrtc_chat/services/user/user_services.dart';

class ProfileController extends GetxController {
  var loading = false.obs;

  var userProfile = Rx<File?>(null);

  final _user = Rx<UserModel?>(null);

  UserModel? get user => _user.value;

  final _services = UserServices();
  final auth = AuthenticationServices();
  final _storage = StorageServices();

  void fetchCurrentUser() async {
    try {
      loading.value = true;

      final user =
          await _services.fetchUserByID(FirebaseAuth.instance.currentUser!.uid);

      _user.value = user;

      loading.value = false;
    } catch (e) {
      loading.value = false;
    }
  }

  void updateUserInfo(String userId, Map<String, dynamic> data) async {
    try {
      loading.value = true;

      await _services.updateUserInfo(userId, data);
    } catch (e) {
      loading.value = false;
    } finally {
      loading.value = false;
    }
  }

  void pickProfileImage() async {
    try {
      final image = await pickImage(camera: true);

      if (image != null) {
        userProfile.value = image;
      }
    } catch (e) {
      loading.value = false;
    } finally {
      loading.value = false;
    }
  }

  void uploadProfileImageToStorage(String userId) async {
    try {
      loading.value = true;

      if (userProfile.value != null) {
        final imageURl = await _storage.uploadFileToStorage(
            file: userProfile.value!, path: 'User/Profile$userId');

        await _services.updateUserInfo(userId, {'profileURl': imageURl});
      }
    } catch (e) {
      loading.value = false;
    } finally {
      loading.value = false;
    }
  }

  void userProfileInit(String userID, String name, String bio) async {
    try {
      loading.value = true;
      String imageURL = '';

      if (name != '') {
        if (userProfile.value != null) {
          imageURL = await _storage.uploadFileToStorage(
              file: userProfile.value!, path: 'User/Profile$userID');
        }

        await _services.updateUserInfo(
            userID, {'profileURl': imageURL, 'username': name, 'bio': bio});
      } else {
        Get.snackbar('Error', 'Name Field is Required',
            backgroundColor: Colors.red);
      }
    } catch (e) {
      loading.value = false;
    } finally {
      loading.value = false;
      Get.offAllNamed(Routes.BOTTOMNAVBAR);
    }
  }

  void logout() async {
    try {
      loading.value = true;
      await auth.logout();
    } catch (e) {
      loading.value = false;
    } finally {
      loading.value = false;
      _user.value = null;
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
