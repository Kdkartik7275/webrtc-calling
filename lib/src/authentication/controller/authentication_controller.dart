import 'package:country_picker/country_picker.dart';
import 'package:get/get.dart';
import 'package:webrtc_chat/core/components/models/user.dart';
import 'package:webrtc_chat/core/utils/constants/app_pages.dart';
import 'package:webrtc_chat/services/authentication/authentication_services.dart';
import 'package:webrtc_chat/services/user/user_services.dart';

class AuthenticationController extends GetxController {
  var loading = false.obs;

  var emailLogin = true.obs;

  var phone = ''.obs;
  var selectedCountry = Rx<Country>(Country(
      phoneCode: "91",
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "India",
      example: "India",
      displayName: "India",
      displayNameNoCountryCode: "IN",
      e164Key: ""));

  final _services = AuthenticationServices();

  final _userServices = UserServices();
  void sendCodeToPhone() async {
    try {
      loading.value = true;
      final verification = await _services.sendCodeToPhoneNumber(
          '+${selectedCountry.value.phoneCode} ${phone.value}');

      Get.toNamed(Routes.VERIFYCODE, arguments: {
        'phone': '+${selectedCountry.value.phoneCode} ${phone.value}',
        'verificationID': verification
      });
    } catch (e) {
      loading.value = false;
      Get.snackbar('Error', e.toString());
    } finally {
      loading.value = false;
    }
  }

  void verifyCode(String otp, String verificationID) async {
    try {
      loading.value = true;

      final cred = await _services.verifyCode(verificationID, otp);
      if (cred.additionalUserInfo!.isNewUser) {
        // SAVE USER INFO

        await _userServices.saveUserInfo(UserModel(
            id: cred.user!.uid,
            username: '',
            phone: '+${selectedCountry.value.phoneCode} ${phone.value}',
            profileURl: '',
            bio: ''));
        loading.value = false;

        Get.toNamed(Routes.USERINIT);
      } else {
        loading.value = false;
        Get.toNamed(Routes.BOTTOMNAVBAR);
      }
    } catch (e) {
      loading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }
}
