import 'package:eventify/auth/login.dart';
import 'package:eventify/auth/signup.dart';
import 'package:eventify/bloc/bottomNavBloc.dart';
import 'package:eventify/bloc/dateTimeFieldbloc.dart';
import 'package:eventify/bloc/eventBloc.dart';
import 'package:eventify/bloc/feedbackbloc.dart';
import 'package:eventify/bloc/roleChangeBloc.dart';
import 'package:eventify/bloc/userBloc.dart';
import 'package:eventify/eventPages/homePage.dart';
import 'package:eventify/eventPages/searchEvent.dart';
import 'package:eventify/service/FirestoreService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: const FirebaseOptions(
      apiKey: "AIzaSyCQmnwHIa7yd9azx_OEqRmjgdiu8Eqsqf4",
      authDomain: "app-dev-project-9e75f.firebaseapp.com",
      projectId: "app-dev-project-9e75f",
      storageBucket: "app-dev-project-9e75f.firebasestorage.app",
      messagingSenderId: "597945776841",
      appId: "1:597945776841:web:64898a876c4d2d104d6b18",
      measurementId: "G-CPN63D6EYP"));

  runApp(MultiBlocProvider(providers: [
    BlocProvider<BottomNavBloc>(
      create: (_) => BottomNavBloc(),
    ),
    BlocProvider<EventBloc>(
      create: (_) => EventBloc(FirestoreService()),
    ),
    BlocProvider(
      create: (context) => RoleSelectionBloc(),
    ),
    BlocProvider(
      create: (context) => DateTimeBloc(),
    ),
    BlocProvider(
      create: (context) => UserBloc(FirestoreService()),
    ),
    BlocProvider(
      create: (context) => Feedbackbloc(FirestoreService()),
    ),
  ], child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUp(),
      routes: {
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUp(),
        '/allEvents': (context) => SearchPage()
      },
    );
  }
}
