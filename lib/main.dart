import 'package:eventify/auth/login.dart';
import 'package:eventify/auth/signup.dart';
import 'package:eventify/bloc/bottomNavBloc.dart';
import 'package:eventify/bloc/dateTimeFieldbloc.dart';
import 'package:eventify/bloc/eventBloc.dart';
import 'package:eventify/bloc/roleChangeBloc.dart';
import 'package:eventify/eventPages/eventView.dart';
import 'package:eventify/eventPages/homePage.dart';
import 'package:eventify/service/FirestoreService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

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
        '/signup': (context) => SignUp()
      },
    );
  }
}
