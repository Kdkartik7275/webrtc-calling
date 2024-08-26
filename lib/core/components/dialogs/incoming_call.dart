// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:webrtc_chat/core/components/containers/rounded_container.dart';
import 'package:webrtc_chat/core/components/models/user.dart';
import 'package:webrtc_chat/core/utils/constants/colors.dart';
import 'package:webrtc_chat/src/call/controller/call_controller.dart';

class IncomingCallDialog extends StatelessWidget {
  const IncomingCallDialog({
    super.key,
    required this.caller,
    required this.receiverId,
  });

  final UserModel caller;
  final String receiverId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CallController>();
    return Dialog.fullscreen(
      backgroundColor: AppColors.primary,
      child: Column(
        children: [
          const Spacer(),
          CircleAvatar(
            radius: 100,
            backgroundColor: AppColors.white,
            backgroundImage: caller.profileURl != ''
                ? NetworkImage(caller.profileURl)
                : null,
            child: caller.profileURl == ''
                ? Center(
                    child: Text(caller.username[0].toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(color: AppColors.primary)),
                  )
                : const SizedBox(),
          ),
          SizedBox(height: 10.h),
          Text('${caller.username} IS CALLING ',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: AppColors.white)),
          const Spacer(),
          CallPickup(
            onAccept: () => controller.receiveCall(caller.id, receiverId),
            onDeclined: () =>
                controller.hangUp(caller.id, receiverId, isdeclined: true),
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}

class CallPickup extends StatelessWidget {
  const CallPickup({
    super.key,
    this.onAccept,
    this.onDeclined,
  });
  final Function()? onAccept;
  final Function()? onDeclined;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: onAccept,
          child: TRoundedContainer(
            height: 40.h,
            radius: 30.r,
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                const Icon(
                  Icons.call,
                  size: 30,
                  color: AppColors.white,
                ),
                SizedBox(width: 8.w),
                Text('Accept',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: AppColors.white))
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: onDeclined,
          child: TRoundedContainer(
            height: 40.h,
            radius: 30.r,
            backgroundColor: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                const Icon(
                  Icons.call_end,
                  size: 30,
                  color: AppColors.white,
                ),
                SizedBox(width: 8.w),
                Text('Decline',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: AppColors.white))
              ],
            ),
          ),
        )
      ],
    );
  }
}
