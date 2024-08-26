import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webrtc_chat/src/chats/views/chats_view.dart';
import 'package:webrtc_chat/src/profile/views/profile_view.dart';

class BottomNavBarController extends GetxController {
  var selectedIndex = 0.obs;

  List<Widget> pages = [
    const ChatsView(),
    const ProfileView(),
  ];

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }
}
