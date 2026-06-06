import 'package:pakistani_independence_wallpapers/data/models/wallpaper_response_model.dart';

abstract class WallpaperRepository {
  Future<WallpaperResponseModel> getWallpapers({
    required int categoryId,
    required int page,
    required int pageSize,
  });
}
