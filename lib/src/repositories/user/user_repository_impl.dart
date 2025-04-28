import 'dart:developer';
import 'dart:io';

import 'package:agenda_barber/src/core/exceptions/auth_exception.dart';

import 'package:agenda_barber/src/core/fp/either.dart';
import 'package:agenda_barber/src/core/restClient/rest_client.dart';
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
}
