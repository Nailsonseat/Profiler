part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthGoogleSignIn extends AuthEvent {}

final class AuthCheckSignIn extends AuthEvent {}

final class AuthSignOut extends AuthEvent {}