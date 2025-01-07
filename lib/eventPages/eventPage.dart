import 'package:eventify/bloc/eventBloc.dart';
import 'package:eventify/eventPages/components/trendingEventList.dart';
import 'package:eventify/eventPages/components/upcomingEventsList.dart';
import 'package:eventify/service/FirestoreService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Trending Events",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/allEvents');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text("View All"),
                        SizedBox(width: 4), // Adds some spacing between the text and the icon
                        Icon(Icons.arrow_forward, size: 16), // Adjust the size as needed
                      ],
                    ),
                  ),



                ],
              ),
              const SizedBox(height: 5),
              BlocProvider(
                create: (context) => EventBloc(FirestoreService())..add(FetchTrendingEvents()),
                child: TrendingEvents(),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Upcoming Events",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/allEvents');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text("View All"),
                        SizedBox(width: 4), // Adds some spacing between the text and the icon
                        Icon(Icons.arrow_forward, size: 16), // Adjust the size as needed
                      ],
                    ),
                  ),

                ],
              ),
              const SizedBox(
                height: 10,
              ),
              BlocProvider(
                create: (context) => EventBloc(FirestoreService())..add(FetchUpcomingEvents()),
                child: UpcomingEvents(),
              ),
              SizedBox(
                height:15
                ,
              ),
              ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                  child: Container(
                      color: Color.fromARGB(
                          255, 173, 251, 251), // Fully opaque cyan
                      width: 450,
                      height: 150,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Invite Your friends",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  "Get 20\$ for ticket",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      fixedSize: const Size(150, 30),
                                    ),
                                    onPressed: () {},
                                    child: Text(
                                      "Invite",
                                      style: TextStyle(color: Colors.white),
                                    ))
                              ],
                            ),
                            SizedBox(
                              width: 159,
                              height: 110,
                              child: Image.asset(
                                'assets/inviteprop.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
