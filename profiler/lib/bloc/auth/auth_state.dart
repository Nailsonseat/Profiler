part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthNeeded extends AuthState {}

final class AuthSignedIn extends AuthState {
  final User user;

  AuthSignedIn({required this.user});
}
