import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/models/Event.dart';
import 'package:eventify/service/authService.dart';

class FirestoreService {
  final CollectionReference _eventCollection =
      FirebaseFirestore.instance.collection('Events');
  AuthService authService = new AuthService();

  Future<List<Events>> getEvents() async {
    final querySnapshot = await _eventCollection.get();
    return querySnapshot.docs.map((doc) {
      return Events.fromJson({
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      });
    }).toList();
  }

  Future<Map<String, dynamic>?> fetchUserData(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('Users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return userDoc.data();
      } else {
        print('No user data found');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');

      return null;
    }
  }

  Future<String> createEvent(Events event) async {

    String? organizerId = authService.getCurrentUserId();
    await _eventCollection.add({
      'eventName': event.eventName,
      'ticketPrice': event.ticketPrice,
      "organizerId": organizerId,
      "description": event.description,
      "location": event.location,
      "eventTime": event.eventTime
    });
    return "Event Created Successfully";
  }

  Future<String> deleteEvent(String eventId) async {
    try {
      await _eventCollection.doc(eventId).delete();
      return 'Event deleted successfully';
    } catch (e) {
      return 'Error deleting event: $e';
    }
  }

  Future<String> updateEvent(Events updatedEvent) async {
    try {
      await _eventCollection.doc(updatedEvent.id).update({
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

  Future<List<Events>> searchEvents(String searchedValue) async {
    try {
      List<Events> result = [];

      // Fetch results by eventName
      final nameQuerySnapshot = await _eventCollection
          .where('eventName', isEqualTo: searchedValue)
          .get();
      result.addAll(nameQuerySnapshot.docs.map((doc) => Events.fromJson({
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      })).toList());

      // Fetch results by location
      final locationQuerySnapshot = await _eventCollection
          .where("location", isEqualTo: searchedValue)
          .get();
      result.addAll(locationQuerySnapshot.docs.map((doc) => Events.fromJson({
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      })).toList());

      // Fetch results by description
      final descriptionQuerySnapshot = await _eventCollection
          .where("description", isEqualTo: searchedValue)
          .get();
      result.addAll(descriptionQuerySnapshot.docs.map((doc) => Events.fromJson({
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      })).toList());

      // Fetch results by ticketPrice if the searched value can be parsed to a double
      if (double.tryParse(searchedValue) != null) {
        final priceQuerySnapshot = await _eventCollection
            .where("ticketPrice", isEqualTo: double.parse(searchedValue))
            .get();
        result.addAll(priceQuerySnapshot.docs.map((doc) => Events.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        })).toList());
      }

      // Optional: Remove duplicates based on the unique id
      final uniqueEvents = result.toSet().toList();

      return uniqueEvents;
    } catch (e) {
      print('Error searching events: $e');
      return [];
    }
  }

  // Future<List<Events>> TrendingEvents(String searchedValue) async {
  //   try{
  //     final QuerySnapshot = await _eventCollection
  //         .where('eventName', isEqualTo: searchedValue)
  //         .get();
  //   }
  //   catch(e){
  //
  //   }

  Future<String> addtoInterested(String eventId) async {
    try {
      await _eventCollection.doc(eventId).update({
        'interestCount': FieldValue.increment(1),
      });
      return 'Event Updated successfully';
    } catch (e) {
      return 'Error updating event: $e';
    }



  }

  }
