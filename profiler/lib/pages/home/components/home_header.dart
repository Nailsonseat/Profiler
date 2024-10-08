import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveRowColumn(
      layout: ResponsiveRowColumnType.ROW,
      children: [
        ResponsiveRowColumnItem(child: Text('Profiles', style: GoogleFonts.poppins(fontSize: 120))),
        const ResponsiveRowColumnItem(child: Spacer()),
        ResponsiveRowColumnItem(
          child: SizedBox(
            width: 220,
            height: 70,
            child: FilledButton.tonal(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.purpleAccent[50]),
                shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              ),
              child: Text('Log Out', style: GoogleFonts.poppins(fontSize: 26)),
            ),
          ),
        ),
      ],
    );
  }
}
