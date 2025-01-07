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
}
