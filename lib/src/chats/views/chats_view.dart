import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:webrtc_chat/core/components/containers/circular_container.dart';
import 'package:webrtc_chat/core/components/indicators/circular_progress.dart';
import 'package:webrtc_chat/core/utils/constants/colors.dart';
import 'package:webrtc_chat/src/call/controller/call_controller.dart';
import 'package:webrtc_chat/src/chats/controller/chats_controller.dart';
import 'package:webrtc_chat/src/profile/controller/profile_controller.dart';

class ChatsView extends GetView<ChatsController> {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ChatsController());
    final myUser = Get.find<ProfileController>().user;

    final call = Get.put(CallController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: true,
        title: const Text('CHATS'),
        actions: [
          IconButton(
            onPressed: () => Get.find<ProfileController>().logout(),
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: Obx(
        () => LoadingOverlay(
          isLoading: controller.loading.value,
          progressIndicator: circularProgress(context),
          child: ListView.builder(
            itemCount: controller.users.value.length,
            itemBuilder: (context, index) {
              final user = controller.users.value[index];
              return user.id == myUser!.id
                  ? const SizedBox()
                  : ListTile(
                      minTileHeight: 50.h,
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        backgroundImage: user.profileURl.isNotEmpty
                            ? NetworkImage(user.profileURl)
                            : null,
                        child: user.profileURl.isEmpty
                            ? Center(
                                child: Text(user.username[0].toUpperCase()),
                              )
                            : const SizedBox(),
                      ),
                      title: Text(user.username,
                          style: Theme.of(context).textTheme.titleMedium),
                      trailing: TCircularContainer(
                        height: 40.h,
                        width: 40.w,
                        backgroundColor: AppColors.primary.withOpacity(0.5),
                        child: IconButton(
                          onPressed: () {
                            call.makeCall(myUser.id, user.id);
                          },
                          icon: const Icon(Icons.video_call_outlined,
                              color: AppColors.white),
                        ),
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
