import 'package:pakistani_independence_wallpapers/core/constants/api_constants.dart';
import 'package:pakistani_independence_wallpapers/data/models/wallpaper_response_model.dart';
import 'package:pakistani_independence_wallpapers/domain/repositories/wallpaper_repository.dart';

class GetWallpapersUsecase {
  const GetWallpapersUsecase(this._repository);

  final WallpaperRepository _repository;

  Future<WallpaperResponseModel> call({
    required int categoryId,
    required int page,
    int pageSize = ApiConstants.defaultPageSize,
  }) {
    return _repository.getWallpapers(
      categoryId: categoryId,
      page: page,
      pageSize: pageSize,
    );
  }
}
