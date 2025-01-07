import 'package:eventify/auth/login.dart'; // Ensure this path is correct
import 'package:eventify/auth/signup.dart';
import 'package:eventify/bloc/bottomNavBloc.dart';
import 'package:eventify/bloc/dateTimeFieldbloc.dart';
import 'package:eventify/bloc/eventBloc.dart';
import 'package:eventify/bloc/feedbackbloc.dart';
import 'package:eventify/bloc/roleChangeBloc.dart';
import 'package:eventify/bloc/userBloc.dart';
import 'package:eventify/service/FirestoreService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  group('authScreen Widget Tests', () {
    testWidgets('LoginScreen renders correctly', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(), // Ensure LoginPage is a valid widget
        ),
      );

      // Verify the widgets are present
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget); // Login button
      expect(find.text("Dont have an account?"), findsOneWidget);
    });
    testWidgets('SignUp renders correctly', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
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

      );


      expect(find.text('Sign Up'), findsAtLeast(2));
      expect(find.text("Sign up as Organizer"), findsOneWidget);
      expect(find.text("Already have an account?"), findsOneWidget);




    });
  });
}
