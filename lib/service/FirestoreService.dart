import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/models/Event.dart';
import 'package:eventify/models/FeedBack.dart';
import 'package:eventify/models/User.dart';
import 'package:eventify/service/authService.dart';

class FirestoreService {
  final CollectionReference _eventCollection =
      FirebaseFirestore.instance.collection('Events');
  final CollectionReference _interestCollection =
      FirebaseFirestore.instance.collection('UserInterests');
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference _feedbackCollection =
      FirebaseFirestore.instance.collection('EventsFeedback');
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

  Future<List<Events>> getInterestEvents(String userId) async {
    try {
      final interestQuerySnapshot =
          await _interestCollection.where("userId", isEqualTo: userId).get();

      List<String> eventIds = interestQuerySnapshot.docs
          .map((doc) => doc['eventId'] as String)
          .toList();

      if (eventIds.isEmpty) {
        return [];
      }


      final eventQuerySnapshot = await _eventCollection
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

  Future<List<Events>> getPastEvents(String userId) async {
    try {
      final interestQuerySnapshot = await _interestCollection
          .where("userId", isEqualTo: userId)
          .where("isTicketPayed", isEqualTo: true)
          .get();

      List<String> eventIds = interestQuerySnapshot.docs
          .map((doc) => doc['eventId'] as String)
          .toList();

      if (eventIds.isEmpty) {
        return [];
      }

      final eventQuerySnapshot = await _eventCollection
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
          .where((event) => event.eventTime.isBefore(now))
          .toList();
    } catch (e) {
      print('Error fetching bought events: $e');
      return [];
    }
  }

  Future<List<Events>> getBoughtEvents(String userId) async {
    try {
      final interestQuerySnapshot = await _interestCollection
          .where("userId", isEqualTo: userId)
          .where("isTicketPayed", isEqualTo: true)
          .get();

      List<String> eventIds = interestQuerySnapshot.docs
          .map((doc) => doc['eventId'] as String)
          .toList();

      if (eventIds.isEmpty) {
        return [];
      }

      final eventQuerySnapshot = await _eventCollection
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

  Future<List<Events>> getTrendingEvents() async {
    try {
      final querySnapshot = await _eventCollection
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

  Future<List<Events>> getMyEvents(String? organizerId) async {
    final querySnapshot = await _eventCollection
        .where('organizerId', isEqualTo: organizerId)
        .get();
    return querySnapshot.docs.map((doc) {
      return Events.fromJson({
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      });
    }).toList();
  }

  Future<List<Events>> getUpcomingEvents() async {
    try {
      final querySnapshot = await _eventCollection
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
    Map<String, dynamic>? userData = await fetchUserData(organizerId!);
    print(userData);
    String organizerName = userData?['name'] ?? 'Unknown Organizer';

    await _eventCollection.add({
      'eventName': event.eventName,
      'ticketPrice': event.ticketPrice,
      "organizerId": organizerId,
      "description": event.description,
      "organizerName": organizerName,
      "location": event.location,
      "eventTime": event.eventTime,
      "interestCount": 0
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

      final nameQuerySnapshot = await _eventCollection
          .where('eventName', isEqualTo: searchedValue)
          .get();
      result.addAll(nameQuerySnapshot.docs
          .map((doc) => Events.fromJson({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList());

      final locationQuerySnapshot = await _eventCollection
          .where("location", isEqualTo: searchedValue)
          .get();
      result.addAll(locationQuerySnapshot.docs
          .map((doc) => Events.fromJson({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList());

      final descriptionQuerySnapshot = await _eventCollection
          .where("description", isEqualTo: searchedValue)
          .get();
      result.addAll(descriptionQuerySnapshot.docs
          .map((doc) => Events.fromJson({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList());

      if (double.tryParse(searchedValue) != null) {
        final priceQuerySnapshot = await _eventCollection
            .where("ticketPrice", isEqualTo: double.parse(searchedValue))
            .get();
        result.addAll(priceQuerySnapshot.docs
            .map((doc) => Events.fromJson({
                  'id': doc.id,
                  ...doc.data() as Map<String, dynamic>,
                }))
            .toList());
      }

      final uniqueEvents = result.toSet().toList();

      return uniqueEvents;
    } catch (e) {
      print('Error searching events: $e');
      return [];
    }
  }

  Future<String> addtoInterested(String eventId) async {
    try {
      String? userId = authService.getCurrentUserId();
      final interestDoc1 = await _interestCollection
          .where("eventId", isEqualTo: eventId)
          .where("userId", isEqualTo: userId)
          .where("isTicketPayed", isEqualTo: true)
          .get();
      if (interestDoc1.docs.isNotEmpty) {
        return 'Interest Already Added';
      }


      final interestDoc = await _interestCollection
          .where("eventId", isEqualTo: eventId)
          .where("userId", isEqualTo: userId)
          .where("isTicketPayed", isEqualTo: false)
          .get();

      if (interestDoc.docs.isNotEmpty) {
        return 'Interest Already Added';
      }

      await _eventCollection.doc(eventId).update({
        'interestCount': FieldValue.increment(1),
      });

      await _interestCollection
          .add({'eventId': eventId, 'userId': userId, 'isTicketPayed': false});

      return 'Interest Added Successfully';
    } catch (e) {
      return 'Error updating event: $e';
    }
  }

  Future<bool> getUserRole() async {
    String? userId = authService.getCurrentUserId();
    Map<String, dynamic>? userData = await fetchUserData(userId!);
    print(userData);
    return userData?['isOrganizer'] ?? false;
  }

  Future<String> getUserName() async {
    String? userId = authService.getCurrentUserId();
    Map<String, dynamic>? userData = await fetchUserData(userId!);
    print(userData);
    return userData?['name'] ?? "Unknown";
  }

  Future<String> paymentProcess(String eventId) async {
    try {
      String? userId = authService.getCurrentUserId();

      if (userId == null) {
        return 'User not authenticated';
      }

      final interestDoc = await _interestCollection
          .where("eventId", isEqualTo: eventId)
          .where("userId", isEqualTo: userId)
          .get();

      if (interestDoc.docs.isNotEmpty) {
        if (interestDoc.docs.first['isTicketPayed'] == null) {
          await _interestCollection.doc(interestDoc.docs.first.id).update({
            'isTicketPayed': true,
          });
          return 'Payment Done Successfully';
        }
        if (interestDoc.docs.first['isTicketPayed'] == true) {
          return 'Ticket Already Paid';
        }

        await _interestCollection.doc(interestDoc.docs.first.id).update({
          'isTicketPayed': true,
        });
        return 'Payment Done Successfully';
      }

      await _interestCollection.add({
        'eventId': eventId,
        'userId': userId,
        'isTicketPayed': true,
      });

      return 'Payment Done Successfully';
    } catch (e) {
      return 'Payment Error: $e';
    }
  }

  Future<User?> getUserData(String userId) async {
    try {
      final docSnapshot = await _userCollection.doc(userId).get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        final user = User.fromJson(docSnapshot.data() as Map<String, dynamic>);
        return user;
      } else {
        print('No user found with ID $userId');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    return null;
  }

  Future<String> addFeedBack(
      String eventId, String feedback, String name) async {
    try {
      String? userId = authService.getCurrentUserId();
      final feedbackDoc = await _feedbackCollection
          .where("eventId", isEqualTo: eventId)
          .where("userId", isEqualTo: userId)
          .get();

      if (feedbackDoc.docs.isNotEmpty) {
        return 'FeedBack Already Added';
      }

      await _feedbackCollection.add({
        'eventId': eventId,
        'userId': userId,
        'feedback': feedback,
        'userName': name
      });

      return 'FeedBack Added Successfully';
    } catch (e) {
      return 'Error adding feedback: $e';
    }
  }

  Future<List<Feedback>> getFeedbacksForEvent(String eventId) async {
    try {
      final querySnapshot =
          await _feedbackCollection.where('eventId', isEqualTo: eventId).get();

      return querySnapshot.docs.map((doc) {
        return Feedback.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }).toList();
    } catch (e) {
      throw Exception('Error fetching feedbacks: $e');
    }
  }
}
