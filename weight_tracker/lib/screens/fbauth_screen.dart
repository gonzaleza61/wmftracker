import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLogin = true; // Toggle between Sign In and Sign Up

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error signing in with Google: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void authenticate(BuildContext context) async {
    try {
      if (isLogin) {
        // Sign In
        await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } else {
        // Sign Up
        await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool isLargeScreen = screenSize.width > 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(isLargeScreen
                ? 'lib/assets/WMFlogoExtended.PNG'
                : 'lib/assets/WMFlogo.PNG'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.3),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: "Email",
                                prefixIcon:
                                    Icon(Icons.email, color: Colors.red),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                            ),
                            SizedBox(height: 16),
                            TextField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: "Password",
                                prefixIcon: Icon(Icons.lock, color: Colors.red),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                              obscureText: true,
                              autofillHints: isLogin
                                  ? const [AutofillHints.password]
                                  : const [AutofillHints.newPassword],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => authenticate(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding:
                            EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        isLogin ? "Sign In" : "Sign Up",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: Text(
                        isLogin
                            ? "Create an account"
                            : "Already have an account? Sign In",
                        style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: signInWithGoogle,
                      icon: Image.asset(
                        'lib/assets/google_logo.png',
                        height: 24,
                      ),
                      label: Text(
                        "Sign in with Google",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
