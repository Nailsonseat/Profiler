import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profiler/pages/home/components/profile_update_dialog.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../bloc/profile/profile_bloc.dart';
import '../../../models/profile.dart';
import 'view_profile_dialog.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    super.key,
    required this.profile,
  });

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: FilledButton.tonal(
        onPressed: () {
            showDialog(
              context: context,
              builder: (context) => ViewProfileDialog(
                profile: profile,
              ),
            );
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.grey[200]),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(15),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      profile.userName,
                      style: GoogleFonts.jost(fontSize: 32),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Name: ${profile.firstName} ${profile.lastName}',
                      style: GoogleFonts.jost(fontSize: 24),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Email: ${profile.email}',
                      style: GoogleFonts.jost(fontSize: 24),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: ResponsiveValue<double?>(context, conditionalValues: [
                        const Condition.largerThan(name: MOBILE, value: 450.0),
                        const Condition.largerThan(name: TABLET, value: 650.0),
                      ]).value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.userName,
                            style: GoogleFonts.jost(fontSize: 42),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Name: ${profile.firstName} ${profile.lastName}',
                            style: GoogleFonts.jost(fontSize: 24),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Email: ${profile.email}',
                            style: GoogleFonts.jost(fontSize: 24),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, state) {
                        return SizedBox(
                          width: 60,
                          height: 60,
                          child: IconButton(
                            onPressed: (state is ProfileLoading)
                                ? () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Profiles are being loaded. Please wait...'),
                                      ),
                                    );
                                  }
                                : () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => ProfileUpdateDialog(
                                        profile: profile,
                                      ),
                                    );
                                  },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(Colors.blue[100]),
                              shape: WidgetStateProperty.all(const CircleBorder()),
                            ),
                            icon: const Icon(Icons.edit, color: Colors.blue),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 30),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: IconButton(
                        onPressed: () => context.read<ProfileBloc>().add(ProfileDelete(profileId: profile.id!)),
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
