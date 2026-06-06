import 'package:pakistani_independence_wallpapers/core/constants/api_constants.dart';
import 'package:pakistani_independence_wallpapers/core/exceptions/api_exception.dart';
import 'package:pakistani_independence_wallpapers/core/network/api_client.dart';
import 'package:pakistani_independence_wallpapers/data/models/wallpaper_response_model.dart';

class WallpaperApiService {
  const WallpaperApiService(this._apiClient);

  final ApiClient _apiClient;

  Future<WallpaperResponseModel> getWallpapers({
    required int categoryId,
    required int page,
    required int pageSize,
  }) async {
    final json = await _apiClient.get(
      ApiConstants.wallpapersUrl,
      queryParameters: {
        'category_id': categoryId.toString(),
        'page': page.toString(),
        'page_size': pageSize.toString(),
      },
    );

    if (json['status'] != true) {
      throw ApiException(
        json['message']?.toString() ?? 'Unable to fetch wallpapers.',
      );
    }

    return WallpaperResponseModel.fromJson(json);
  }
}

typedef WallpaperRemoteDatasource = WallpaperApiService;
