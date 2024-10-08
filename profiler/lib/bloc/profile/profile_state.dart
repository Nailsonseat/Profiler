part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final List<Profile> profiles;
  final bool isLastPage;
  final int pageKey;

  ProfileLoaded({required this.profiles, required this.isLastPage, required this.pageKey});

  @override
  List<Object> get props => [profiles, isLastPage];
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});

  @override
  List<Object> get props => [message];
}
