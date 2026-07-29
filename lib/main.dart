import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:personal_mobile/screens/splash_screen.dart';

void main() async{
  // Required before calling any Firebase function
  WidgetsFlutterBinding.ensureInitialized();

  // Connects the app to our Firebase project using google-services.json
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
      ),
      home: SplashScreen(),
    );
  }
}
