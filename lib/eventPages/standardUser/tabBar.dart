import 'package:eventify/eventPages/organizer/userEvents.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StandartTabBar extends StatelessWidget {
  const StandartTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tickets'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past Events'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
           MyEvents(),
            Center(child: Text('Past Tickets')),
          ],
        ),
      ),
    );
  }
}
