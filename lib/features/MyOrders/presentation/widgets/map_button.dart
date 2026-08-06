import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPreviewCard extends StatelessWidget {
  final String lcoationUrl;
  final String locationName;

  const MapPreviewCard({
    super.key,
    required this.lcoationUrl,
    required this.locationName,
  });

  void _openMap() async {
    final url = Uri.parse(lcoationUrl);

    if (await canLaunchUrl(url)) {
      try {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } catch (e) {
        debugPrint("Error launching WhatsApp: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openMap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Padding(
            padding: EdgeInsetsGeometry.all(10),
            child: Row(
              children: [
                Icon(Icons.location_pin, size: 20.sp, color: Colors.red),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    locationName,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
