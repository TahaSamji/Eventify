import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/models/Event.dart';


class MockFirestoreService {
  final FirebaseFirestore firestore;


  MockFirestoreService({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Events>> getEvents() async {
    final querySnapshot = await firestore.collection('events').get();
    return querySnapshot.docs.map((doc) {
      return Events.fromJson({
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      });
    }).toList();
  }

  Future<String> deleteEvent(String eventId) async {
    try {
       await firestore.collection('events').doc(eventId).delete();

      return 'Event deleted successfully';
    } catch (e) {
      return 'Error deleting event: $e';
    }
  }
  Future<String> updateEvent(Events updatedEvent) async {
    try {
      await firestore.collection('events').doc(updatedEvent.id).update({
        'eventName': updatedEvent.eventName,
        'ticketPrice': updatedEvent.ticketPrice,
        'description': updatedEvent.description,
        'location': updatedEvent.location,
        'eventTime': updatedEvent.eventTime,
      });
      return 'Event Updated successfully';
    } catch (e) {
      return 'Error updating event: $e';
    }
  }
  Future<String> createEvent(Events event) async {


    await firestore.collection("events").add({
      'eventName': event.eventName,
      'ticketPrice': event.ticketPrice,
      "organizerId": "organizerId",
      "description": event.description,
      "organizerName": "organizerName",
      "location": event.location,
      "eventTime": event.eventTime,
      "interestCount": 0
    });
    return "Event Created Successfully";
  }
  Future<List<Events>> getTrendingEvents() async {
    try {
      final querySnapshot = await firestore.collection("events")
          .orderBy('interestCount', descending: true)
          .limit(6)
          .get();

      return querySnapshot.docs.map((doc) {
        return Events.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }).toList();
    } catch (e) {
      print('Error fetching trending events: $e');
      return [];
    }
  }
  Future<List<Events>> getUpcomingEvents() async {
    try {
      final querySnapshot = await firestore.collection("events")
          .where('eventTime', isGreaterThanOrEqualTo: Timestamp.now())
          .orderBy('eventTime', descending: false)
          .limit(6)
          .get();

      return querySnapshot.docs.map((doc) {
        return Events.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }).toList();
    } catch (e) {
      print('Error fetching upcoming events: $e');
      return [];
    }
  }
  Future<String> addtoInterested(String eventId) async {
    try {
      String? userId = "6";
      final interestDoc1 = await firestore.collection("UserInterests")
          .where("eventId", isEqualTo: eventId)
          .where("userId", isEqualTo: userId)
          .where("isTicketPayed", isEqualTo: true)
          .get();
      if (interestDoc1.docs.isNotEmpty) {
        return 'Interest Already Added';
      }


      final interestDoc = await firestore.collection("UserInterests")
          .where("eventId", isEqualTo: eventId)
          .where("userId", isEqualTo: userId)
          .where("isTicketPayed", isEqualTo: false)
          .get();

      if (interestDoc.docs.isNotEmpty) {
        return 'Interest Already Added';
      }

      await firestore.collection("events").doc(eventId).update({
        'interestCount': FieldValue.increment(1),
      });

      await firestore.collection("UserInterests")
          .add({'eventId': eventId, 'userId': userId, 'isTicketPayed': false});

      return 'Interest Added Successfully';
    } catch (e) {
      return 'Error updating event: $e';
    }
  }
  Future<String> paymentProcess(String eventId) async {
    try {
      String? userId = "6";

      if (userId == null) {
        return 'User not authenticated';
      }

      final interestDoc = await firestore.collection("UserInterests")
          .where("eventId", isEqualTo: eventId)
          .where("userId", isEqualTo: userId)
          .get();

      if (interestDoc.docs.isNotEmpty) {
        if (interestDoc.docs.first['isTicketPayed'] == null) {
          await firestore.collection("UserInterests").doc(interestDoc.docs.first.id).update({
            'isTicketPayed': true,
          });
          return 'Payment Done Successfully';
        }
        if (interestDoc.docs.first['isTicketPayed'] == true) {
          return 'Ticket Already Paid';
        }

        await firestore.collection("UserInterests").doc(interestDoc.docs.first.id).update({
          'isTicketPayed': true,
        });
        return 'Payment Done Successfully';
      }

      await firestore.collection("UserInterests").add({
        'eventId': eventId,
        'userId': userId,
        'isTicketPayed': true,
      });

      return 'Payment Done Successfully';
    } catch (e) {
      return 'Payment Error: $e';
    }
  }

  Future<List<Events>> getBoughtEvents(String userId) async {
    try {
      final interestQuerySnapshot = await firestore.collection("UserInterests")
          .where("userId", isEqualTo: userId)
          .where("isTicketPayed", isEqualTo: true)
          .get();

      List<String> eventIds = interestQuerySnapshot.docs
          .map((doc) => doc['eventId'] as String)
          .toList();

      if (eventIds.isEmpty) {
        return [];
      }

      final eventQuerySnapshot = await firestore.collection("events")
          .where(FieldPath.documentId, whereIn: eventIds)
          .get();

      DateTime now = DateTime.now();
      return eventQuerySnapshot.docs
          .map((doc) {
        return Events.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      })
          .where((event) => event.eventTime.isAfter(now))
          .toList();
    } catch (e) {
      print('Error fetching bought events: $e');
      return [];
    }
  }
  Future<List<Events>> getInterestEvents(String userId) async {
    try {
      final interestQuerySnapshot =
      await firestore.collection("UserInterests").where("userId", isEqualTo: userId).get();

      List<String> eventIds = interestQuerySnapshot.docs
          .map((doc) => doc['eventId'] as String)
          .toList();

      if (eventIds.isEmpty) {
        return [];
      }


      final eventQuerySnapshot = await firestore.collection("events")
          .where(FieldPath.documentId, whereIn: eventIds)
          .get();


      return eventQuerySnapshot.docs.map((doc) {
        return Events.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }).toList();
    } catch (e) {
      print('Error fetching interest events: $e');
      return [];
    }
  }


}
