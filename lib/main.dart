import 'package:flutter/material.dart';
import 'package:quiz_app_fireship/Screens/login_screen.dart';
import 'package:quiz_app_fireship/Screens/registration_screen.dart';
import 'package:quiz_app_fireship/models/auth.dart';
import 'package:quiz_app_fireship/models/network.dart';
import 'package:quiz_app_fireship/Screens/main_screen.dart';

void main() {
  runApp(FirebaseApp());
}

Network network = Network();
Auth auth = Auth();

class FirebaseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        MainScreen.id: (_) => MainScreen(),
        LoginScreen.id: (_) => LoginScreen(),
        RegistrationScreen.id: (_) => RegistrationScreen(),
      },
      initialRoute: auth.checkLogedIn() ? MainScreen.id : LoginScreen.id,
    );
  }
}

// TODO Create a sing up method using firebase auth (email and google sign in)
// TODO Create a collection in firestore to hold the user permissions to projects
// TODO Implement a validation for the users internet access
// TODO Setup Firebase for IOS
