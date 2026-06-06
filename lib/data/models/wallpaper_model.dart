import 'package:pakistani_independence_wallpapers/domain/entities/wallpaper_entity.dart';

class WallpaperModel extends WallpaperEntity {
  const WallpaperModel({
    required super.id,
    required super.name,
    required super.categoryId,
    required super.imageUrl,
    required super.thumbnailUrl,
  });

  factory WallpaperModel.fromJson(Map<String, dynamic> json) {
    final imageUrl = json['image_url']?.toString() ?? '';
    final thumbnailUrl = json['thumbnail_url']?.toString() ?? imageUrl;

    return WallpaperModel(
      id: _readInt(json['id']),
      name: json['name']?.toString() ?? '',
      categoryId: _readInt(json['category_id']),
      imageUrl: imageUrl,
      thumbnailUrl: thumbnailUrl,
    );
  }

  static int _readInt(Object? value) {
    if (value is int) {
      return value;
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
