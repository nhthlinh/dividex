import 'package:Dividex/features/recharge/data/models/recharge_model.dart';
import 'package:Dividex/features/recharge/data/repositories/recharge_repository_impl.dart';
import 'package:Dividex/features/recharge/data/source/recharge_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRechargeRemoteDataSource extends Mock
    implements RechargeRemoteDataSource {}

void main() {
  late RechargeRemoteDataSource remoteDataSource;
  late RechargeRepositoryImpl repository;

  setUp(() {
    remoteDataSource = _MockRechargeRemoteDataSource();
    repository = RechargeRepositoryImpl(remoteDataSource);
  });

  test('deposit delegates to remote data source', () async {
    final response = PayOSResponseModel(
      orderCode: 123,
      qrCode: 'qr-code',
      paymentLinkId: 'link-id',
    );
    when(() => remoteDataSource.deposit(10000, 'VND')).thenAnswer((_) async => response);

    final result = await repository.deposit(10000, 'VND');

    expect(result.orderCode, 123);
    verify(() => remoteDataSource.deposit(10000, 'VND')).called(1);
    verifyNoMoreInteractions(remoteDataSource);
  });

  test('getWallet delegates and returns wallet amount', () async {
    when(() => remoteDataSource.getWallet()).thenAnswer((_) async => '500000');

    final wallet = await repository.getWallet();

    expect(wallet, '500000');
    verify(() => remoteDataSource.getWallet()).called(1);
  });
}
