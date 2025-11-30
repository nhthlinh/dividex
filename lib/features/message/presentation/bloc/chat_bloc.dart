import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/message/data/model/message_model.dart';
import 'package:Dividex/features/message/domain/usecase.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:Dividex/shared/widgets/push_noti_in_app_widget.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatState {
  final Message? message;

  ChatState(this.message);
}

class LoadedMessageState extends Equatable {
  const LoadedMessageState({
    this.isLoading = true,
    this.page = 1,
    this.totalPage = 0,
    this.totalItems = 0,
    this.messages = const [],
  });

  final bool isLoading;
  final int page;
  final int totalPage;
  final int totalItems;
  final List<Message> messages;

  @override
  List<Object?> get props => [isLoading, page, totalPage, totalItems, messages];

  LoadedMessageState copyWith({
    bool? isLoading,
    int? page,
    int? totalPage,
    int? totalItems,
    List<Message>? messages,
  }) {
    return LoadedMessageState(
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      totalItems: totalItems ?? this.totalItems,
      messages: messages ?? this.messages,
    );
  }
}

class ChatEvent {}

abstract class LoadMessageEvent extends Equatable {
  const LoadMessageEvent();

  @override
  List<Object?> get props => [];
}

class InitialEvent extends LoadMessageEvent {
  final String groupId;
  const InitialEvent(this.groupId);
}

class LoadMoreMessageEvent extends LoadMessageEvent {
  final String groupId;
  final int page;
  final int pageSize;

  const LoadMoreMessageEvent(this.groupId, this.page, this.pageSize);
}

class RefreshMessageEvent extends LoadMessageEvent {
  final String groupId;
  const RefreshMessageEvent(this.groupId);
}

class SendMessageEvent extends ChatEvent {
  final String groupId;
  final String content;

  SendMessageEvent(this.groupId, this.content);
}

class UpdateMessageEvent extends ChatEvent {
  final String messageId;
  final String content;

  UpdateMessageEvent(this.messageId, this.content);
}

class DeleteMessageEvent extends ChatEvent {
  final String messageId;

  DeleteMessageEvent(this.messageId);
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatState(null)) {
    on<SendMessageEvent>((event, emit) async {
      emit(ChatState(null));
      try {
        final useCase = await getIt.getAsync<ChatUseCase>();
        final message = await useCase.sendMessage(event.content, event.groupId);
        emit(ChatState(message));
      } catch (e) {
        final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
        showCustomToast(intl.error, type: ToastType.error);
      }
    });

    on<UpdateMessageEvent>((event, emit) async {
      try {
        final useCase = await getIt.getAsync<ChatUseCase>();
        await useCase.updateMessage(event.messageId, event.content);
      } catch (e) {
        final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
        showCustomToast(intl.error, type: ToastType.error);
      }
    });

    on<DeleteMessageEvent>((event, emit) async {
      try {
        final useCase = await getIt.getAsync<ChatUseCase>();
        await useCase.deleteMessage(event.messageId);
      } catch (e) {
        final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
        showCustomToast(intl.error, type: ToastType.error);
      }
    });
  }
}

class LoadedMessageBloc extends Bloc<LoadMessageEvent, LoadedMessageState> {
  LoadedMessageBloc() : super((const LoadedMessageState())) {
    on<InitialEvent>(_onInitial);
    on<LoadMoreMessageEvent>(_onLoadMoreMessage);
    on<RefreshMessageEvent>(_onRefreshMessage);
  }

  Future<PagingModel<List<Message>>> getData(int page, String groupId) async {
    final useCase = await getIt.getAsync<ChatUseCase>();
    return await useCase.getMessages(page, 100, groupId);
  }

  Future _onInitial(InitialEvent event, Emitter emit) async {
    try {
      final messages = await getData(1, event.groupId);

      emit(
        state.copyWith(
          page: messages.page,
          totalPage: messages.totalPage,
          messages: messages.data,
          totalItems: messages.totalItems,
          isLoading: false,
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future _onLoadMoreMessage(LoadMoreMessageEvent event, Emitter emit) async {
    try {
      final messages = await getData(event.page, event.groupId);

      emit(
        state.copyWith(
          page: messages.page,
          totalPage: messages.totalPage,
          totalItems: messages.totalItems,
          messages: [...state.messages, ...messages.data],
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future _onRefreshMessage(RefreshMessageEvent event, Emitter emit) async {
    if (state.isLoading) return;

    try {
      emit(state.copyWith(isLoading: true));

      final messages = await getData(1, event.groupId);

      emit(
        state.copyWith(
          page: messages.page,
          totalPage: messages.totalPage,
          messages: messages.data,
          totalItems: messages.totalItems,
          isLoading: false,
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }
}
