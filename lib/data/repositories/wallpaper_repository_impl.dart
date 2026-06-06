import 'package:pakistani_independence_wallpapers/data/datasource/wallpaper_remote_datasource.dart';
import 'package:pakistani_independence_wallpapers/data/models/wallpaper_response_model.dart';
import 'package:pakistani_independence_wallpapers/domain/repositories/wallpaper_repository.dart';

class WallpaperRepositoryImpl implements WallpaperRepository {
  const WallpaperRepositoryImpl(this._apiService);

  final WallpaperApiService _apiService;

  @override
  Future<WallpaperResponseModel> getWallpapers({
    required int categoryId,
    required int page,
    required int pageSize,
  }) {
    return _apiService.getWallpapers(
      categoryId: categoryId,
      page: page,
      pageSize: pageSize,
    );
  }
}
