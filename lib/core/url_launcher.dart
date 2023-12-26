import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

final class UrlLauncher {
  const UrlLauncher._();

  static void makeCall(String phone) {
    launchUrlString("tel:$phone");
  }

  static void sendSMS(String phone, String message) {
    final Uri smsLaunchUri = Uri(
      scheme: 'sms',
      path: phone,
      queryParameters: <String, String>{
        'body': Uri.encodeComponent(message),
      },
    );

    launchUrl(smsLaunchUri);
  }
}
