import 'package:eventify/eventPages/organizer/modals/addEventModal.dart';
import 'package:eventify/eventPages/organizer/organizerAttendedEvents.dart';
import 'package:eventify/eventPages/organizer/organizerPayedEvents.dart';
import 'package:eventify/eventPages/organizer/userEvents.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrganizerTabBar extends StatelessWidget {
  const OrganizerTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            Navigator.pushNamed(context, '/home');
          }, icon: Icon(Icons.arrow_back,color: Colors.black,)),
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
          bottom: const TabBar(
            tabs: [
              Tab(text: 'My Events'),
              Tab(text: 'Going'),
              Tab(text: 'Past Events'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MyEvents(),
            OrganizerPayedEvents(),
           OrganizerAttendedEventsList(),
          ],
        ),
      ),
    );
  }
}
