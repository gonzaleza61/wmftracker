import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController pwController;
  const PasswordTextField({Key? key, required this.pwController})
      : super(key: key);

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  @override
  void initState() {
    super.initState();
    widget.pwController.addListener(onListen);
  }

  @override
  void dispose() {
    super.dispose();
    widget.pwController.dispose();
  }

  void onListen() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.pwController,
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty || value.length < 5) {
          return 'Password is too short!';
        }
        return null;
      },
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        suffixIcon: widget.pwController.text.isEmpty
            ? Container(width: 0)
            : IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  widget.pwController.clear();
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
        hintText: 'Password',
        hintStyle: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
