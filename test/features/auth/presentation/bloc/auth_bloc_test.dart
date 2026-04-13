import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/auth/domain/usecase.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockEmailUseCase extends Mock implements EmailUseCase {}

void main() {
  late EmailUseCase emailUseCase;

  setUp(() async {
    await getIt.reset();
    emailUseCase = _MockEmailUseCase();
    getIt.registerSingletonAsync<EmailUseCase>(() async => emailUseCase);
    await getIt.isReady<EmailUseCase>();
  });

  tearDown(() async {
    await getIt.reset();
  });

  test('AuthOtpSubmitted emits AuthEmailChecked when OTP is valid', () async {
    when(
      () => emailUseCase.checkEmailExists('alice@test.com', '123456'),
    ).thenAnswer((_) async => 'otp-token');

    final bloc = AuthBloc();
    bloc.add(const AuthOtpSubmitted(email: 'alice@test.com', otp: '123456'));
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(bloc.state, isA<AuthEmailChecked>());
    final state = bloc.state as AuthEmailChecked;
    expect(state.email, 'alice@test.com');
    expect(state.token, 'otp-token');
    expect(state.isValid, true);
    verify(() => emailUseCase.checkEmailExists('alice@test.com', '123456')).called(1);
    await bloc.close();
  });
}
