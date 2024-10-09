import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';
import 'package:profiler/api/profile.dart';
import 'package:profiler/models/profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final PagingController<int, Profile> pagingController = PagingController(firstPageKey: 0);
  static const int _pageSize = 7;
  final ProfileApi _profileApi;
  int _currentPage = 0;

  ProfileBloc({required ProfileApi profileApi})
      : _profileApi = profileApi,
        super(ProfileInitial()) {
    on<ProfileFetch>(_onFetch);
    on<ProfileUpdate>(_onUpdate);
  }

  Future<void> _onFetch(ProfileFetch event, Emitter<ProfileState> emit) async {
    if (state is ProfileLoading) return;
    List<Profile> currentProfiles = <Profile>[];
    if (state is ProfileLoaded) {
      currentProfiles = (state as ProfileLoaded?)?.profiles ?? [];
    }

    emit(ProfileLoading());
    try {
      final newItems = await _profileApi.getProfiles(limit: _pageSize, offset: _currentPage);
      _currentPage += newItems.length;

      emit(ProfileLoaded(
          profiles: currentProfiles + newItems, pageKey: event.pageKey, isLastPage: newItems.length < _pageSize));

      final currentState = state as ProfileLoaded;
      try {
        if (currentState.isLastPage) {
          pagingController.appendLastPage(currentState.profiles);
        } else {
          final nextPageKey = currentState.pageKey + currentState.profiles.length;
          pagingController.appendPage(newItems, nextPageKey);
        }
      } catch (error) {
        pagingController.error = error;
      }
    } catch (error) {
      emit(ProfileError(message: error.toString()));
    }
  }

  Future<void> _onUpdate(ProfileUpdate event, Emitter<ProfileState> emit) async {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      final updatedProfiles = List<Profile>.from(currentState.profiles);

      emit(ProfileLoading());
      try {
        await _profileApi.updateProfile(event.updatedProfile.id!, event.updatedProfile);
        final int index = updatedProfiles.indexWhere((profile) => profile.id == event.updatedProfile.id);

        updatedProfiles[index] = event.updatedProfile;
        pagingController.itemList = updatedProfiles;
      } catch (error) {
        Logger().e('Error updating profile: $error');
        emit(ProfileError(message: error.toString()));
      }

      emit(ProfileLoaded(
        profiles: updatedProfiles,
        pageKey: currentState.pageKey,
        isLastPage: currentState.isLastPage,
      ));
    }
  }

  void reset() {
    _currentPage = 0;
    add(ProfileFetch(pageKey: 0));
  }
}
