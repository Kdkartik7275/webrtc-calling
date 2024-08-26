import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:webrtc_chat/core/utils/constants/colors.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'By continuing, I accept ',
        style: Theme.of(context).textTheme.titleSmall,
        children: <TextSpan>[
          TextSpan(
            text: 'Terms & Conditions',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: AppColors.primary),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
          TextSpan(
            text: ' and ',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          TextSpan(
            text: 'Privacy Policy',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: AppColors.primary),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
        ],
      ),
    );
  }
}
