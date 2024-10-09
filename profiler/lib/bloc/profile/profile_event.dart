part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ProfileFetch extends ProfileEvent {
  final int pageKey;

  ProfileFetch({required this.pageKey});
}

class ProfileUpdate extends ProfileEvent {
  final Profile updatedProfile;

  ProfileUpdate({required this.updatedProfile});

  @override
  List<Object> get props => [updatedProfile];
}
