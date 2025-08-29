import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/event_expense/domain/usecase.dart';
import 'package:Dividex/shared/widgets/message_widget.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadedCategoriesBloc
    extends Bloc<LoadCategoriesEvent, LoadedCategoriesState> {
  LoadedCategoriesBloc() : super((const LoadedCategoriesState())) {
    on<InitialEvent>(_onInitial);
    on<LoadMoreCategoriesEvent>(_onLoadMoreCategories);
    on<RefreshCategoriesEvent>(_onRefreshCategories);
  }

  Future _onInitial(InitialEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<ExpenseUseCase>();
      final categories = await useCase.getCategories(
        event.page,
        event.pageSize,
        event.key,
      );

      emit(
        state.copyWith(
          page: categories.page,
          totalPage: categories.totalPage,
          categories: List<String>.from(categories.data),
          isLoading: false,
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future _onLoadMoreCategories(
    LoadMoreCategoriesEvent event,
    Emitter emit,
  ) async {
    try {
      final useCase = await getIt.getAsync<ExpenseUseCase>();
      final categories = await useCase.getCategories(
        state.page + 1,
        event.pageSize,
        event.key,
      );

      emit(
        state.copyWith(
          page: categories.page,
          totalPage: categories.totalPage,
          categories: List<String>.from(state.categories)..addAll(categories.data),
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future _onRefreshCategories(
    RefreshCategoriesEvent event,
    Emitter emit,
  ) async {
    if (state.isLoading) return;

    try {
      emit(state.copyWith(isLoading: true));

      final useCase = await getIt.getAsync<ExpenseUseCase>();
      final categories = await useCase.getCategories(
        event.page,
        event.pageSize,
        event.key,
      );

      emit(
        state.copyWith(
          page: categories.page,
          totalPage: categories.totalPage,
          categories: List<String>.from(categories.data),
          isLoading: false,
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }
}

abstract class LoadCategoriesEvent extends Equatable {
  const LoadCategoriesEvent();

  @override
  List<Object?> get props => [];
}

class InitialEvent extends LoadCategoriesEvent {
  final String key;
  final int page;
  final int pageSize;
  const InitialEvent({
    required this.key,
    required this.page,
    required this.pageSize,
  });
}

class LoadMoreCategoriesEvent extends LoadCategoriesEvent {
  final String key;
  final int pageSize;
  const LoadMoreCategoriesEvent({
    required this.key,
    required this.pageSize,
  });
}

class RefreshCategoriesEvent extends LoadCategoriesEvent {
  final String key;
  final int page;
  final int pageSize;
  const RefreshCategoriesEvent({
    required this.key,
    required this.page,
    required this.pageSize,
  });
}

class LoadedCategoriesState extends Equatable {
  const LoadedCategoriesState({
    this.isLoading = true,
    this.page = 0,
    this.totalPage = 0,
    this.categories = const [],
  });

  final bool isLoading;
  final int page;
  final int totalPage;
  final List<String> categories;

  bool get hasMore => page < totalPage;

  @override
  List<Object?> get props => [isLoading, page, totalPage, categories];

  LoadedCategoriesState copyWith({
    bool? isLoading,
    int? page,
    int? totalPage,
    List<String>? categories,
  }) {
    return LoadedCategoriesState(
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      categories: categories ?? this.categories,
    );
  }
}
