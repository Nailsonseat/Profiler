import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profiler/pages/home/components/profile_update_dialog.dart';
import '../../../models/profile.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    super.key,
    required this.profile,
  });

  final Profile profile;

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
                  Text(profile.userName, style: GoogleFonts.jost(fontSize: 42)),
                  Text('Name: ${profile.firstName} ${profile.lastName}', style: GoogleFonts.jost(fontSize: 24)),
                  Text('Email: ${profile.email}', style: GoogleFonts.jost(fontSize: 24)),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: 60,
                height: 60,
                child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => ProfileUpdateDialog(
                        profile: profile,
                        onUpdate: (updatedProfile) {
                        },
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.blue[100]),
                    shape: WidgetStateProperty.all(const CircleBorder()),
                  ),
                  icon: const Icon(Icons.edit, color: Colors.blue),
                ),
              ),
              const SizedBox(width: 30),
              SizedBox(
                width: 60,
                height: 60,
                child: IconButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.red[100]),
                    shape: WidgetStateProperty.all(const CircleBorder()),
                  ),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
