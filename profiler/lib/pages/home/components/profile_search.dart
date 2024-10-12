import 'package:flutter/material.dart';

class ProfileSearch extends StatelessWidget {
  final TextEditingController controller;
  final Function(int) onSearch;

  const ProfileSearch({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: SearchBar(
        controller: controller,
        hintText: 'Search Profile',
        hintStyle: WidgetStateProperty.all(const TextStyle(fontSize: 20)),
        onChanged: (value) => onSearch(0),
        leading: const Icon(Icons.search),
        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 20)),
      ),
    );
  }
}
