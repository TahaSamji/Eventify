import 'package:cloud_firestore/cloud_firestore.dart';

class Events {
  final String id;

  final String eventName;
  final double ticketPrice;
  final String description;
  final String location;
  final DateTime eventTime;


  Events({
    required this.id,
    required this.eventName,
    required this.ticketPrice,
    required this.description,
    required this.location,
    required this.eventTime,




  });

  factory Events.fromJson(Map<String, dynamic> json) {
    return Events(
      id: json['id'],
      eventName: json['eventName'] ?? 'Unnamed Event',
      ticketPrice: (json['ticketPrice'] ?? 0).toDouble(),
      description: json['description'] ?? 'Unknown description',
      location: json['location'] ?? 'Unknown location',
      eventTime: (json['eventTime'] is Timestamp)
          ? (json['eventTime'] as Timestamp).toDate()
          : DateTime.parse(json['eventTime'] ?? DateTime.now().toIso8601String()),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventName': eventName,
      'ticketPrice': ticketPrice,
      'description': description,
      'location': location,
      'eventTime': eventTime.toIso8601String(),
    };
  }

}