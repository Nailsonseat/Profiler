import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:profiler/bloc/profile/profile_bloc.dart';
import 'package:profiler/models/profile.dart';
import 'profile_tile.dart';

class ProfileList extends StatelessWidget {
  const ProfileList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: PagedListView<int, Profile>(
        pagingController: context.read<ProfileBloc>().pagingController,
        builderDelegate: PagedChildBuilderDelegate<Profile>(
          itemBuilder: (context, item, index) => ProfileTile(profile: item),
        ),
      ),
    );
  }
}
