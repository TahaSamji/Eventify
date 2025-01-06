import 'package:eventify/bloc/eventBloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpcomingEvents extends StatelessWidget {
  const UpcomingEvents({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<EventBloc>().add(FetchEvents());

    return  BlocBuilder<EventBloc, EventState>(
      builder: (context, state) {
        if (state is EventLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is EventLoaded) {
          final events = state.events;

          if (events.isEmpty) {
            return const Center(child: Text('No events available'));
          }

          return SizedBox(
            height: 190,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: 190,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(13)),
                            child:
                            SizedBox(

                              height: 120,
                              child: Image.asset(
                                'assets/concert.png',
                                fit: BoxFit.cover,
                              ),
                            )),
                        const SizedBox(height: 8),
                        Text(
                          event.eventName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${event.ticketPrice.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.grey),
                        ),
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
    );
  }
}
