part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ProfileCreate extends ProfileEvent {
  final Profile newProfile;

  ProfileCreate({required this.newProfile});

  @override
  List<Object> get props => [newProfile];
}

class ProfileFetch extends ProfileEvent {
  final int? pageKey;
  final String? query;

  ProfileFetch({required this.pageKey, this.query});

  @override
  List<Object> get props => [pageKey!, query!];
}

class ProfileSearch extends ProfileEvent {
  final String query;

  ProfileSearch({required this.query});

  @override
  List<Object> get props => [query];
}

class ProfileRefresh extends ProfileEvent {
  @override
  List<Object> get props => [];
}

class ProfileUpdate extends ProfileEvent {
  final Profile updatedProfile;

  ProfileUpdate({required this.updatedProfile});

  @override
  List<Object> get props => [updatedProfile];
}

class ProfileDelete extends ProfileEvent {
  final int profileId;

  ProfileDelete({required this.profileId});

  @override
  List<Object> get props => [profileId];
}
