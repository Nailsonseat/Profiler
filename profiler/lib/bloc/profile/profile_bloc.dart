import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profiler/api/profile.dart';
import 'package:profiler/models/profile.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  static const int _pageSize = 7;
  final ProfileApi _profileApi;
  int _currentPage = 0;

  ProfileBloc({required ProfileApi profileApi})
      : _profileApi = profileApi,
        super(ProfileInitial()) {
    on<ProfileFetch>(_onFetch);
  }

  Future<void> _onFetch(ProfileFetch event, Emitter<ProfileState> emit) async {
    if (state is ProfileLoading) return;

    emit(ProfileLoading());
    try {
      final newItems = await _profileApi.getProfiles(limit: _pageSize, offset: _currentPage);
      _currentPage += newItems.length;
      emit(ProfileLoaded(profiles: newItems, pageKey: event.pageKey, isLastPage: newItems.length < _pageSize));
    } catch (error) {
      emit(ProfileError(message: error.toString()));
    }
  }

  void reset() {
    _currentPage = 0;
    add(ProfileFetch(pageKey: 0));
  }
}
