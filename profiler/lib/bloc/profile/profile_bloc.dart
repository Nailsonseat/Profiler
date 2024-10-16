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
    on<ProfileSearch>(_onSearch);
    on<ProfileUpdate>(_onUpdate);
    on<ProfileDelete>(_onDelete);
    on<ProfileCreate>(_onCreate);
    on<ProfileRefresh>(_onRefresh);
  }

  Future<void> _onCreate(ProfileCreate event, Emitter<ProfileState> emit) async {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      final updatedProfiles = List<Profile>.from(currentState.profiles);

      emit(ProfileLoading());
      try {
        final createdProfile = await _profileApi.createProfile(event.newProfile);

        updatedProfiles.add(createdProfile);

        pagingController.itemList = updatedProfiles;

        emit(ProfileLoaded(
          profiles: updatedProfiles,
          pageKey: currentState.pageKey,
          isLastPage: currentState.isLastPage,
        ));
      } catch (error) {
        emit(ProfileError(message: error.toString()));
      }
    }
  }

  Future<void> _onFetch(ProfileFetch event, Emitter<ProfileState> emit) async {
    List<Profile> currentProfiles = [];
    if (state is ProfileLoaded) {
      currentProfiles = (state as ProfileLoaded).profiles;
    }

    emit(ProfileLoading());

    try {
      final newItems = await _profileApi.getProfiles(limit: _pageSize, offset: event.pageKey ?? _currentPage);
      _currentPage += newItems.length;

      emit(ProfileLoaded(
        profiles: currentProfiles + newItems,
        pageKey: event.pageKey ?? _currentPage,
        isLastPage: newItems.length < _pageSize,
      ));

      final currentState = state as ProfileLoaded;
      if (currentState.isLastPage) {
        pagingController.appendLastPage(currentState.profiles);
      } else {
        final nextPageKey = currentState.pageKey + currentState.profiles.length;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      emit(ProfileError(message: error.toString()));
    }
  }

  Future<void> _onSearch(ProfileSearch event, Emitter<ProfileState> emit) async {
      emit(ProfileLoading());
      try {
        final searchedProfiles = await _profileApi.getProfiles(query: event.query, limit: 20, offset: 0);
        pagingController.itemList = searchedProfiles;
        pagingController.appendLastPage([]);

        emit(ProfileLoaded(
          profiles: searchedProfiles,
          pageKey: 0,
          isLastPage: true,
        ));
      } catch (error) {
        emit(ProfileError(message: error.toString()));
      }
  }

  Future<void> _onRefresh(ProfileRefresh event, Emitter<ProfileState> emit) async {
    pagingController.itemList = [];
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
        emit(ProfileError(message: error.toString()));
      }

      emit(ProfileLoaded(
        profiles: updatedProfiles,
        pageKey: currentState.pageKey,
        isLastPage: currentState.isLastPage,
      ));
    }
  }

  Future<void> _onDelete(ProfileDelete event, Emitter<ProfileState> emit) async {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      final updatedProfiles = List<Profile>.from(currentState.profiles);

      emit(ProfileLoading());
      try {
        await _profileApi.deleteProfile(event.profileId);

        updatedProfiles.removeWhere((profile) => profile.id == event.profileId);

        pagingController.itemList = updatedProfiles;

        emit(ProfileLoaded(
          profiles: updatedProfiles,
          pageKey: currentState.pageKey,
          isLastPage: currentState.isLastPage,
        ));
      } catch (error) {
        emit(ProfileError(message: error.toString()));
      }
    }
  }
}
