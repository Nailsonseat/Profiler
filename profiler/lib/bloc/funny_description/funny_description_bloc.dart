import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../api/funny_description.dart';
import '../../models/profile.dart';

part 'funny_description_event.dart';
part 'funny_description_state.dart';

class FunnyDescriptionBloc extends Bloc<FunnyDescriptionEvent, FunnyDescriptionState> {

  final FunnyDescriptionApi funnyDescriptionApi;

  FunnyDescriptionBloc({required this.funnyDescriptionApi}) : super(FunnyDescriptionInitial()) {
    on<CreateProfileEvent>(_onCreateProfileEvent);
  }

  Future<void> _onCreateProfileEvent(CreateProfileEvent event, Emitter<FunnyDescriptionState> emit) async {
    emit(FunnyDescriptionLoading());
    try {
      final profile = await funnyDescriptionApi.getFunnyDescription(event.profile);
      emit(FunnyDescriptionSuccess(profile));
    } catch (error) {
      emit(FunnyDescriptionFailure(error.toString()));
    }
  }
}
