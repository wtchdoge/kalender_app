// lib/utils/address_utils.dart
import 'package:url_launcher/url_launcher.dart';

class AddressUtils {
  static String formatAddress({
    required String street,
    required String houseNumber,
    required String zip,
    required String city,
  }) {
    final streetPart = street.isNotEmpty ? street : 'Unknown';
    final houseNumberPart = houseNumber.isNotEmpty ? houseNumber : 'Unknown';
    final zipPart = zip.isNotEmpty ? zip : 'Unknown';
    final cityPart = city.isNotEmpty ? city : 'Unknown';
    return '$streetPart $houseNumberPart, $zipPart $cityPart';
  }

  static Future<void> openInGoogleMaps({
    required String street,
    required String houseNumber,
    required String zip,
    required String city,
  }) async {
    final addressQuery = Uri.encodeComponent(formatAddress(
      street: street,
      houseNumber: houseNumber,
      zip: zip,
      city: city,
    ));
    final url = 'https://www.google.com/maps/search/?api=1&query=$addressQuery';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
