import 'package:eventify/bloc/eventBloc.dart';
import 'package:eventify/eventPages/components/ticketPaymentView.dart';
import 'package:eventify/models/Event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EventView extends StatelessWidget {
  final Events event;
  const EventView(this.event, {super.key});

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
                            )
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
                                Text("${getFormattedTimeRange(event.eventTime)}",
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "14 December,2025",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text("${event.location}",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey))
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
                                  "John Doe",
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
                              onPressed: () { Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PaymentView(),
                                ),
                              );},
                              child: Stack(
                                alignment: Alignment
                                    .centerRight, // Aligns the text in the center
                                children: [
                                  Align(
                                    alignment:
                                        Alignment.center, // Center the text
                                    child: Text(
                                      "Buy",
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
                                fixedSize: const Size(150, 30),
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
