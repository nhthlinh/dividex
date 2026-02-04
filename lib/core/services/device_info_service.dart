import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:geolocator/geolocator.dart';

class DeviceInfoService {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  static Map<String, dynamic>? _cache;

  static Future<Map<String, dynamic>> getDeviceInfo({
    bool includeLocation = false,
  }) async {
    if (_cache != null && !includeLocation) return _cache!;

    final packageInfo = await PackageInfo.fromPlatform();

    String platform = 'unknown';
    String model = 'unknown';
    String osVersion = 'unknown';
    String deviceId = 'unknown';

    // ===== PLATFORM SAFE CHECK =====
    if (kIsWeb) {
      final web = await _deviceInfo.webBrowserInfo;
      platform = 'web';
      model = web.browserName.name;
      osVersion = web.userAgent ?? 'unknown';
    } else {
      final target = defaultTargetPlatform;

      if (target == TargetPlatform.android) {
        final android = await _deviceInfo.androidInfo;
        platform = 'android';
        model = android.model;
        osVersion = 'Android ${android.version.release}';
        deviceId = android.id;
      } else if (target == TargetPlatform.iOS) {
        final ios = await _deviceInfo.iosInfo;
        platform = 'ios';
        model = ios.utsname.machine;
        osVersion = 'iOS ${ios.systemVersion}';
        deviceId = ios.identifierForVendor ?? 'unknown';
      }
    } 

    Map<String, dynamic>? location;

    // ===== LOCATION (OPTIONAL) =====
    if (includeLocation && !kIsWeb) {
      location = await _getLocationSafely();
    }

    final result = {
      'platform': platform,
      'device_model': model,
      'os_version': osVersion,
      'app_version': packageInfo.version,
      'device_id': deviceId,
      if (location != null) 'location': location,
    };

    _cache = result;
    return result;
  }

  // =========================
  // LOCATION SAFE HELPER
  // =========================
  static Future<Map<String, double>?> _getLocationSafely() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 5),
      );

      return {
        'lat': position.latitude,
        'lng': position.longitude,
      };
    } catch (_) {
      return null;
    }
  }
}
