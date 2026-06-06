import 'package:pakistani_independence_wallpapers/data/models/pagination_model.dart';
import 'package:pakistani_independence_wallpapers/data/models/wallpaper_model.dart';

class WallpaperResponseModel {
  const WallpaperResponseModel({
    required this.status,
    required this.message,
    required this.pagination,
    required this.wallpapers,
  });

  final bool status;
  final String message;
  final PaginationModel pagination;
  final List<WallpaperModel> wallpapers;

  factory WallpaperResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return WallpaperResponseModel(
      status: json['status'] == true,
      message: json['message']?.toString() ?? '',
      pagination: PaginationModel.fromJson(
        (json['pagination'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      wallpapers: data is List
          ? data
                .whereType<Map>()
                .map(
                  (item) =>
                      WallpaperModel.fromJson(item.cast<String, dynamic>()),
                )
                .where((item) => item.imageUrl.isNotEmpty)
                .toList()
          : const [],
    );
  }
}
