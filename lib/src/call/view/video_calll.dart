import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:webrtc_chat/core/components/containers/circular_container.dart';
import 'package:webrtc_chat/core/components/containers/rounded_container.dart';
import 'package:webrtc_chat/core/components/models/call.dart';
import 'package:webrtc_chat/core/utils/constants/colors.dart';
import 'package:webrtc_chat/src/call/controller/call_controller.dart';

class VideoCallScreen extends StatelessWidget {
  const VideoCallScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final CallController callController = Get.find<CallController>();

    return Scaffold(
      backgroundColor: AppColors.black,
      body: StreamBuilder(
          stream: callController
              .listenForCallUpdates(callController.currentCall.value!.id),
          builder: (context, AsyncSnapshot<Call?> snapshot) {
            if (snapshot.hasData) {
              final call = snapshot.data!;

              if (call.status == 'ringing') {
                return Stack(
                  children: [
                    RTCVideoView(
                      callController.localRenderer,
                      mirror: true,
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    ),
                    Positioned(
                      bottom: 20.h,
                      right: 0.w,
                      left: 0.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TCircularContainer(
                            height: 50.h,
                            width: 50.w,
                            backgroundColor: Colors.red,
                            child: IconButton(
                              onPressed: () => callController.hangUp(
                                callController.currentCall.value!.callerId,
                                callController.currentCall.value!.receiverId,
                              ),
                              icon: const Icon(
                                Icons.call_end,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 20.w),
                          TCircularContainer(
                            height: 50.h,
                            width: 50.w,
                            backgroundColor: Colors.blue,
                            child: IconButton(
                              onPressed: () => callController.switchCamera(),
                              icon: const Icon(
                                Icons.switch_camera,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else if (call.status == 'inCall') {
                return Stack(
                  children: [
                    RTCVideoView(
                      callController.remoteRenderer,
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    ),
                    Positioned(
                      top: 40.h,
                      left: 10.w,
                      child: TRoundedContainer(
                        height: 150.h,
                        width: 140.w,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.r),
                          child: RTCVideoView(
                            callController.localRenderer,
                            mirror: true,
                            objectFit: RTCVideoViewObjectFit
                                .RTCVideoViewObjectFitCover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20.h,
                      right: 0.w,
                      left: 0.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TCircularContainer(
                            height: 50.h,
                            width: 50.w,
                            backgroundColor: Colors.red,
                            child: IconButton(
                              onPressed: () => callController.hangUp(
                                callController.currentCall.value!.callerId,
                                callController.currentCall.value!.receiverId,
                              ),
                              icon: const Icon(
                                Icons.call_end,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 20.w),
                          TCircularContainer(
                            height: 50.h,
                            width: 50.w,
                            backgroundColor: Colors.blue,
                            child: IconButton(
                              onPressed: () => callController.switchCamera(),
                              icon: const Icon(
                                Icons.switch_camera,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else if (call.status == 'disconnected') {
                return const _CallEnded();
              }
            }
            return const _CallEnded();
          }),
    );
  }
}

class _CallEnded extends StatelessWidget {
  const _CallEnded();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Call Ended',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: AppColors.white),
          ),
          TCircularContainer(
            height: 60.h,
            width: 60.w,
            child: IconButton(
              onPressed: () {
                Get.back();
                if (Get.isDialogOpen ?? false) {
                  Get.back();
                }
              },
              icon: const Icon(
                Icons.close,
                size: 30,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
