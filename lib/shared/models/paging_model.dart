class PagingModel<T> {
  final T data;
  final int page;
  final int totalPage;
  final int totalItems;

  PagingModel({
    required this.data,
    required this.page,
    required this.totalPage,
    required this.totalItems,
  });

  factory PagingModel.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    final data = json['data'] ?? {};
    
    return PagingModel(
      data: fromJsonT(data),
      page: (data['current_page'] ?? 1) as int,
      totalPage: (data['total_pages'] ?? 1) as int,
      totalItems: (data['total_rows'] ?? 0) as int,
    );
  }
}
