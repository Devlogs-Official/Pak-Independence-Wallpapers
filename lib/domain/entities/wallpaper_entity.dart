class WallpaperEntity {
  const WallpaperEntity({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.imageUrl,
    required this.thumbnailUrl,
  });

  final int id;
  final String name;
  final int categoryId;
  final String imageUrl;
  final String thumbnailUrl;
}
