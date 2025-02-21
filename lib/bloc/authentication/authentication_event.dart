part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends AuthenticationEvent {
  final String username;
  final String password;
  LoginButtonPressed({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

class ObscurePasswordTapped extends AuthenticationEvent {}
