class PaginationModel {
  const PaginationModel({
    required this.currentPage,
    required this.pageSize,
    required this.totalRecords,
    required this.totalPages,
  });

  final int currentPage;
  final int pageSize;
  final int totalRecords;
  final int totalPages;

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: _readInt(json['current_page']),
      pageSize: _readInt(json['page_size']),
      totalRecords: _readInt(json['total_records']),
      totalPages: _readInt(json['total_pages']),
    );
  }

  static int _readInt(Object? value) {
    if (value is int) {
      return value;
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
