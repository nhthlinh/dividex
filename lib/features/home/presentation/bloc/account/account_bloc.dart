import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/home/data/models/bank_account_model.dart';
import 'package:Dividex/features/home/domain/usecase.dart';
import 'package:Dividex/shared/widgets/push_noti_in_app_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountState {
  final List<BankAccount> accounts;

  AccountState(this.accounts);
}

class AccountEvent {}

class GetAccountsEvent extends AccountEvent {}

class CreateAccountEvent extends AccountEvent {
  final BankAccount account;

  CreateAccountEvent(this.account);
}

class UpdateAccountEvent extends AccountEvent {
  final BankAccount account;

  UpdateAccountEvent(this.account);
}

class DeleteAccountEvent extends AccountEvent {
  final String accountId;

  DeleteAccountEvent(this.accountId);
}

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(AccountState([])) {
    on<GetAccountsEvent>((event, emit) async {
      emit(AccountState([]));
      try {
        final useCase = await getIt.getAsync<AccountUseCase>();
        final accounts = await useCase.getAccounts(1, 1000);
        emit(AccountState(accounts));
      } catch (e) {
        emit(AccountState([]));
        final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
        showCustomToast(intl.error, type: ToastType.error);
      }
    });

    on<CreateAccountEvent>((event, emit) async {
      try {
        final useCase = await getIt.getAsync<AccountUseCase>();
        await useCase.createAccount(event.account);

        add(GetAccountsEvent());
        final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
        showCustomToast(intl.accountCreated, type: ToastType.success);
      } catch (e) {
        final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
        showCustomToast(intl.error, type: ToastType.error);
      }
    });

    on<UpdateAccountEvent>((event, emit) async {
      try {
        final useCase = await getIt.getAsync<AccountUseCase>();
        await useCase.updateAccount(event.account);

        add(GetAccountsEvent());
        final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
        showCustomToast(intl.accountUpdated, type: ToastType.success);
      } catch (e) {
        final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
        showCustomToast(intl.error, type: ToastType.error);
      }
    });

    on<DeleteAccountEvent>((event, emit) async {
      try {
        final useCase = await getIt.getAsync<AccountUseCase>();
        await useCase.deleteAccount(event.accountId);

        add(GetAccountsEvent());
        final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
        showCustomToast(intl.accountDeleted, type: ToastType.success);
      } catch (e) {
        final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
        showCustomToast(intl.error, type: ToastType.error);
      }
    });
  }
}
