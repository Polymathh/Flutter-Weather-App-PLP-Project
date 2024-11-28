import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


//importing pages
import 'package:hama_app/pages/register.dart';
import 'package:hama_app/pages/login.dart';
import 'package:hama_app/pages/dashboard.dart';
import 'package:hama_app/pages/buy.dart';
import 'package:hama_app/pages/sell.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);


  runApp(const HamaApp()); // Fixed class name
}

class HamaApp extends StatelessWidget {
  const HamaApp({super.key}); // Fixed constructor name
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hama Fast',
      theme: ThemeData(
        primaryColor: Colors.teal,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
        ).copyWith(
          secondary: Colors.teal,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.teal,
          textTheme: ButtonTextTheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.teal),
            foregroundColor: MaterialStateProperty.all(Colors.white),
            elevation: MaterialStateProperty.all(5.0),
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
     themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register':(context) => RegisterPage(),
        '/dashboard':(context) => DashboardPage(),
        '/buy': (context) => const BuyPage(),
        '/sell': (context) =>  SellPage(),
      },      
    );
  }
}
