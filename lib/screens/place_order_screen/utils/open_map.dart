import 'package:url_launcher/url_launcher.dart';

Future<void> openMap(double latitude, double longitude) async {
  String googleMapsUrl =
      "https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=driving";
  await launchUrl(Uri.parse(googleMapsUrl));
}
