import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/models/Event.dart';
import 'package:eventify/service/FirestoreService.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'service/FirestoreService.dart';

void main() {

  group('getEvents , create,delete,update tests', () {
    late FakeFirebaseFirestore firestore;

    setUp(() {
      firestore = FakeFirebaseFirestore();
    });

    test('should return a list of events from Firestore', () async {
      final doc1 = await firestore.collection('events').add({
        'eventName': 'Music Concert',
        'ticketPrice': 50.0,
        'description': 'A live music concert event.',
        'location': 'Central Park',
        'eventTime': Timestamp.fromDate(DateTime(2023, 12, 31, 20, 0)),
        'organizerName': 'John Doe',
      });

      final doc2 =   await firestore.collection('events').add({
        'eventName': 'Art Exhibition',
        'ticketPrice': 25.0,
        'description': 'An exhibition showcasing local art.',
        'location': 'City Gallery',
        'eventTime': Timestamp.fromDate(DateTime(2024, 1, 15, 10, 0)),
        'organizerName': 'Jane Smith',
      });

      final firestoreService = MockFirestoreService(firestore: firestore);
      final events = await firestoreService.getEvents();

      expect(events.length, 2);
      expect(events[0].eventName, 'Music Concert');
      expect(events[0].ticketPrice, 50.0);
      expect(events[0].location, 'Central Park');
      expect(events[1].eventName, 'Art Exhibition');
      expect(events[1].ticketPrice, 25.0);
      expect(events[1].location, 'City Gallery');

      final deleteMessage = await firestoreService.deleteEvent(doc2.id);


      expect(deleteMessage, 'Event deleted successfully');


      final eventsAfterDelete = await firestoreService.getEvents();
      expect(eventsAfterDelete.length, 1);

      final updatedEvent = Events(
        id: doc1.id,
        eventName: 'Updated Music Concert',
        ticketPrice: 60.0,
        description: 'An updated live music concert event.',
        location: 'Updated Central Park',
        eventTime: DateTime.now(),
        organizerName: "test"
      );

      final updateMessage = await firestoreService.updateEvent(updatedEvent);
      expect(updateMessage, 'Event Updated successfully');


      final updatedEvents = await firestoreService.getEvents();
      expect(updatedEvents.length, 1);
      expect(updatedEvents[0].eventName, 'Updated Music Concert');
      expect(updatedEvents[0].ticketPrice, 60.0);
      expect(updatedEvents[0].location, 'Updated Central Park');


      Events event =  Events(
          id: doc1.id,
          eventName: 'Updated Music Concert',
          ticketPrice: 60.0,
          description: 'An updated live music concert event.',
          location: 'Updated Central Park',
          eventTime: DateTime.now(),
          organizerName: "Test"

      );


      final message = await firestoreService.createEvent(event);
      expect(message, 'Event Created Successfully');

    });
  });
  group('getEvents , Trending and Upcoming Events Test', ()
  {
    late FakeFirebaseFirestore firestore;

    setUp(() {
      firestore = FakeFirebaseFirestore();
    });

    test("trending  test", () async {
      final doc1 = await firestore.collection('events').add({
        'eventName': 'Music Concert',
        'ticketPrice': 50.0,
        'description': 'A live music concert event.',
        'location': 'Central Park',
        'eventTime': Timestamp.fromDate(DateTime(2023, 12, 31, 20, 0)),
        'organizerName': 'John Doe',
        'interestCount': 100
      });

      final doc2 =   await firestore.collection('events').add({
        'eventName': 'Art Exhibition',
        'ticketPrice': 25.0,
        'description': 'An exhibition showcasing local art.',
        'location': 'City Gallery',
        'eventTime': Timestamp.fromDate(DateTime(2024, 1, 15, 10, 0)),
        'organizerName': 'Jane Smith',
        'interestCount': 1000
      });
      final firestoreService = MockFirestoreService(firestore: firestore);
      final events = await firestoreService.getTrendingEvents();

      expect(events.length, 2);
      expect(events[1].eventName, 'Music Concert');
      expect(events[1].ticketPrice, 50.0);
      expect(events[1].location, 'Central Park');
      expect(events[0].eventName, 'Art Exhibition');
      expect(events[0].ticketPrice, 25.0);
      expect(events[0].location, 'City Gallery');


    });
    test("Upcoming Event  test", () async {
      final doc1 = await firestore.collection('events').add({
        'eventName': 'Music Concert',
        'ticketPrice': 50.0,
        'description': 'A live music concert event.',
        'location': 'Central Park',
        'eventTime': Timestamp.fromDate(DateTime(2028, 12, 31, 20, 0)),
        'organizerName': 'John Doe',
        'interestCount': 100
      });

      final doc2 =   await firestore.collection('events').add({
        'eventName': 'Art Exhibition',
        'ticketPrice': 25.0,
        'description': 'An exhibition showcasing local art.',
        'location': 'City Gallery',
        'eventTime': Timestamp.fromDate(DateTime(2022, 1, 15, 10, 0)),
        'organizerName': 'Jane Smith',
        'interestCount': 1000
      });
      final firestoreService = MockFirestoreService(firestore: firestore);
      final events = await firestoreService.getUpcomingEvents();

      expect(events.length, 1);
      expect(events[0].eventName, 'Music Concert');
      expect(events[0].ticketPrice, 50.0);
      expect(events[0].location, 'Central Park');



    });
  });

  group('Interest Events tests', ()
  {
    late FakeFirebaseFirestore firestore;

    setUp(() {
      firestore = FakeFirebaseFirestore();
    });
    test("Interest Events tests", ()async{
      final doc1 = await firestore.collection('events').add({
        'eventName': 'Music Concert',
        'ticketPrice': 50.0,
        'description': 'A live music concert event.',
        'location': 'Central Park',
        'eventTime': Timestamp.fromDate(DateTime(2028, 12, 31, 20, 0)),
        'organizerName': 'John Doe',
        'interestCount': 100
      });
      String? userId = "6";
      final firestoreService = MockFirestoreService(firestore: firestore);

    final response = await  firestoreService.addtoInterested(doc1.id);
      expect(response, "Interest Added Successfully");

      final events = await firestoreService.getInterestEvents(userId);

      expect(events.length, 1);
      expect(events[0].eventName, 'Music Concert');
      expect(events[0].ticketPrice, 50.0);
      expect(events[0].location, 'Central Park');

      final responseFail = await  firestoreService.addtoInterested(doc1.id);
      expect(responseFail, "Interest Already Added");
      final paymentResponse = await  firestoreService.paymentProcess(doc1.id);
      expect(paymentResponse, "Payment Done Successfully");
      final paymentResponseFail = await  firestoreService.paymentProcess(doc1.id);
      expect(paymentResponseFail, "Ticket Already Paid");

      final boughtEvents = await firestoreService.getBoughtEvents(userId);

      expect(boughtEvents.length, 1);
      expect(boughtEvents[0].eventName, 'Music Concert');
      expect(boughtEvents[0].ticketPrice, 50.0);
      expect(boughtEvents[0].location, 'Central Park');



    });
  });


}
