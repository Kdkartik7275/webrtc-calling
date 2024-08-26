import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:webrtc_chat/core/components/controller/location_controller.dart';
import 'package:webrtc_chat/core/components/indicators/circular_progress.dart';
import 'package:webrtc_chat/core/utils/constants/colors.dart';
import 'package:webrtc_chat/src/profile/controller/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = controller.user!;
    final locationController = Get.find<LocationController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: Obx(
          () => LoadingOverlay(
            isLoading: controller.loading.value,
            progressIndicator: circularProgress(context),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 50.r,
                        backgroundColor: AppColors.primary,
                        backgroundImage: user.profileURl.isNotEmpty
                            ? NetworkImage(user.profileURl)
                            : null,
                        child: user.profileURl.isEmpty
                            ? Center(
                                child: Text(
                                  user.username.substring(0, 2).toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(color: AppColors.white),
                                ),
                              )
                            : const SizedBox(),
                      ),
                      SizedBox(width: 15.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.username,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            user.phone,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1),
                          )
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.settings,
                            size: 30,
                          )),
                    ],
                  ),

                  // LOCATION
                  SizedBox(height: 15.w),

                  locationController.loading.value
                      ? circularProgress(context)
                      : locationController.locationPermissionGranted.value
                          ? Expanded(
                              child: GoogleMap(
                                initialCameraPosition:
                                    locationController.initialPosition.value!,
                                myLocationEnabled: true,
                                mapType: MapType.terrain,
                                onMapCreated: (GoogleMapController controller) {
                                  locationController.googleMapController =
                                      controller;
                                },
                                zoomControlsEnabled: false,
                              ),
                            )
                          : TextButton(
                              onPressed: () {
                                locationController.getCurrentLocation();
                              },
                              child: const Text('Enable Location')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
