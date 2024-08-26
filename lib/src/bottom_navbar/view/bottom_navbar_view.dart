import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webrtc_chat/core/components/controller/location_controller.dart';
import 'package:webrtc_chat/core/components/indicators/circular_progress.dart';
import 'package:webrtc_chat/core/utils/constants/colors.dart';
import 'package:webrtc_chat/core/utils/constants/icons.dart';
import 'package:webrtc_chat/src/bottom_navbar/controller/bottom_navbar_controller.dart';
import 'package:webrtc_chat/src/profile/controller/profile_controller.dart';

class BottomNavbarView extends StatefulWidget {
  const BottomNavbarView({super.key});

  @override
  State<BottomNavbarView> createState() => _BottomNavbarViewState();
}

class _BottomNavbarViewState extends State<BottomNavbarView> {
  final profileController = Get.find<ProfileController>();
  final controller = Get.put(BottomNavBarController());

  @override
  void initState() {
    super.initState();
    profileController.fetchCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(LocationController());

    return Obx(
      () => profileController.loading.value
          ? Scaffold(
              body: Center(
                child: circularProgress(context),
              ),
            )
          : Scaffold(
              body: controller.pages[controller.selectedIndex.value],
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: AppColors.white,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Image.asset(AppIcons.home),
                    activeIcon:
                        Image.asset(AppIcons.home, color: AppColors.primary),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(AppIcons.profile),
                    activeIcon:
                        Image.asset(AppIcons.profile, color: AppColors.primary),
                    label: '',
                  ),
                ],
                currentIndex: controller.selectedIndex.value,
                selectedItemColor: AppColors.primary,
                unselectedItemColor: AppColors.border,
                onTap: (index) => controller.onItemTapped(index),
                elevation: 0,
                type: BottomNavigationBarType.fixed,
              ),
            ),
    );
  }
}
