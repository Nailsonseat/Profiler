import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.userName,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: FilledButton.tonal(
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.grey[200]),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(15),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userName, style: GoogleFonts.jost(fontSize: 42)),
                  Text('Name: $firstName $lastName', style: GoogleFonts.jost(fontSize: 24)),
                  Text('Email: $email', style: GoogleFonts.jost(fontSize: 24)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
