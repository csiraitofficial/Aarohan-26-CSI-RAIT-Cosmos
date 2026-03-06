import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'api_service.dart';

class SpikeAlertService {
  static const int spikeThreshold = 100; // BPM

  static bool _alertSentThisSession = false;

  /// Check if heart rate is a spike and alert emergency contacts + doctor via SMS with GPS location.
  static Future<void> checkAndAlert({
    required int heartRate,
    required String patientId,
    required String emergencyContact,
    required String doctorContact,
    required String patientName,
  }) async {
    if (heartRate <= spikeThreshold || _alertSentThisSession) return;

    _alertSentThisSession = true;

    // Get GPS coordinates
    double lat = 0.0, lng = 0.0;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission perm = await Geolocator.checkPermission();
        if (perm == LocationPermission.denied) {
          perm = await Geolocator.requestPermission();
        }
        if (perm != LocationPermission.deniedForever) {
          // Try last known first for instant retrieval
          Position? pos = await Geolocator.getLastKnownPosition();

          if (pos == null) {
            // If none exists, try a quick fetch with a strict 3-second timeout
            // so we don't delay the emergency SMS
            try {
              pos = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.medium,
                timeLimit: const Duration(seconds: 3),
              );
            } catch (e) {
              pos = null;
            }
          }

          if (pos != null) {
            lat = pos.latitude;
            lng = pos.longitude;
          }
        }
      }
    } catch (_) {}

    final mapsUrl = 'https://maps.google.com/?q=$lat,$lng';
    final smsMessage =
        '🚨 ALERT: $patientName has a heart rate spike of $heartRate BPM. '
        'This may be a medical emergency. '
        'Current location: $mapsUrl';

    // Notify backend (logs it, ready for Twilio in production)
    // Non-blocking: Fire and forget to ensure SMS launches within 5s
    ApiService().reportSpike(patientId, heartRate, lat, lng);

    // Send SMS to emergency contact via device SMS app
    if (emergencyContact.isNotEmpty) {
      await _sendSms(emergencyContact, smsMessage);
    }

    // Send SMS to doctor (if different number)
    if (doctorContact.isNotEmpty && doctorContact != emergencyContact) {
      await _sendSms(doctorContact, smsMessage);
    }
  }

  /// Opens the device SMS app pre-filled with [message] for [number].
  /// Uses SENDTO action so Android 11+ package-visibility rules are satisfied.
  static Future<void> _sendSms(String number, String message) async {
    // Prefer "smsto:" — it works more reliably with the SENDTO action
    final uri = Uri(
      scheme: 'smsto',
      path: number,
      queryParameters: {'body': message},
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    }
    // Fallback to plain "sms:" scheme
    final fallback = Uri(
      scheme: 'sms',
      path: number,
      queryParameters: {'body': message},
    );
    if (await canLaunchUrl(fallback)) {
      await launchUrl(fallback, mode: LaunchMode.externalApplication);
    }
    // ignore: avoid_print
    print(
      '[SpikeAlert] SMS launch result for $number — smsto: ${await canLaunchUrl(uri)}, sms: ${await canLaunchUrl(fallback)}',
    );
  }

  /// Reset so alert can be shown again next app session.
  static void resetSession() {
    _alertSentThisSession = false;
  }
}
