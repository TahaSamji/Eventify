import 'package:eventify/service/FirestoreService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteConfirmationModal extends StatelessWidget {
  final String eventId;
  const DeleteConfirmationModal(this.eventId, {super.key});

  @override
  Widget build(BuildContext context) {
    FirestoreService firestoreService = new FirestoreService();
    return AlertDialog(
      title: Text(
        "Are you sure you want to Delete this Event?",
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                fixedSize: const Size(100, 30),
              ),
            ),
            SizedBox(
              width: 4,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  String response = await firestoreService.deleteEvent(eventId);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(response ?? 'An error occurred'),
                        backgroundColor: response == "Event deleted successfully"
                            ? Colors.green
                            : Colors.red,
                      ),

                    );
                  Navigator.pop(context);


                } catch (e) {
                  print("Error ${e}");
                  Navigator.pop(context);
                }
              },
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                fixedSize: const Size(100, 30),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
