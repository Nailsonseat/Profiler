import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/profile/profile_bloc.dart';

class ProfileSearchBar extends StatefulWidget {
  final TextEditingController controller;

  const ProfileSearchBar({
    super.key,
    required this.controller,
  });

  @override
  State<ProfileSearchBar> createState() => _ProfileSearchBarState();
}

class _ProfileSearchBarState extends State<ProfileSearchBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: SearchBar(
        controller: widget.controller,
        hintText: 'Search Profile',
        textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 20)),
        hintStyle: WidgetStateProperty.all(const TextStyle(fontSize: 20)),
        trailing: [
          if (widget.controller.text.isNotEmpty) ...[
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  context.read<ProfileBloc>().add(ProfileRefresh());
                  context.read<ProfileBloc>().add(ProfileFetch(pageKey: 0));
                  widget.controller.clear();
                });
              },
            ),
          ]
        ],
        onChanged: (value) {
          setState(() {});
          if (value == '') {
            context.read<ProfileBloc>().add(ProfileRefresh());
            context.read<ProfileBloc>().add(ProfileFetch(pageKey: 0));
          } else {
            context.read<ProfileBloc>().add(ProfileSearch(query: value));
          }
        },
        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 20)),
      ),
    );
  }
}
