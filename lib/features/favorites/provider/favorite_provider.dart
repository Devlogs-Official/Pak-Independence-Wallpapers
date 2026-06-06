import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pakistani_independence_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider with ChangeNotifier {
  static const _storageKey = 'favorites';

  final List<FavoriteWallpaper> _items = [];

  List<FavoriteWallpaper> get items => List.unmodifiable(_items);

  List<String> get favorites =>
      _items.map((wallpaper) => wallpaper.imageUrl).toList();

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final savedItems = prefs.getStringList(_storageKey) ?? [];
    _items
      ..clear()
      ..addAll(savedItems.map(_decodeFavorite).nonNulls);
    notifyListeners();
  }

  Future<void> toggleFavorite(WallpaperEntity wallpaper) async {
    if (isFavorite(wallpaper.imageUrl)) {
      await removeFavorite(wallpaper.imageUrl);
      return;
    }

    await addWallpaper(wallpaper);
  }

  Future<void> addWallpaper(WallpaperEntity wallpaper) async {
    if (!_items.any((item) => item.imageUrl == wallpaper.imageUrl)) {
      _items.add(FavoriteWallpaper.fromWallpaper(wallpaper));
      await _saveFavorites();
      notifyListeners();
    }
  }

  Future<void> addFavorite(String imageUrl) async {
    if (!_items.any((item) => item.imageUrl == imageUrl)) {
      _items.add(
        FavoriteWallpaper(
          id: imageUrl.hashCode,
          name: '',
          categoryId: 1,
          imageUrl: imageUrl,
          thumbnailUrl: imageUrl,
        ),
      );
      await _saveFavorites();
      notifyListeners();
    }
  }

  Future<void> removeFavorite(String imageUrl) async {
    final previousLength = _items.length;
    _items.removeWhere((item) => item.imageUrl == imageUrl);
    if (_items.length != previousLength) {
      await _saveFavorites();
      notifyListeners();
    }
  }

  bool isFavorite(String imageUrl) {
    return _items.any((item) => item.imageUrl == imageUrl);
  }

  List<FavoriteWallpaper> byCategory(int categoryId) {
    return _items.where((item) => item.categoryId == categoryId).toList();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _storageKey,
      _items.map((wallpaper) => jsonEncode(wallpaper.toJson())).toList(),
    );
  }

  FavoriteWallpaper? _decodeFavorite(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return FavoriteWallpaper.fromJson(decoded);
      }
    } catch (_) {
      if (raw.trim().isNotEmpty) {
        return FavoriteWallpaper(
          id: raw.hashCode,
          name: '',
          categoryId: 1,
          imageUrl: raw,
          thumbnailUrl: raw,
        );
      }
    }
    return null;
  }
}

class FavoriteWallpaper extends WallpaperEntity {
  const FavoriteWallpaper({
    required super.id,
    required super.name,
    required super.categoryId,
    required super.imageUrl,
    required super.thumbnailUrl,
  });

  factory FavoriteWallpaper.fromWallpaper(WallpaperEntity wallpaper) {
    return FavoriteWallpaper(
      id: wallpaper.id,
      name: wallpaper.name,
      categoryId: wallpaper.categoryId,
      imageUrl: wallpaper.imageUrl,
      thumbnailUrl: wallpaper.thumbnailUrl,
    );
  }

  factory FavoriteWallpaper.fromJson(Map<String, dynamic> json) {
    final imageUrl = json['image_url']?.toString() ?? '';
    return FavoriteWallpaper(
      id: _readInt(json['id'], fallback: imageUrl.hashCode),
      name: json['name']?.toString() ?? '',
      categoryId: _readInt(json['category_id'], fallback: 1),
      imageUrl: imageUrl,
      thumbnailUrl: json['thumbnail_url']?.toString() ?? imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category_id': categoryId,
      'image_url': imageUrl,
      'thumbnail_url': thumbnailUrl,
    };
  }

  static int _readInt(Object? value, {required int fallback}) {
    if (value is int) {
      return value;
    }
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
