import 'package:flutter/foundation.dart';
import 'package:pakistani_independence_wallpapers/core/constants/api_constants.dart';
import 'package:pakistani_independence_wallpapers/core/exceptions/api_exception.dart';
import 'package:pakistani_independence_wallpapers/data/models/pagination_model.dart';
import 'package:pakistani_independence_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:pakistani_independence_wallpapers/domain/usecases/get_wallpapers_usecase.dart';

class WallpaperProvider extends ChangeNotifier {
  WallpaperProvider(this._getWallpapersUsecase);

  final GetWallpapersUsecase _getWallpapersUsecase;
  final Map<int, List<WallpaperEntity>> _cache = {};
  final Map<int, PaginationModel> _paginationCache = {};
  final Map<int, String> _errorMessages = {};
  final Map<int, String> _paginationErrorMessages = {};
  final Set<int> _loadingCategories = {};
  final Set<int> _loadingMoreCategories = {};
  int? _activeCategoryId;

  bool isLoading = false;
  bool isLoadingMore = false;
  String? get errorMessage {
    if (_activeCategoryId == null) {
      return null;
    }
    return _errorMessages[_activeCategoryId];
  }

  String? get paginationErrorMessage {
    if (_activeCategoryId == null) {
      return null;
    }
    return _paginationErrorMessages[_activeCategoryId];
  }

  List<WallpaperEntity> get wallpapers {
    if (_activeCategoryId == null) {
      return const [];
    }
    return List.unmodifiable(_cache[_activeCategoryId] ?? const []);
  }

  int get currentPage {
    if (_activeCategoryId == null) {
      return 0;
    }
    return _paginationCache[_activeCategoryId]?.currentPage ?? 0;
  }

  int get totalPages {
    if (_activeCategoryId == null) {
      return 0;
    }
    return _paginationCache[_activeCategoryId]?.totalPages ?? 0;
  }

  bool get hasMoreData {
    if (_activeCategoryId == null) {
      return false;
    }
    return hasMoreDataFor(_activeCategoryId!);
  }

  List<WallpaperEntity> wallpapersFor(int categoryId) {
    return List.unmodifiable(_cache[categoryId] ?? const []);
  }

  bool isLoadingCategory(int categoryId) {
    return _loadingCategories.contains(categoryId);
  }

  bool isLoadingMoreCategory(int categoryId) {
    return _loadingMoreCategories.contains(categoryId);
  }

  int currentPageFor(int categoryId) {
    return _paginationCache[categoryId]?.currentPage ?? 0;
  }

  int totalPagesFor(int categoryId) {
    return _paginationCache[categoryId]?.totalPages ?? 0;
  }

  bool hasMoreDataFor(int categoryId) {
    final pagination = _paginationCache[categoryId];
    if (pagination == null) {
      return true;
    }
    return pagination.currentPage < pagination.totalPages;
  }

  String? errorFor(int categoryId) {
    return _errorMessages[categoryId];
  }

  String? paginationErrorFor(int categoryId) {
    return _paginationErrorMessages[categoryId];
  }

  Future<void> preloadInitialWallpapers() async {
    await loadWallpapers(categoryId: ApiConstants.categoryIds.first);
  }

  Future<void> loadWallpapers({
    required int categoryId,
    bool refresh = false,
  }) async {
    _activeCategoryId = categoryId;

    if (!refresh && (_cache[categoryId]?.isNotEmpty ?? false)) {
      notifyListeners();
      return;
    }

    if (_loadingCategories.contains(categoryId)) {
      return;
    }

    _loadingCategories.add(categoryId);
    isLoading = true;
    _errorMessages.remove(categoryId);
    _paginationErrorMessages.remove(categoryId);
    notifyListeners();

    try {
      final response = await _getWallpapersUsecase(
        categoryId: categoryId,
        page: 1,
      );
      _cache[categoryId] = _deduplicate(response.wallpapers);
      _paginationCache[categoryId] = response.pagination;
    } catch (error) {
      _errorMessages[categoryId] = _friendlyMessage(error);
      _cache[categoryId] = const [];
      _paginationCache.remove(categoryId);
    } finally {
      _loadingCategories.remove(categoryId);
      isLoading = _loadingCategories.isNotEmpty;
      notifyListeners();
    }
  }

  Future<void> loadMore({required int categoryId}) async {
    final current = currentPageFor(categoryId);
    final total = totalPagesFor(categoryId);

    if (_loadingMoreCategories.contains(categoryId) ||
        _loadingCategories.contains(categoryId) ||
        current == 0 ||
        current >= total) {
      return;
    }

    _activeCategoryId = categoryId;
    _loadingMoreCategories.add(categoryId);
    isLoadingMore = true;
    _paginationErrorMessages.remove(categoryId);
    notifyListeners();

    try {
      final response = await _getWallpapersUsecase(
        categoryId: categoryId,
        page: current + 1,
      );
      final existing = _cache[categoryId] ?? const [];
      _cache[categoryId] = _deduplicate([...existing, ...response.wallpapers]);
      _paginationCache[categoryId] = response.pagination;
    } catch (error) {
      _paginationErrorMessages[categoryId] = _friendlyMessage(error);
    } finally {
      _loadingMoreCategories.remove(categoryId);
      isLoadingMore = _loadingMoreCategories.isNotEmpty;
      notifyListeners();
    }
  }

  Future<void> retryLoadMore({required int categoryId}) {
    _paginationErrorMessages.remove(categoryId);
    return loadMore(categoryId: categoryId);
  }

  List<WallpaperEntity> _deduplicate(List<WallpaperEntity> wallpapers) {
    final seen = <int>{};
    return wallpapers.where((wallpaper) => seen.add(wallpaper.id)).toList();
  }

  String _friendlyMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }
    return 'Something went wrong. Please try again.';
  }
}
