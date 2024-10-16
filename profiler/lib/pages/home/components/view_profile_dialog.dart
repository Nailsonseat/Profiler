import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profiler/pages/home/components/profile_update_dialog.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../bloc/funny_description/funny_description_bloc.dart';
import '../../../bloc/profile/profile_bloc.dart';
import '../../../constants/constants.dart';
import '../../../models/profile.dart';

class ViewProfileDialog extends StatefulWidget {
  const ViewProfileDialog({super.key, required this.profile});

  final Profile profile;

  @override
  State<ViewProfileDialog> createState() => _ViewProfileDialogState();
}

class _ViewProfileDialogState extends State<ViewProfileDialog> {
  @override
  void initState() {
    super.initState();
    context.read<FunnyDescriptionBloc>().add(CreateProfileEvent(widget.profile));
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaledBox(
      width: ResponsiveValue<double?>(context, conditionalValues: [
        const Condition.smallerThan(name: TABLET, value: AppConstants.mobileScaleWidth),
        const Condition.largerThan(name: MOBILE, value: AppConstants.tabletScaleWidth),
        const Condition.equals(name: DESKTOP, value: AppConstants.desktopScaleWidth),
        const Condition.largerThan(name: DESKTOP, value: AppConstants.desktopScaleWidth),
      ]).value,
      child: SimpleDialog(
        title: const Text('Profile', textAlign: TextAlign.center, style: TextStyle(fontSize: 46)),
        alignment: Alignment.center,
        contentPadding: const EdgeInsets.all(20),
        children: <Widget>[
          const SizedBox(height: 10),
          Text(
            'Username: ${widget.profile.userName}',
            style: GoogleFonts.jost(fontSize: 24),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Text(
            'Name: ${widget.profile.firstName} ${widget.profile.lastName}',
            style: GoogleFonts.jost(fontSize: 24),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Text(
            'Email: ${widget.profile.email}',
            style: GoogleFonts.jost(fontSize: 24),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Text(
            'Description : ',
            style: GoogleFonts.jost(fontSize: 24),
          ),
          const SizedBox(width: 20),
          BlocBuilder<FunnyDescriptionBloc, FunnyDescriptionState>(
            builder: (context, state) {
              if (state is FunnyDescriptionLoading) {
                return const SizedBox(
                  height: 50,
                  width: 50,
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (state is FunnyDescriptionSuccess) {
                return Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Wrap(
                    children: [
                      MarkdownBody(
                        data: state.funnyDescription,
                        styleSheet: MarkdownStyleSheet(
                          p: GoogleFonts.jost(fontSize: 21),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is FunnyDescriptionFailure) {
                return Text(
                  'Error loading funny description: ${state.error}',
                  style: GoogleFonts.jost(fontSize: 18, color: Colors.red),
                );
              }
              return Container();
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                width: 200,
                height: 60,
                child: FilledButton.tonal(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => ProfileUpdateDialog(
                        profile: widget.profile,
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.blue[200]),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 10),
                      Text('Edit', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8.0),
                width: 200,
                height: 60,
                child: FilledButton.tonal(
                  onPressed: () => context.read<ProfileBloc>().add(ProfileDelete(profileId:widget.profile.id!)),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.red[200]),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete),
                      SizedBox(width: 10),
                      Text('Delete', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
