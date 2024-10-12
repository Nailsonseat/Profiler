import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profiler/constants/validators.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../bloc/profile/profile_bloc.dart';
import '../../../components/labelled_text_field.dart';
import '../../../models/profile.dart';

class ProfileUpdateDialog extends StatelessWidget {
  ProfileUpdateDialog({
    super.key,
    required this.profile,
  });

  final Profile profile;

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _userNameController.text = profile.userName;
    _firstNameController.text = profile.firstName;
    _lastNameController.text = profile.lastName;
    _emailController.text = profile.email;


    bool isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return AlertDialog(
      title: Text(
        'Update Profile',
        style: GoogleFonts.poppins(fontSize: 42),
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ResponsiveRowColumn(
                layout: isMobile ? ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
                children: [
                  ResponsiveRowColumnItem(
                    child: LabelledTextField(
                      label: 'User Name',
                      hintText: 'Enter User Name',
                      controller: _userNameController,
                      validator: (value) => Validators.usernameValidator(value),
                    ),
                  ),
                  const ResponsiveRowColumnItem(child: SizedBox(width: 20, height: 20)),
                  ResponsiveRowColumnItem(
                    child: LabelledTextField(
                      label: 'First Name',
                      hintText: 'Enter First Name',
                      controller: _firstNameController,
                      validator: (value) => Validators.nameValidator(value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ResponsiveRowColumn(
                layout: isMobile ? ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
                children: [
                  ResponsiveRowColumnItem(
                    child: LabelledTextField(
                      label: 'Last Name',
                      hintText: 'Enter Last Name',
                      controller: _lastNameController,
                      validator: (value) => Validators.nameValidator(value),
                    ),
                  ),
                  const ResponsiveRowColumnItem(child: SizedBox(width: 20, height: 20)),
                  ResponsiveRowColumnItem(
                    child: LabelledTextField(
                      label: 'Email',
                      hintText: 'Enter Email',
                      controller: _emailController,
                      validator: (value) => Validators.emailValidator(value),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return SizedBox(
              width: 110,
              height: 50,
              child: FilledButton.tonal(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.orange[100]),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                ),
                onPressed: (state is ProfileLoading)
                    ? () {}
                    : () {
                        context.pop();
                      },
                child: Text('Cancel', style: TextStyle(color: Colors.orange[900], fontSize: 15)),
              ),
            );
          },
        ),
        const SizedBox(width: 10),
        BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoaded) {
              context.pop();
              if(context.canPop()) {
                context.pop();
              }
            }
          },
          builder: (context, state) {
            return SizedBox(
              width: 130,
              height: 50,
              child: FilledButton.tonal(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue[100]),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                ),
                onPressed: (state is ProfileLoading)
                    ? () {}
                    : () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ProfileBloc>().add(
                                ProfileUpdate(
                                  updatedProfile: Profile(
                                    id: profile.id,
                                    userName: _userNameController.text,
                                    firstName: _firstNameController.text,
                                    lastName: _lastNameController.text,
                                    email: _emailController.text,
                                  ),
                                ),
                              );
                        }
                      },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Update', style: TextStyle(color: Colors.blue, fontSize: 15)),
                    if (state is ProfileLoading) const SizedBox(width: 10),
                    if (state is ProfileLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: Colors.blue,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
