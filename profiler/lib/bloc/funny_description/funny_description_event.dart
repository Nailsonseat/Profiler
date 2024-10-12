part of 'funny_description_bloc.dart';

@immutable
abstract class FunnyDescriptionEvent {}

class CreateProfileEvent extends FunnyDescriptionEvent {
  final Profile profile;

  CreateProfileEvent(this.profile);
}
