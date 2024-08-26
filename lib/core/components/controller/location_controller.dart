import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationController extends GetxController {
  GoogleMapController? googleMapController;

  var initialPosition = Rx<CameraPosition?>(null);
  var currentPosition = Rx<LatLng?>(null);
  var locationPermissionGranted = false.obs;
  var loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    try {
      print('fetching');
      loading.value = true;
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        locationPermissionGranted.value = true;
        final location = await Geolocator.getCurrentPosition();
        _updatePosition(LatLng(location.latitude, location.longitude));
      } else {
        locationPermissionGranted.value = false;
        loading.value = false;
      }
    } catch (e) {
      locationPermissionGranted.value = false;
      loading.value = false;
    } finally {
      loading.value = false;
    }
  }

  void _updatePosition(LatLng location) {
    currentPosition.value = location;
    initialPosition.value = CameraPosition(
      target: location,
      zoom: 16.0,
    );
    print(currentPosition.value);
    print(initialPosition.value);
  }
}
