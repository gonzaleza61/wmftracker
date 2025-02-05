import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import './providers/user_weight_info.dart';
import './providers/auth.dart';

import './screens/auth_screen.dart';
import './screens/home_screen.dart';
import './screens/dashboard_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, UserWeightInfo>(
          create: (_) => UserWeightInfo('', '', []),
          update: (ctx, auth, previous) => UserWeightInfo(
              auth.token == null ? '' : auth.token!,
              auth.userId == null ? '' : auth.userId!,
              previous == null ? [] : previous.preMadeList),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Witness My Fitness',
          theme: ThemeData(
            primaryColor: Colors.black,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
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
            ),
          ),
          home: auth.isAuth ? DashboardScreen() : AuthScreen(),
          routes: {
            AuthScreen.routeName: (context) => AuthScreen(),
            HomeScreen.routeName: (context) => HomeScreen(),
            DashboardScreen.routeName: (context) => DashboardScreen(),
          },
        ),
      ),
    );
  }
}
