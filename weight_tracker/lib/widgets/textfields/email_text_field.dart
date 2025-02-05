import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class EmailTextField extends StatefulWidget {
  final TextEditingController emailController;

  const EmailTextField({
    Key? key,
    required this.emailController,
  }) : super(key: key);

  @override
  State<EmailTextField> createState() => _EmailTextFieldState();
}

class _EmailTextFieldState extends State<EmailTextField> {
  @override
  void initState() {
    super.initState();
    widget.emailController.addListener(onListen);
  }

  @override
  void dispose() {
    widget.emailController.removeListener(onListen);
    super.dispose();
  }

  void onListen() => setState(() {
        print('hello');
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.emailController,
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      validator: (email) => email != null && !EmailValidator.validate(email)
          ? 'Enter a valid email'
          : null,
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        suffixIcon: widget.emailController.text.isEmpty
            ? Container(width: 0)
            : IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  widget.emailController.clear();
                },
              ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        hintText: 'Email',
        hintStyle: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
