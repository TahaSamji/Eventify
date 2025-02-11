import 'package:date_field/date_field.dart';
import 'package:eventify/bloc/dateTimeFieldbloc.dart';
import 'package:eventify/models/Event.dart';
import 'package:eventify/service/FirestoreService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditEventModal extends StatelessWidget {
   final Events event;
  const EditEventModal(this.event,{super.key});


  @override
  Widget build(BuildContext context) {
    final _eventNameController = TextEditingController(text: event.eventName);
    final _ticketPriceController = TextEditingController(text: event.ticketPrice.toString());
    final _descriptionController = TextEditingController(text: event.description);
    final _locationController = TextEditingController(text: event.location);
    FirestoreService firestoreService = new FirestoreService();
    return AlertDialog(
      title: Text('Edit Event'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(

              controller: _eventNameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                hintText: "Your Event Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(150.0),
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(

              keyboardType: TextInputType.number,
              controller: _ticketPriceController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                hintText: "Ticket Price",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(150.0),
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
            SizedBox(height: 10),
            BlocBuilder<DateTimeBloc, DateTimeState>(
              builder: (context, state) {
                return DateTimeFormField(

                  decoration: InputDecoration(
                    labelText: 'Event Date & Time',
                    border: OutlineInputBorder(),
                  ),
                  mode: DateTimeFieldPickerMode.dateAndTime,
                  initialValue: event.eventTime,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<DateTimeBloc>().add(DateTimeChanged(value));
                    }
                  },
                );
              },
            ),
            SizedBox(height: 10),

            TextFormField(

              controller: _locationController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                hintText: "Location",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(150.0),
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
            SizedBox(height: 10),

            TextFormField(

              controller: _descriptionController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                hintText: "About Event",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(150.0),
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
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

            final eventName = _eventNameController.text;
            double ticketPrice  = double.parse(_ticketPriceController.text) ;
            final description = _descriptionController.text;
            final location = _locationController.text;
            final dateTime = context.read<DateTimeBloc>().state.dateTime;


            if (eventName.isEmpty || ticketPrice <= 0) {
              // Handle validation error (e.g., show a snackbar)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please enter valid event details')),
              );
              return;
            }

            final updatedEvent = Events(
                id: event.id,
                eventName: eventName,
                ticketPrice: ticketPrice,
                description: description,
                location:location,
                eventTime: dateTime,
                organizerName: event.organizerName

            );

            try {
              String response = await firestoreService.updateEvent(updatedEvent);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(response ?? 'An error occurred'),
                  backgroundColor: response == "Event Updated successfully"
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
          child: Text('Save',style: TextStyle(color: Colors.white),),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,

          ),
        ),
      ],
    );
  }
}
