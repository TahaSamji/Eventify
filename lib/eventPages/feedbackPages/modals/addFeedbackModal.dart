

import 'package:date_field/date_field.dart';
import 'package:eventify/auth/signup.dart';
import 'package:eventify/bloc/dateTimeFieldbloc.dart';
import 'package:eventify/models/Event.dart';
import 'package:eventify/service/FirestoreService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddFeedBackModal extends StatelessWidget {
  final String eventId;
  const AddFeedBackModal(this.eventId,{super.key});


  @override
  Widget build(BuildContext context) {
    final _feedbackController = TextEditingController();

    FirestoreService firestoreService = new FirestoreService();
    return AlertDialog(
      title: Text('Add FeedBack'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _feedbackController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                hintText: "Your Review",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(150.0),
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
            SizedBox(height: 10),

          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {

            final feedback = _feedbackController.text;



            if (feedback.isEmpty ) {

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please enter valid event feedback')),
              );
              return;
            }

            try {
              String name =
              await firestoreService.getUserName();
              String response = await firestoreService.addFeedBack(eventId,feedback,name);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(response ?? 'An error occurred'),
                  backgroundColor: response == "FeedBack Added Successfully"
                      ? Colors.green
                      : Colors.red,
                ),

              );
              Navigator.pop(context); // Close the dialog
            } catch (e) {
              // Handle any errors (e.g., show a snackbar)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to create event: $e')),
              );
            }
          },
          child: Text('Add',style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,

          ),
        ),
      ],
    );
  }
}
