import 'package:equatable/equatable.dart';

abstract class LoadNotiEvent extends Equatable {
  const LoadNotiEvent();

  @override
  List<Object?> get props => [];
}

class InitialEvent extends LoadNotiEvent {
  const InitialEvent();
}

class LoadMoreNotiEvent extends LoadNotiEvent {
  final int page;
  final int pageSize;

  const LoadMoreNotiEvent(this.page, this.pageSize);
}

class RefreshNotiEvent extends LoadNotiEvent {
  const RefreshNotiEvent();
}
