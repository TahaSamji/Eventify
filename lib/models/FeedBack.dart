class Feedback {

  final String userName;
  final String feedback;
  final String eventId;
  final String userId;



  Feedback(
      {required this.userName,
        required this.feedback,
        required this.eventId,
        required this.userId,



      });

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      userName: json['userName'] ?? " Unknown name",
      feedback: json['feedback'] ?? 'Unknown Feedback',
      userId: json['userId'] ?? 'Unknown Id',
      eventId: json['eventId'] ?? 'Unknown Id',




    );
  }
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'feedback': feedback,
      'eventId':eventId,
      'userId':userId

    };
  }
}
