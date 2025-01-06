import 'package:eventify/bloc/bottomNavBloc.dart';
import 'package:eventify/bloc/eventBloc.dart';
import 'package:eventify/eventPages/components/CustomDrawer.dart';
import 'package:eventify/eventPages/eventPage.dart';
import 'package:eventify/service/FirestoreService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<Widget> _widgetOptions = <Widget>[
    EventPage(),
    Text('Profile',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Settings',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 10,
        shadowColor: Colors.black,
        title: Text("Event"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            iconSize: 35,
            color: const Color.fromARGB(255, 82, 63, 255),
            tooltip: 'Notification Icon',
            onPressed: () {},
          )
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      drawer: CustomDrawer(),
      body: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          if (state is PageChanged) {
            return Center(
              child: Padding(
                  padding: EdgeInsets.all(15),
                  child: _widgetOptions[state.currentIndex]),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          return BottomNavigationBar(
            backgroundColor: Colors.white,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.cases_outlined),
                  backgroundColor: Colors.black,
                  label: "Events"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline), label: "Profile"),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                label: "Settings",
              ),
            ],
            currentIndex: state is PageChanged ? state.currentIndex : 0,
            selectedItemColor: const Color.fromARGB(255, 82, 63, 255),
            iconSize: 30,
            onTap: (index) {
              context.read<BottomNavBloc>().add(ChangePage(index));
            },
          );
        },
      ),
    );
  }
}
