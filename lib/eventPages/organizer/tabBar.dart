import 'package:eventify/eventPages/organizer/modals/addEventModal.dart';
import 'package:eventify/eventPages/organizer/userEvents.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Tabbar extends StatelessWidget {
  const Tabbar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Events'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddEventModal(),
                );
              },
              child: Text("Create Event",style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                fixedSize: const Size(140, 30),
              ),
            )
            ,
            SizedBox(width: 10,)
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'My Events'),
              Tab(text: 'Upcoming'),
              Tab(text: 'Past Tickets'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MyEvents(),
            MyEvents(),
            Center(child: Text('Past Tickets')),
          ],
        ),
      ),
    );
  }
}
