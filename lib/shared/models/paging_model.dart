class PagingModel<T extends Object> {
  final int page;
  final int totalPage;
  final T data;

  PagingModel({
    required this.page,
    required this.totalPage,
    required this.data,
  });
}
