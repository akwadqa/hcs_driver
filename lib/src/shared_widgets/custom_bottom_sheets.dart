import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showContactActionsSheet(
  BuildContext context, {
  required String rawPhone,
  String? defaultCountryCode, // e.g. "+974"
}) async {
  final phone = _normalizePhone(
    rawPhone,
    defaultCountryCode: defaultCountryCode,
  );

  showModalBottomSheet(
    context: context,
    useSafeArea: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(Icons.call),
            title: const Text("Call"),
            subtitle: Text(phone),
            onTap: () async {
              Navigator.pop(ctx);
              await _launchDialer(phone);
            },
          ),
          ListTile(
            leading: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(Icons.phone_sharp, color: Colors.white),
            ), // or use your SVG/asset
            title: const Text("Send WhatsApp"),
            subtitle: Text(phone),
            onTap: () async {
              Navigator.pop(ctx);
              final ok = await _launchWhatsApp(phone);
              if (!ok && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("WhatsApp not available.")),
                );
              }
            },
          ),
        ],
      );
    },
  );
}

String _normalizePhone(String input, {String? defaultCountryCode}) {
  // keep digits and plus
  final cleaned = input.replaceAll(RegExp(r'[^\d+]'), '');
  if (cleaned.startsWith('+')) return cleaned;
  // Prepend a default country code if provided; otherwise return as-is
  if (defaultCountryCode != null && defaultCountryCode.isNotEmpty) {
    final cc = defaultCountryCode.startsWith('+')
        ? defaultCountryCode
        : '+$defaultCountryCode';
    return '$cc$cleaned';
  }
  return cleaned;
}

Future<void> _launchDialer(String phone) async {
  final uri = Uri(scheme: 'tel', path: phone);
  if (phone.isNotEmpty) {
    final Uri telLaunchUri = Uri(scheme: 'tel', path: phone);
    launchUrl(telLaunchUri);
  }
}

Future<bool> _launchWhatsApp(String phone) async {
  // Prefer the native scheme if installed; fallback to wa.me
  final scheme = Uri.parse('whatsapp://send?phone=$phone');
  if (await canLaunchUrl(scheme)) {
    return launchUrl(scheme, mode: LaunchMode.externalApplication);
  }
  final web = Uri.parse('https://wa.me/$phone'); // works if browser available
  // if (await canLaunchUrl(web)) {
  return launchUrl(web, mode: LaunchMode.externalApplication);
  // }
  // return false;
}
