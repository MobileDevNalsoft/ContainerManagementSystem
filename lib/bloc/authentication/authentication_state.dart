part of 'authentication_bloc.dart';

enum AuthenticationStatus { initial, loading, success, invalidCredentials, accessDenied, failure }

final class AuthenticationState extends Equatable {
  AuthenticationState({this.authenticationStatus, this.obscure});

  AuthenticationStatus? authenticationStatus;
  bool? obscure;

  factory AuthenticationState.initial() {
    return AuthenticationState(authenticationStatus: AuthenticationStatus.initial, obscure: true);
  }

  AuthenticationState copyWith({AuthenticationStatus? authenticationStatus, bool? obscure}) {
    return AuthenticationState(authenticationStatus: authenticationStatus ?? this.authenticationStatus, obscure: obscure ?? this.obscure);
  }

  @override
  List<Object?> get props => [authenticationStatus, obscure];
}
