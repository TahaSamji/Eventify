import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventify/bloc/feedbackbloc.dart';

class FeedbackPage extends StatelessWidget {
  final String eventId;

  const FeedbackPage(this.eventId,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<Feedbackbloc>().add(FetchFeedBack(eventId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: BlocBuilder<Feedbackbloc, FeedbackState>(
        builder: (context, state) {
          if (state is FeedbackLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is FeedbackLoaded) {
            final feedbacks = state.feedbacks;

            if (feedbacks.isEmpty) {
              return Center(child: Text('No Feedback available'));
            }

            return ListView.builder(
              itemCount: feedbacks.length,
              itemBuilder: (context, index) {
                final feedback = feedbacks[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/profileicon.png'),
                  ),
                  title: Text(
                    feedback.userName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(feedback.feedback),
                );
              },
            );
          } else if (state is FeedbackError) {
            return Center(child: Text('Error: ${state.error}'));
          }

          return SizedBox.shrink();
        },
      ),
    );
  }
}
