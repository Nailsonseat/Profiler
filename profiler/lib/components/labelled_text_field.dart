import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LabelledTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final double fontSize;
  final double width;
  final double height;
  final FormFieldValidator<String>? validator;
  final int maxLines;
  final bool enabled;

  const LabelledTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.fontSize = 18,
    this.width = 300,
    this.height = 25,
    this.validator,
    this.maxLines = 1,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: fontSize),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: width,
          child: TextFormField(
            enabled: enabled,
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: EdgeInsets.symmetric(vertical: height, horizontal: 20),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}
