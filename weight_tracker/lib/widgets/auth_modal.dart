import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

import '../models/http_exception.dart';

import '../widgets/buttons/auth_elev_button.dart';
import '../widgets/textfields/email_text_field.dart';
import '../widgets/textfields/pw_text_field.dart';

class AuthModalSheet extends StatefulWidget {
  final bool authSignUp;

  const AuthModalSheet(this.authSignUp, {super.key});

  @override
  State<AuthModalSheet> createState() => _AuthModalSheetState();
}

class _AuthModalSheetState extends State<AuthModalSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final String authModeTrue = 'Create Account';
  final String authModeFalse = 'Login';

  var _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('An Error Occurred!'),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                  onPressed: (() {
                    Navigator.of(context).pop();
                  }),
                  child: Text('Okay'),
                ),
              ],
            ));
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (widget.authSignUp == true) {
        await Provider.of<Auth>(context, listen: false)
            .signUp(emailController.text.trim(), pwController.text.trim());
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signIn(emailController.text.trim(), pwController.text.trim());
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SizedBox(
        height: widget.authSignUp ? 550 : 400,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 40,
            horizontal: 25,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.authSignUp)
                  Text(
                    'Create an account',
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (!widget.authSignUp)
                  Text(
                    'Login to your account',
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                EmailTextField(emailController: emailController),
                PasswordTextField(pwController: pwController),
                if (widget.authSignUp == true)
                  TextFormField(
                    enabled: widget.authSignUp == true,
                    obscureText: true,
                    validator: (value) {
                      if (value != pwController.text) {
                        return 'The Passwords Do Not Match';
                      }
                      return null;
                    },
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      hintText: 'Confirm Password',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 40,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
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
                    onPressed: _submit,
                    child:
                        Text(widget.authSignUp ? authModeTrue : authModeFalse),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
