import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/home/domain/usecase.dart';
import 'package:Dividex/shared/widgets/push_noti_in_app_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyAccountState {}

class VerifyAccountInitialState extends  VerifyAccountState {}

class VerifyAccountLoadingState extends  VerifyAccountState {}

class VerifyAccountSuccessState extends  VerifyAccountState {
  final String accountName;
  VerifyAccountSuccessState(this.accountName);
}

class VerifyAccountFailState extends  VerifyAccountState {}

class VerifyAccountEvent {
  final String accountNumber;
  final String bankCode;
  VerifyAccountEvent(this.accountNumber, this.bankCode);
}


class VerifyAccountBloc extends Bloc<VerifyAccountEvent, VerifyAccountState> {
  VerifyAccountBloc() : super(VerifyAccountInitialState()) {
    on<VerifyAccountEvent>((event, emit) async {
      emit(VerifyAccountInitialState());
      try {
        emit(VerifyAccountLoadingState());
        final useCase = await getIt.getAsync<AccountUseCase>();
        final accountName = await useCase.verifyAccount(event.accountNumber, event.bankCode);
        emit(VerifyAccountSuccessState(accountName));
      } catch (e) {
        emit(VerifyAccountFailState());
        final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
        showCustomToast(intl.error, type: ToastType.error);
      }
    });
  }
}
