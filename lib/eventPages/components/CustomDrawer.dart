import 'package:eventify/eventPages/organizer/tabBar.dart';
import 'package:eventify/eventPages/searchEvent.dart';
import 'package:eventify/eventPages/organizer/userEvents.dart';
import 'package:eventify/service/authService.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            accountName: Text(
              "John Doe",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text("johndoe@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage("assets/profileicon.png"), // Add your image path here
            ),
          ),

          // List of Buttons
          ListTile(
            leading: const Icon(Icons.person, color: Colors.blue),
            title: const Text("My Profile"),
            onTap: () {
              // Handle navigation
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
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Tabbar(),
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
      ),
    );
  }
}
