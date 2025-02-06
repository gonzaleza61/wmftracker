import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/auth_modal.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  @override
  void dispose() {
    _userEmail.dispose();
    _userPassword.dispose();
    _signUpUserEmail.dispose();
    _signUpUserPassword.dispose();
    _signUpUserPWConfirm.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userEmail = TextEditingController();
  final TextEditingController _userPassword = TextEditingController();
  final TextEditingController _signUpUserEmail = TextEditingController();
  final TextEditingController _signUpUserPassword = TextEditingController();
  final TextEditingController _signUpUserPWConfirm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding:
            const EdgeInsets.only(top: 120, left: 12, right: 12, bottom: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 110,
                  width: 70,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Image(
                      image: AssetImage('lib/assets/WMFlogo.PNG'),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'WITNESS MY',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.red[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      'FITNESS',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        height: 0.8,
                      ),
                    ),
                    const Text(
                      'WEIGHT TRACKER',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        height: 0.8,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(children: [
                  Positioned(
                    bottom: 18,
                    child: Container(
                      height: 20,
                      width: 108,
                      color: const Color.fromARGB(255, 246, 209, 206),
                    ),
                  ),
                  Text(
                    'SHARE',
                    style: GoogleFonts.bebasNeue(fontSize: 80),
                  ),
                ]),
                Stack(children: [
                  Positioned(
                    bottom: 18,
                    child: Container(
                      height: 20,
                      width: 138,
                      color: const Color.fromARGB(255, 246, 209, 206),
                    ),
                  ),
                  Text(
                    'INSPIRE',
                    style: GoogleFonts.bebasNeue(fontSize: 80),
                  ),
                ]),
                Stack(children: [
                  Positioned(
                    bottom: 18,
                    child: Container(
                      height: 20,
                      width: 180,
                      color: const Color.fromARGB(255, 246, 209, 206),
                    ),
                  ),
                  Text(
                    'INFLUENCE',
                    style: GoogleFonts.bebasNeue(fontSize: 80),
                  ),
                ]),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.red[300],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                      context: context,
                      builder: (context) {
                        return AuthModalSheet(true);
                      },
                    );
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.red[300],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        context: context,
                        builder: (context) {
                          return AuthModalSheet(false);
                        },
                      );
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
