import 'package:eventify/bloc/eventBloc.dart';
import 'package:eventify/eventPages/PastEventView.dart';
import 'package:eventify/eventPages/eventView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class OrganizerAttendedEventsList extends StatelessWidget {
  const OrganizerAttendedEventsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<EventBloc>().add(FetchPastEvents());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<EventBloc, EventState>(
              builder: (context, state) {
                if (state is EventLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is EventLoaded) {
                  final events = state.events;

                  if (events.isEmpty) {
                    return const Center(child: Text('No events available'));
                  }

                  return Expanded(
                    // Wrap ListView.builder in Expanded
                    child: ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 15),
                          elevation: 4,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: SizedBox(
                                    height: 80,
                                    width: 90,
                                    child: Image.asset(
                                      'assets/concert.png', // Replace with your image path
                                      width: 70,
                                      height: 90,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _formatDateTime(event.eventTime),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Text(
                                      event.eventName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                IconButton(onPressed: (){

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PastEventView(event),
                                    ),

                                  );
                                }, icon: Icon(Icons.remove_red_eye_outlined))

                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else if (state is EventError) {
                  return Center(
                    child: Text('Error: ${state.error}'),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    String daySuffix(int day) {
      if (day >= 11 && day <= 13) {
        return 'th';
      }
      switch (day % 10) {
        case 1:
          return 'st';
        case 2:
          return 'nd';
        case 3:
          return 'rd';
        default:
          return 'th';
      }
    }

    String formattedDate = DateFormat('d MMM - EEE - h:mm a').format(dateTime);
    int day = dateTime.day;
    String suffix = daySuffix(day);
    String dayWithSuffix = '$day$suffix';

    return formattedDate.replaceFirst('$day', dayWithSuffix);
  }
}
