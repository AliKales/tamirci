import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

final class UrlLauncher {
  const UrlLauncher._();

  static void makeCall(String phone) {
    if (!_support) return;
    launchUrlString("tel:$phone");
  }

  static void sendSMS(String phone, String message) {
    if (!_support) return;
    final Uri smsLaunchUri = Uri(
      scheme: 'sms',
      path: phone,
      queryParameters: <String, String>{
        'body': Uri.encodeComponent(message),
      },
    );

    launchUrl(smsLaunchUri);
  }

  static void sendMail(String email, String subject, String body) {
    launchUrlString("mailto:$email?subject=$subject&body=$body");
  }

  static bool get _support {
    return kIsWeb ? false : true;
  }
}
