import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class WallpaperApplyResult {
  const WallpaperApplyResult({required this.success, required this.message});

  final bool success;
  final String message;
}

enum WallpaperTarget {
  home('home', 'Home Screen', 'Set on home screen'),
  lock('lock', 'Lock Screen', 'Set on lock screen'),
  both('both', 'Both Screens', 'Set on home and lock screens');

  const WallpaperTarget(this.value, this.title, this.subtitle);

  final String value;
  final String title;
  final String subtitle;
}

class WallpaperApplyProvider extends ChangeNotifier {
  static const MethodChannel _channel = MethodChannel(
    'pakistani_independence_wallpapers/wallpaper',
  );

  bool _isApplying = false;

  bool get isApplying => _isApplying;

  Future<WallpaperApplyResult> apply({
    required String imageUrl,
    required WallpaperTarget target,
  }) async {
    if (_isApplying) {
      return const WallpaperApplyResult(
        success: false,
        message: 'Wallpaper apply is already in progress.',
      );
    }

    _isApplying = true;
    notifyListeners();

    try {
      final message = await _channel.invokeMethod<String>(
        'applyWallpaper',
        <String, String>{'imageUrl': imageUrl, 'target': target.value},
      );

      return WallpaperApplyResult(
        success: true,
        message: message ?? 'Wallpaper applied successfully.',
      );
    } on PlatformException catch (error) {
      return WallpaperApplyResult(
        success: false,
        message: error.message ?? 'Unable to apply wallpaper.',
      );
    } catch (_) {
      return const WallpaperApplyResult(
        success: false,
        message: 'Unable to apply wallpaper. Please try again.',
      );
    } finally {
      _isApplying = false;
      notifyListeners();
    }
  }

  Future<WallpaperApplyResult> applyLive({
    required String videoUrl,
    required String id,
  }) async {
    if (_isApplying) {
      return const WallpaperApplyResult(
        success: false,
        message: 'Wallpaper apply is already in progress.',
      );
    }

    _isApplying = true;
    notifyListeners();

    try {
      final message = await _channel.invokeMethod<String>(
        'applyLiveWallpaper',
        <String, String>{'videoUrl': videoUrl, 'id': id},
      );

      return WallpaperApplyResult(
        success: true,
        message: message ?? 'Choose this live wallpaper to apply it.',
      );
    } on PlatformException catch (error) {
      return WallpaperApplyResult(
        success: false,
        message: error.message ?? 'Unable to apply live wallpaper.',
      );
    } catch (_) {
      return const WallpaperApplyResult(
        success: false,
        message: 'Unable to apply live wallpaper. Please try again.',
      );
    } finally {
      _isApplying = false;
      notifyListeners();
    }
  }
}
