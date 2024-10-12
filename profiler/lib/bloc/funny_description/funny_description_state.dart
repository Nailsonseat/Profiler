part of 'funny_description_bloc.dart';

@immutable
abstract class FunnyDescriptionState {}

class FunnyDescriptionInitial extends FunnyDescriptionState {}

class FunnyDescriptionLoading extends FunnyDescriptionState {}

class FunnyDescriptionSuccess extends FunnyDescriptionState {
  final String funnyDescription;

  FunnyDescriptionSuccess(this.funnyDescription);
}

class FunnyDescriptionFailure extends FunnyDescriptionState {
  final String error;

  FunnyDescriptionFailure(this.error);
}
