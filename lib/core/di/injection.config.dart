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
import 'package:Dividex/shared/services/settings_service.dart' as _i667;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final dioModule = _$DioModule();
    gh.lazySingletonAsync<_i361.Dio>(() => dioModule.dio());
    gh.lazySingleton<_i667.SettingsService>(() => _i667.SettingsService());
    gh.lazySingletonAsync<_i305.DioClient>(
        () async => _i305.DioClient(await getAsync<_i361.Dio>()));
    gh.factoryAsync<_i1016.AuthRemoteDataSource>(() async =>
        _i349.AuthRemoteDataSourceImpl(await getAsync<_i305.DioClient>()));
    gh.factoryAsync<_i143.AuthRepository>(() async => _i898.AuthRepositoryImpl(
        await getAsync<_i1016.AuthRemoteDataSource>()));
    gh.factoryAsync<_i242.RegisterUseCase>(() async =>
        _i242.RegisterUseCase(await getAsync<_i143.AuthRepository>()));
    gh.factoryAsync<_i242.LoginUseCase>(
        () async => _i242.LoginUseCase(await getAsync<_i143.AuthRepository>()));
    gh.factoryAsync<_i242.LogoutUseCase>(() async =>
        _i242.LogoutUseCase(await getAsync<_i143.AuthRepository>()));
    gh.factoryAsync<_i242.OtpUseCase>(
        () async => _i242.OtpUseCase(await getAsync<_i143.AuthRepository>()));
    gh.factoryAsync<_i242.ResetPasswordUseCase>(() async =>
        _i242.ResetPasswordUseCase(await getAsync<_i143.AuthRepository>()));
    return this;
  }
}

class _$DioModule extends _i306.DioModule {}
