import 'package:eventify/auth/signup.dart';
import 'package:eventify/bloc/userBloc.dart';
import 'package:eventify/eventPages/ProfileScreen.dart';
import 'package:eventify/eventPages/organizer/organizerTabBar.dart';
import 'package:eventify/eventPages/searchEvent.dart';
import 'package:eventify/eventPages/organizer/userEvents.dart';
import 'package:eventify/eventPages/standardUser/tabBar.dart';
import 'package:eventify/models/User.dart';
import 'package:eventify/service/FirestoreService.dart';
import 'package:eventify/service/authService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<UserBloc>().add(FetchUserData());

    FirestoreService firestoreService = new FirestoreService();
    return Drawer(
      child:
      BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {

          } else if (state is UserLoaded) {
            final user = state.userData;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                 UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  accountName: Text(
                   "${user.name}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: Text("${user.email}"),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage("assets/profileicon.png"), // Add your image path here
                  ),
                ),

                // List of Buttons
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.blue),
                  title: const Text("My Profile"),
                  onTap: () {

                  },
                ),
                ListTile(
                  leading: const Icon(Icons.search, color: Colors.blue),
                  title: const Text("Search Events"),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.event, color: Colors.blue),
                  title: const Text("My Events"),
                  onTap: () async {


                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => user.isOrganizer ? OrganizerTabBar() : StandardTabBar(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.contact_page, color: Colors.blue),
                  title: const Text("Contact Us"),
                  onTap: () {
                    // Handle navigation
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help, color: Colors.blue),
                  title: const Text("FAQs"),
                  onTap: () {
                    // Handle navigation
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.blue),
                  title: const Text("Settings"),
                  onTap: () {
                    // Handle navigation
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () async {
                    AuthService authservice = new AuthService();
                    String? response =  await authservice.FirebaseSignOut();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(response ?? 'An error occurred'),
                          backgroundColor: response == "User signed out successfully"
                              ? Colors.green
                              : Colors.red,
                        ));// Sign out the user
                    Navigator.pushNamed(context, '/login'); // Navigate to the login page
                  },
                ),

              ],
            );
          } else if (state is UserError) {
            return Center(
              child: Text('Error: ${state.error}'),
            );
          }

          return const SizedBox.shrink();
        },
      )


    );
  }
}
