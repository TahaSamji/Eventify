import 'package:eventify/auth/login.dart';
import 'package:eventify/auth/signup.dart';
import 'package:eventify/bloc/bottomNavBloc.dart';
import 'package:eventify/bloc/dateTimeFieldbloc.dart';
import 'package:eventify/bloc/eventBloc.dart';
import 'package:eventify/bloc/feedbackbloc.dart';
import 'package:eventify/bloc/roleChangeBloc.dart';
import 'package:eventify/bloc/userBloc.dart';
import 'package:eventify/eventPages/eventPage.dart';
import 'package:eventify/eventPages/homePage.dart';
import 'package:eventify/service/FirestoreService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() async {
  await loadAppFonts();
  testWidgets("golden tests", (WidgetTester tester)async{
    await tester.pumpWidget( MaterialApp(
      home: MaterialApp(
        home:  LoginPage()),

    ),);
    await expectLater(find.byType(LoginPage ),matchesGoldenFile("login_file.PNG"));

  });
  testWidgets("golden tests", (WidgetTester tester)async{
    await tester.pumpWidget( MaterialApp(
      home:MaterialApp(
        home: MultiBlocProvider(providers: [
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
        ], child: const SignUp()),
      ),




    ),);
    await expectLater(find.byType(SignUp ),matchesGoldenFile("Signup_file.PNG"));

  });
}