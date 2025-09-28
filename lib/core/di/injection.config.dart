// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:Dividex/core/network/dio_client.dart' as _i305;
import 'package:Dividex/core/network/dio_module.dart' as _i306;
import 'package:Dividex/features/auth/data/repositories/auth_repository_impl.dart'
    as _i898;
import 'package:Dividex/features/auth/data/source/auth_remote_datasource.dart'
    as _i1016;
import 'package:Dividex/features/auth/data/source/auth_remote_datasource_impl.dart'
    as _i349;
import 'package:Dividex/features/auth/domain/auth_repository.dart' as _i143;
import 'package:Dividex/features/auth/domain/usecase.dart' as _i242;
import 'package:Dividex/features/event_expense/data/repositories/event_repository_impl.dart'
    as _i788;
import 'package:Dividex/features/event_expense/data/repositories/expense_repository_impl.dart'
    as _i679;
import 'package:Dividex/features/event_expense/data/source/event_remote_datasource.dart'
    as _i989;
import 'package:Dividex/features/event_expense/data/source/event_remote_datasource_impl.dart'
    as _i1037;
import 'package:Dividex/features/event_expense/data/source/expense_remote_datasource.dart'
    as _i947;
import 'package:Dividex/features/event_expense/data/source/expense_remote_datasource_impl.dart'
    as _i109;
import 'package:Dividex/features/event_expense/domain/event_repository.dart'
    as _i720;
import 'package:Dividex/features/event_expense/domain/event_usecase.dart'
    as _i140;
import 'package:Dividex/features/event_expense/domain/expense_repository.dart'
    as _i55;
import 'package:Dividex/features/event_expense/domain/expense_usecase.dart'
    as _i701;
import 'package:Dividex/features/friend/data/repositories/friend_repository_impl.dart'
    as _i707;
import 'package:Dividex/features/friend/data/source/friend_remote_datasource.dart'
    as _i692;
import 'package:Dividex/features/friend/data/source/friend_remote_datasource_impl.dart'
    as _i343;
import 'package:Dividex/features/friend/domain/friend_repository.dart'
    as _i1026;
import 'package:Dividex/features/friend/domain/usecase.dart' as _i126;
import 'package:Dividex/features/group/data/repositories/group_repository_impl.dart'
    as _i654;
import 'package:Dividex/features/group/data/source/group_remote_datasource.dart'
    as _i957;
import 'package:Dividex/features/group/data/source/group_remote_datasource_impl.dart'
    as _i794;
import 'package:Dividex/features/group/domain/group_repository.dart' as _i1049;
import 'package:Dividex/features/group/domain/usecase.dart' as _i352;
import 'package:Dividex/features/image/data/repositories/image_repository_impl.dart'
    as _i580;
import 'package:Dividex/features/image/data/source/image_remote_data_source.dart'
    as _i840;
import 'package:Dividex/features/image/data/source/image_remote_data_source_impl.dart'
    as _i41;
import 'package:Dividex/features/image/domain/image_repository.dart' as _i306;
import 'package:Dividex/features/image/domain/usecase.dart' as _i111;
import 'package:Dividex/features/user/data/repositories/user_repository_impl.dart'
    as _i979;
import 'package:Dividex/features/user/data/source/user_remote_datasource.dart'
    as _i477;
import 'package:Dividex/features/user/data/source/user_remote_datasource_impl.dart'
    as _i357;
import 'package:Dividex/features/user/domain/usecase.dart' as _i56;
import 'package:Dividex/features/user/domain/user_repository.dart' as _i635;
import 'package:Dividex/shared/services/settings_service.dart' as _i667;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dioModule = _$DioModule();
    gh.lazySingletonAsync<_i361.Dio>(() => dioModule.dio());
    gh.lazySingleton<_i667.SettingsService>(() => _i667.SettingsService());
    gh.lazySingletonAsync<_i305.DioClient>(
      () async => _i305.DioClient(await getAsync<_i361.Dio>()),
    );
    gh.factoryAsync<_i1016.AuthRemoteDataSource>(
      () async =>
          _i349.AuthRemoteDataSourceImpl(await getAsync<_i305.DioClient>()),
    );
    gh.factoryAsync<_i692.FriendRemoteDataSource>(
      () async =>
          _i343.FriendRemoteDatasourceImpl(await getAsync<_i305.DioClient>()),
    );
    gh.factoryAsync<_i840.ImageRemoteDataSource>(
      () async =>
          _i41.ImageRemoteDatasourceImpl(await getAsync<_i305.DioClient>()),
    );
    gh.factoryAsync<_i957.GroupRemoteDataSource>(
      () async =>
          _i794.GroupRemoteDatasourceImpl(await getAsync<_i305.DioClient>()),
    );
    gh.factoryAsync<_i143.AuthRepository>(
      () async => _i898.AuthRepositoryImpl(
        await getAsync<_i1016.AuthRemoteDataSource>(),
      ),
    );
    gh.factoryAsync<_i306.ImageRepository>(
      () async => _i580.ImageRepositoryImpl(
        await getAsync<_i840.ImageRemoteDataSource>(),
      ),
    );
    gh.factoryAsync<_i1049.GroupRepository>(
      () async => _i654.GroupRepositoryImpl(
        await getAsync<_i957.GroupRemoteDataSource>(),
      ),
    );
    gh.factoryAsync<_i352.GroupUseCase>(
      () async => _i352.GroupUseCase(await getAsync<_i1049.GroupRepository>()),
    );
    gh.factoryAsync<_i242.RegisterUseCase>(
      () async => _i242.RegisterUseCase(await getAsync<_i143.AuthRepository>()),
    );
    gh.factoryAsync<_i242.LoginUseCase>(
      () async => _i242.LoginUseCase(await getAsync<_i143.AuthRepository>()),
    );
    gh.factoryAsync<_i242.LogoutUseCase>(
      () async => _i242.LogoutUseCase(await getAsync<_i143.AuthRepository>()),
    );
    gh.factoryAsync<_i242.EmailUseCase>(
      () async => _i242.EmailUseCase(await getAsync<_i143.AuthRepository>()),
    );
    gh.factoryAsync<_i242.ResetPasswordUseCase>(
      () async =>
          _i242.ResetPasswordUseCase(await getAsync<_i143.AuthRepository>()),
    );
    gh.factoryAsync<_i1026.FriendRepository>(
      () async => _i707.FriendRepositoryImpl(
        await getAsync<_i692.FriendRemoteDataSource>(),
      ),
    );
    gh.factoryAsync<_i989.EventRemoteDataSource>(
      () async =>
          _i1037.EventRemoteDataSourceImpl(await getAsync<_i305.DioClient>()),
    );
    gh.factoryAsync<_i947.ExpenseRemoteDataSource>(
      () async =>
          _i109.ExpenseRemoteDataSourceImpl(await getAsync<_i305.DioClient>()),
    );
    gh.factoryAsync<_i477.UserRemoteDataSource>(
      () async =>
          _i357.UserRemoteDatasourceImpl(await getAsync<_i305.DioClient>()),
    );
    gh.factoryAsync<_i126.FriendUseCase>(
      () async =>
          _i126.FriendUseCase(await getAsync<_i1026.FriendRepository>()),
    );
    gh.factoryAsync<_i111.ImageUseCase>(
      () async => _i111.ImageUseCase(
        imageRepository: await getAsync<_i306.ImageRepository>(),
      ),
    );
    gh.factoryAsync<_i635.UserRepository>(
      () async => _i979.UserRepositoryImpl(
        await getAsync<_i477.UserRemoteDataSource>(),
      ),
    );
    gh.factoryAsync<_i55.ExpenseRepository>(
      () async => _i679.ExpenseRepositoryImpl(
        await getAsync<_i947.ExpenseRemoteDataSource>(),
      ),
    );
    gh.factoryAsync<_i701.ExpenseUseCase>(
      () async =>
          _i701.ExpenseUseCase(await getAsync<_i55.ExpenseRepository>()),
    );
    gh.factoryAsync<_i56.UserUseCase>(
      () async => _i56.UserUseCase(await getAsync<_i635.UserRepository>()),
    );
    gh.factoryAsync<_i720.EventRepository>(
      () async => _i788.EventRepositoryImpl(
        await getAsync<_i989.EventRemoteDataSource>(),
      ),
    );
    gh.factoryAsync<_i140.EventUseCase>(
      () async => _i140.EventUseCase(await getAsync<_i720.EventRepository>()),
    );
    return this;
  }
}

class _$DioModule extends _i306.DioModule {}
