import 'dart:developer';
import 'dart:io';

import 'package:agenda_barber/src/core/exceptions/auth_exception.dart';
import 'package:agenda_barber/src/core/exceptions/repository_exception.dart';

import 'package:agenda_barber/src/core/fp/either.dart';
import 'package:agenda_barber/src/core/fp/nil.dart';
import 'package:agenda_barber/src/core/restClient/rest_client.dart';
import 'package:agenda_barber/src/model/user_model.dart';
import 'package:dio/dio.dart';

import './user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final RestClient restClient;

  UserRepositoryImpl({required this.restClient});

  @override
  Future<Either<AuthException, String>> login(
    String email,
    String password,
  ) async {
    try {
      final Response(:data) = await restClient.unAuth.post<dynamic>(
        '/auth',
        data: <String, String>{"email": email, "password": password},
      );

      return Success(data['access_token']);
    } on DioException catch (e, s) {
      if (e.response != null) {
        final Response(:statusCode) = e.response!;
        if (statusCode == HttpStatus.forbidden) {
          log('E-mail ou senha inválido', error: e, stackTrace: s);
          return Failure(AuthUnauthorizedException());
        }
      }
      log('Erro ao realizar login', error: e, stackTrace: s);
      return Failure(AuthError(message: 'Erro ao realizar login'));
    }
  }

  @override
  Future<Either<RepositoryException, UserModel>> me() async {
    try {
      final Response(:data) = await restClient.auth.get('/me');
      return Success(UserModel.fromMap(data));
    } on DioException catch (e, s) {
      log('Erro ao buscar usuãrio logado', error: e, stackTrace: s);
      return Failure(
        RepositoryException(message: 'Erro ao buscar usuãrio logado'),
      );
    } on ArgumentError catch (e, s) {
      log('Invalid Json', error: e, stackTrace: s);
      return Failure(RepositoryException(message: e.message));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> registerAdmin(
    ({String email, String name, String password}) userData,
  ) async {
    try {
      await restClient.unAuth.post(
        '/users',
        data: {
          'name': userData.name,
          'email': userData.email,
          'password': userData.password,
          'profile': 'ADM',
        },
      );

      return Success(nil);
    } on DioException catch (e, s) {
      log('Erro ao registrar usuário admin', error: e, stackTrace: s);
      return Failure(
        RepositoryException(message: 'Erro ao registrar usuãrio admin'),
      );
    }
  }

  @override
  Future<Either<RepositoryException, List<UserModel>>> getEmployees(
    int barbershopId,
  ) async {
    try {
      final Response(:List data) = await restClient.auth.get(
        '/users',
        queryParameters: {'barbershopId': barbershopId},
      );

      final employees = data.map((e) => UserModelEmployee.fromMap(e)).toList();

      return Success(employees);
    } on DioException catch (e, s) {
      log('Erro ao buscar colaborador', error: e, stackTrace: s);
      return Failure(
        RepositoryException(message: 'Erro ao buscar colaboradores'),
      );
    } on ArgumentError catch (e, s) {
      log(
        'Erro ao converter colaboradores (Invalid Json)',
        error: e,
        stackTrace: s,
      );
      return Failure(
        RepositoryException(message: 'Erro ao buscar colaboradores'),
      );
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> registerAdmAsEmployee(
    ({List<String> workDays, List<int> workHours}) userModel,
  ) async {
    try {
      final userModelResult = await me();
      final int userId;

      switch (userModelResult) {
        case Success(value: UserModel(:var id)):
          userId = id;
        case Failure(:var exception):
          return Failure(exception);
      }

      await restClient.auth.put(
        '/users/$userId/',
        data: {
          'work_days': userModel.workDays,
          'word_hours': userModel.workHours,
        },
      );

      return Success(nil);
    } on DioException catch (e, s) {
      log(
        'Erro ao inserir administrador como colaborador',
        error: e,
        stackTrace: s,
      );
      return Failure(
        RepositoryException(
          message: 'Erro ao inserir administrador como colaborador',
        ),
      );
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> registerEmployee(
    ({
      int barbershopId,
      String email,
      String name,
      String password,
      List<String> workDays,
      List<int> workHours,
    })
    userModel,
  ) async {
    try {
      await restClient.auth.post(
        '/users/',
        data: {
          'barbershopId': userModel.barbershopId,
          'name': userModel.name,
          'email': userModel.email,
          'password': userModel.password,
          'work_days': userModel.workDays,
          'word_hours': userModel.workHours,
          'profile': 'EMPLOYEE',
        },
      );

      return Success(nil);
    } on DioException catch (e, s) {
      log('Erro ao inserir colaborador', error: e, stackTrace: s);
      return Failure(
        RepositoryException(message: 'Erro ao inserir colaborador'),
      );
    }
  }
}
