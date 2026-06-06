import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class ShareFileHelper {
  const ShareFileHelper._();

  static Future<void> shareRemoteFile({
    required String url,
    required String filename,
    required String subject,
    String? text,
  }) async {
    final response = await http
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 30));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Unable to download file for sharing.');
    }

    final bytes = Uint8List.fromList(response.bodyBytes);
    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile.fromData(bytes, name: filename, mimeType: _mimeType(filename)),
        ],
        subject: subject,
        text: text,
      ),
    );
  }

  static String imageFilename(String rawName) {
    return '${_sanitize(rawName, fallback: 'pakistan_wallpaper')}.jpg';
  }

  static String videoFilename(String rawName) {
    return '${_sanitize(rawName, fallback: 'pakistan_live_wallpaper')}.mp4';
  }

  static String _mimeType(String filename) {
    final lower = filename.toLowerCase();
    if (lower.endsWith('.mp4')) {
      return 'video/mp4';
    }
    if (lower.endsWith('.png')) {
      return 'image/png';
    }
    if (lower.endsWith('.webp')) {
      return 'image/webp';
    }
    return 'image/jpeg';
  }

  static String _sanitize(String value, {required String fallback}) {
    final sanitized = value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    return sanitized.isEmpty ? fallback : sanitized;
  }
}
