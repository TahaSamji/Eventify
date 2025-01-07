import 'package:eventify/eventPages/organizer/userEvents.dart';
import 'package:eventify/eventPages/standardUser/attendedEventsList.dart';
import 'package:eventify/eventPages/standardUser/interestedEventsList.dart';
import 'package:eventify/eventPages/standardUser/payedEventList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StandardTabBar extends StatelessWidget {
  const StandardTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          title: Text('My Events'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Going'),
              Tab(text: 'My Interests'),
              Tab(text: 'Past Events'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PayedEventList(),
            MyInterestEvents(),
            AttendedEventsList()
          ],
        ),
      ),
    );
  }
}
