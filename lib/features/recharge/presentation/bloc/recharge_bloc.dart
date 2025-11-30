import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/recharge/data/models/recharge_model.dart';
import 'package:Dividex/features/recharge/domain/usecase.dart';
import 'package:Dividex/features/search/data/model/filter_model.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/utils/message_code.dart';
import 'package:Dividex/shared/widgets/create_pin.dart';
import 'package:Dividex/shared/widgets/push_noti_in_app_widget.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RechargeState {}

class RechargeEvent {}

class DepositEvent extends RechargeEvent {
  final double amount;
  final String currency;
  final String bankCode;

  DepositEvent(this.amount, this.currency, this.bankCode);
}

class CreateDepositEvent extends RechargeEvent {
  final double amount;
  final String currency;
  final String bankCode;

  CreateDepositEvent(this.amount, this.currency, this.bankCode);
}

class CreateWithdrawEvent extends RechargeEvent {
  final double amount;
  final String accountNumber;
  final String bankCode;

  CreateWithdrawEvent(this.amount, this.accountNumber, this.bankCode);
}

class GetWalletEvent extends RechargeEvent {}

class GetWalletInfoEvent extends RechargeEvent {}

class GetDepositDetailEvent extends RechargeEvent {
  final String id;

  GetDepositDetailEvent(this.id);
}

class GetWithdrawDetailEvent extends RechargeEvent {
  final String id;

  GetWithdrawDetailEvent(this.id);
}

class TransferEvent extends RechargeEvent {
  final double originalAmount;
  final double realAmount;
  final String currency;
  final String toAccount;
  final String description;
  final String? groupId;
  final String pin;

  TransferEvent(
    this.originalAmount,
    this.realAmount,
    this.currency,
    this.toAccount,
    this.description, {
    this.groupId,
    required this.pin,
  });
}

enum WalletHistoryType { external, internal }

abstract class GetHistoryEvent extends Equatable {
  const GetHistoryEvent();

  @override
  List<Object?> get props => [];
}

class GetHistoryInitEvent extends GetHistoryEvent {
  final int page;
  final int pageSize;
  final WalletHistoryType type;

  const GetHistoryInitEvent(this.page, this.pageSize, this.type);
}

class GetHistoryMoreEvent extends GetHistoryEvent {
  final int page;
  final int pageSize;
  final WalletHistoryType type;

  const GetHistoryMoreEvent(this.page, this.pageSize, this.type);
}

class GetHistoryReloadEvent extends GetHistoryEvent {
  final int page;
  final int pageSize;
  final WalletHistoryType type;

  const GetHistoryReloadEvent(this.page, this.pageSize, this.type);
}

class VnPayLinkState extends RechargeState {
  final String link;

  VnPayLinkState(this.link);
}

class RechargeSuccessState extends RechargeState {}

class CreatePinRequired extends RechargeState {}

class GetWalletSuccessState extends RechargeState {
  final String walletInfo;

  GetWalletSuccessState(this.walletInfo);
}

class GetWalletInfoSuccessState extends RechargeState {
  final String balance;
  final String currency;
  final String totalTransactions;
  final String phoneNumber;
  final String fullName;
  final String latestTime;

  GetWalletInfoSuccessState(
    this.balance,
    this.currency,
    this.totalTransactions,
    this.phoneNumber,
    this.fullName,
    this.latestTime,
  );
}

class GetDepositDetailSuccessState extends RechargeState {
  final DepositTransactionModel depositDetail;

  GetDepositDetailSuccessState(this.depositDetail);
}

class GetWithdrawDetailSuccessState extends RechargeState {
  final WithdrawTransactionModel withdrawDetail;

  GetWithdrawDetailSuccessState(this.withdrawDetail);
}

class LoadedHistoryState extends Equatable {
  const LoadedHistoryState({
    this.isLoading = true,
    this.page = 1,
    this.totalPage = 0,
    this.totalItems = 0,
    this.externalTransaction = const [],
    this.internalTransaction = const [],
  });

  final bool isLoading;
  final int page;
  final int totalPage;
  final int totalItems;
  final List<ExternalTransactionModel> externalTransaction;
  final List<InternalTransactionModel> internalTransaction;

  @override
  List<Object?> get props => [
    isLoading,
    page,
    totalPage,
    totalItems,
    externalTransaction,
    internalTransaction,
  ];

  LoadedHistoryState copyWith({
    bool? isLoading,
    int? page,
    int? totalPage,
    int? totalItems,
    List<ExternalTransactionModel>? externalTransaction,
    List<InternalTransactionModel>? internalTransaction,
  }) {
    return LoadedHistoryState(
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      totalItems: totalItems ?? this.totalItems,
      externalTransaction: externalTransaction ?? this.externalTransaction,
      internalTransaction: internalTransaction ?? this.internalTransaction,
    );
  }
}

class RechargeBloc extends Bloc<RechargeEvent, RechargeState> {
  RechargeBloc() : super(RechargeState()) {
    on<DepositEvent>(_onDeposit);
    on<CreateDepositEvent>(_onCreateDeposit);
    on<CreateWithdrawEvent>(_onCreateWithdraw);
    on<GetWalletEvent>(_onGetWallet);
    on<GetDepositDetailEvent>(_onGetDepositDetail);
    on<GetWithdrawDetailEvent>(_onGetWithdrawDetail);
    on<TransferEvent>(_onTransferEvent);
    on<GetWalletInfoEvent>(_onGetWalletInfo);
  }

  Future<void> _onDeposit(
    DepositEvent event,
    Emitter<RechargeState> emit,
  ) async {
    try {
      final usecase = await getIt.getAsync<RechargeUseCase>();
      final link = await usecase.deposit(
        event.amount,
        event.currency,
        event.bankCode,
      );

      emit(VnPayLinkState(link));
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future<void> _onCreateDeposit(
    CreateDepositEvent event,
    Emitter<RechargeState> emit,
  ) async {
    try {
      final usecase = await getIt.getAsync<RechargeUseCase>();
      await usecase.createDeposit(event.amount, event.currency, event.bankCode);

      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.createDepositSuccess, type: ToastType.success);

      emit(RechargeSuccessState());
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future<void> _onCreateWithdraw(
    CreateWithdrawEvent event,
    Emitter<RechargeState> emit,
  ) async {
    try {
      final usecase = await getIt.getAsync<RechargeUseCase>();
      await usecase.createWithdraw(
        event.amount,
        event.accountNumber,
        event.bankCode,
      );

      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.createDepositSuccess, type: ToastType.success);

      emit(RechargeSuccessState());
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future<void> _onGetWallet(
    GetWalletEvent event,
    Emitter<RechargeState> emit,
  ) async {
    try {
      final usecase = await getIt.getAsync<RechargeUseCase>();
      final walletInfo = await usecase.getWallet();

      emit(GetWalletSuccessState(walletInfo));
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future<void> _onGetDepositDetail(
    GetDepositDetailEvent event,
    Emitter<RechargeState> emit,
  ) async {
    try {
      final usecase = await getIt.getAsync<RechargeUseCase>();
      final depositDetail = await usecase.getDepositDetail(event.id);

      emit(GetDepositDetailSuccessState(depositDetail));
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future<void> _onGetWithdrawDetail(
    GetWithdrawDetailEvent event,
    Emitter<RechargeState> emit,
  ) async {
    try {
      final usecase = await getIt.getAsync<RechargeUseCase>();
      final withdrawDetail = await usecase.getWithdrawDetail(event.id);

      emit(GetWithdrawDetailSuccessState(withdrawDetail));
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future<void> _onTransferEvent(
    TransferEvent event,
    Emitter<RechargeState> emit,
  ) async {
    try {
      final usecase = await getIt.getAsync<RechargeUseCase>();
      final token = await usecase.verifyPin(event.pin, event.realAmount);
      if (token == null) {
        final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
        showCustomToast(intl.pinInvalid, type: ToastType.error);
        return;
      }

      await usecase.transfer(
        event.originalAmount,
        event.realAmount,
        event.currency,
        event.toAccount,
        event.description,
        groupId: event.groupId,
        token: token,
      );

      emit(RechargeSuccessState());
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      if (e.toString().contains(MessageCode.pinNotSet)) {
        showCustomToast(intl.pinNotSet, type: ToastType.error);
        emit(CreatePinRequired());
      } else if (e.toString().contains(MessageCode.pinIncorrect)) {
        showCustomToast(intl.pinIncorrect, type: ToastType.error);
      } else {
        showCustomToast(intl.pinInvalid, type: ToastType.error);
        return;
      }
    }
  }

  Future<void> _onGetWalletInfo(
    GetWalletInfoEvent event,
    Emitter<RechargeState> emit,
  ) async {
    try {
      final usecase = await getIt.getAsync<RechargeUseCase>();
      final walletInfo = await usecase.getWalletInfo();

      emit(
        GetWalletInfoSuccessState(
          walletInfo['balance'] as String,
          walletInfo['currency'] as String,
          walletInfo['totalTransactions'] as String,
          walletInfo['phoneNumber'] as String,
          walletInfo['fullName'] as String,
          walletInfo['latestTime'] as String,
        ),
      );
    } catch (e, stackTrace) {
      print(stackTrace);
      print(e);
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }
}

class LoadedHistoryBloc extends Bloc<GetHistoryEvent, LoadedHistoryState> {
  LoadedHistoryBloc() : super((const LoadedHistoryState())) {
    on<GetHistoryInitEvent>(_onInitial);
    on<GetHistoryMoreEvent>(_onLoadMoreUsers);
    on<GetHistoryReloadEvent>(_onRefreshUsers);
  }
  Future _onInitial(GetHistoryInitEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<RechargeUseCase>();

      // Lấy dữ liệu theo loại giao dịch
      final transactions = event.type == WalletHistoryType.external
          ? await useCase.getExternalHistory(
              event.page,
              event.pageSize,
              ExternalTransactionFilterArguments(),
            )
          : await useCase.getInternalHistory(
              event.page,
              event.pageSize,
              InternalTransactionFilterArguments(),
            );

      emit(
        state.copyWith(
          page: transactions.page,
          totalPage: transactions.totalPage,
          totalItems: transactions.totalItems,
          isLoading: false,
          externalTransaction: event.type == WalletHistoryType.external
              ? (transactions.data
                    .map((e) => e as ExternalTransactionModel)
                    .toList())
              : <ExternalTransactionModel>[],
          internalTransaction: event.type == WalletHistoryType.internal
              ? (transactions.data
                    .map((e) => e as InternalTransactionModel)
                    .toList())
              : <InternalTransactionModel>[],
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future _onLoadMoreUsers(GetHistoryMoreEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<RechargeUseCase>();
      final transactions = event.type == WalletHistoryType.external
          ? await useCase.getExternalHistory(
              event.page,
              event.pageSize,
              ExternalTransactionFilterArguments(),
            )
          : await useCase.getInternalHistory(
              event.page,
              event.pageSize,
              InternalTransactionFilterArguments(),
            );

      emit(
        state.copyWith(
          page: transactions.page,
          totalPage: transactions.totalPage,
          totalItems: transactions.totalItems,
          externalTransaction: event.type == WalletHistoryType.external
              ? ([
                  ...state.externalTransaction,
                  ...transactions.data,
                ].map((e) => e as ExternalTransactionModel).toList())
              : <ExternalTransactionModel>[],
          internalTransaction: event.type == WalletHistoryType.internal
              ? ([
                  ...state.internalTransaction,
                  ...transactions.data,
                ].map((e) => e as InternalTransactionModel).toList())
              : <InternalTransactionModel>[],
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future _onRefreshUsers(GetHistoryReloadEvent event, Emitter emit) async {
    if (state.isLoading) return;

    try {
      emit(state.copyWith(isLoading: true));

      final useCase = await getIt.getAsync<RechargeUseCase>();
      final users = event.type == WalletHistoryType.external
          ? await useCase.getExternalHistory(
              event.page,
              event.pageSize,
              ExternalTransactionFilterArguments(),
            )
          : await useCase.getInternalHistory(
              event.page,
              event.pageSize,
              InternalTransactionFilterArguments(),
            );

      emit(
        state.copyWith(
          page: users.page,
          totalPage: users.totalPage,
          externalTransaction: event.type == WalletHistoryType.external
              ? (users.data.map((e) => e as ExternalTransactionModel).toList())
              : <ExternalTransactionModel>[],
          internalTransaction: event.type == WalletHistoryType.internal
              ? (users.data.map((e) => e as InternalTransactionModel).toList())
              : <InternalTransactionModel>[],
          totalItems: users.totalItems,
          isLoading: false,
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }
}
