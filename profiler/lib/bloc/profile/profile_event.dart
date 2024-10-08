part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ProfileFetch extends ProfileEvent {
  final int pageKey;

  ProfileFetch({required this.pageKey});
}
