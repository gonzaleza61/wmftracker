import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthElevatedButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;

  const AuthElevatedButton(this.buttonText, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        textStyle: GoogleFonts.roboto(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.red[800],
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: 55,
          vertical: 20,
        ),
      ),
      onPressed: () => onPressed,
      child: Text(buttonText),
    );
  }
}
