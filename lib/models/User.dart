class User {
  final String id;
  final String name;
  final String email ;
  final bool isOrganizer;


  User(
      {required this.id,
      required this.name,
      required this.email,
        required this.isOrganizer
     });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'] ?? "77",
        name: json['name'] ?? 'Unnamed',
        email: json['email'] ?? 'Unknown email',
      isOrganizer: json['isOrganizer'] ?? false,

           );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      "isOrganizer":isOrganizer
    };
  }
}
