import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:network_calls/src.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../contants/app_constants.dart';
import '../../inits/init.dart';
import '../../logger/logger.dart';
import '../../navigations/navigator_service.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  NavigatorService? navigator;
  AuthenticationBloc({this.navigator}) : super(AuthenticationState.initial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<ObscurePasswordTapped>(_onObscurePasswordTapped);
  }

  final NetworkCalls _authApi = NetworkCalls(AppConstants.IDCS_URL, getIt<Dio>(), connectTimeout: 30, receiveTimeout: 30, maxRedirects: 5);
  final SharedPreferences sharedPreferences = getIt<SharedPreferences>();

  Future<void> _onLoginButtonPressed(LoginButtonPressed event, Emitter<AuthenticationState> emit) async {
    emit(state.copyWith(authenticationStatus: AuthenticationStatus.loading));
    String token = '';
    await _authApi.post(AppConstants.GET_OCI_TOKEN, data: AppConstants.TOKEN_DATA, methodHeaders: AppConstants.TOKEN_METHODHEADERS).then(
      (apiResponse) async {
        if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
          await getRequestState(apiResponse.response!.data["access_token"]).then((requestState) async {
            await _authApi.post(AppConstants.AUTHENCTICATE_USER_NAME, methodHeaders: {
              'Authorization': 'Bearer ${apiResponse.response!.data["access_token"]}',
              'Content-Type': 'application/json'
            }, data: {
              "op": "credSubmit",
              "credentials": {"username": event.username, "password": event.password},
              "requestState": requestState
            }).then((apiResponse) {
              if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
                token = apiResponse.response!.data['authnToken'];
              } else {
                token = '';
              }
            });
          });
        }
        if (token.isNotEmpty) {
          emit(state.copyWith(authenticationStatus: AuthenticationStatus.success));
          // await _customApi.get(AppConstants.USERINFO, queryParameters: {"username": event.username}).then(
          //   (value) async {
          //     await sharedPreferences.setStringList("access_types", jsonDecode(value.response!.data)['data']['access_types'].split(','));
          await sharedPreferences.setString("username", event.username);
          navigator!.pushReplacement('/containerManagement');
          // },
          // ).onError(
          //   (error, stackTrace) {
          //     emit(state.copyWith(authenticationStatus: AuthenticationStatus.accessDenied));
          //     Log.e("no data found in DB to get access details");
          //   },
          // );
        } else {
          emit(state.copyWith(authenticationStatus: AuthenticationStatus.invalidCredentials));
          getIt<SharedPreferences>().setBool('isLogged', false);
        }
      },
    ).onError(
      (error, stackTrace) {
        emit(state.copyWith(authenticationStatus: AuthenticationStatus.failure));
        Log.e(error);
      },
    );
  }

  Future<String> getRequestState(String token) async {
    String requestState = '';
    await _authApi
        .get(AppConstants.AUTHENCTICATE_USER_NAME, methodHeaders: {'Authorization': 'Bearer $token', 'Content-Type': 'application/x-www-form-urlencoded'}).then(
      (apiResponse) async {
        if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
          requestState = apiResponse.response!.data["requestState"];
        }
      },
    );
    return requestState;
  }

  void _onObscurePasswordTapped(ObscurePasswordTapped event, Emitter<AuthenticationState> emit) {
    emit(state.copyWith(obscure: !state.obscure!));
  }
}
