import 'package:eventify/bloc/eventBloc.dart';
import 'package:eventify/eventPages/components/ticketPaymentView.dart';
import 'package:eventify/eventPages/feedbackPages/modals/ViewFeedBackScreen.dart';
import 'package:eventify/eventPages/feedbackPages/modals/addFeedbackModal.dart';
import 'package:eventify/models/Event.dart';
import 'package:eventify/service/FirestoreService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PastEventView extends StatelessWidget {
  final Events event;
  const PastEventView(this.event, {super.key});

  String getFormattedDate(DateTime eventTime) {
    return DateFormat('d MMMM, yyyy').format(eventTime);
  }

  String getFormattedTimeRange(DateTime startTime) {
    String day = DateFormat('EEEE').format(startTime);
    String start = DateFormat('h:mm a').format(startTime);
    return '$day, $start';
  }

  @override
  Widget build(BuildContext context) {
    FirestoreService firestoreService = new FirestoreService();
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor:
          Colors.transparent, // Makes the background transparent
          elevation: 0,

          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Colors.black), // Adjust icon color as needed
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
        ),
        body: SizedBox(
          child: Image.asset(
            width: 5000,
            height: 285,
            'assets/concert.png',
            fit: BoxFit.cover,
          ),
        ),
        bottomSheet: FractionallySizedBox(
            heightFactor: 0.7,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "${event.eventName}",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w800),
                            ),
                            Spacer(),
                            Text(
                              "${event.ticketPrice} Rs",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                  color: CupertinoColors.activeBlue),
                            ),
                          ]),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: Row(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                    color: Color.fromRGBO(236, 236, 236, 1.0),
                                    child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Icon(
                                          Icons.calendar_month,
                                          color: Colors.blue,
                                        )))),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${getFormattedDate(event.eventTime)}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                    "${getFormattedTimeRange(event.eventTime)}",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey))
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Row(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                    color: Color.fromRGBO(236, 236, 236, 1.0),
                                    child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Icon(
                                          Icons.location_on,
                                          color: Colors.blue,
                                        )))),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${event.location}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: Row(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                    color: Color.fromRGBO(236, 236, 236, 1.0),
                                    child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Icon(
                                          Icons.account_circle_sharp,
                                          color: Colors.blue,
                                        )))),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${event.organizerName}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text("ORGANIZER",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey))
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "About Event",
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${event.description}",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: ()  {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      AddFeedBackModal(event.id),
                                );
                              },
                              child: Text(
                                "Add Review",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                fixedSize: const Size(130, 30),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            ElevatedButton(
                              onPressed: ()  {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => FeedbackPage(event.id))
                                );
                              },
                              child: Stack(
                                alignment: Alignment
                                    .centerRight, // Aligns the text in the center
                                children: [
                                  Align(
                                    alignment:
                                    Alignment.center, // Center the text
                                    child: Text(
                                      "View Reviews",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                fixedSize: const Size(130, 40),
                              ),
                            )
                          ])
                    ],
                  ),
                ),
              ),
            )));
  }
}
