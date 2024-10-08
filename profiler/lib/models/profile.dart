class Profile {
  int? id;
  String userName;
  String firstName;
  String lastName;
  String email;

  Profile({
    this.id,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': userName,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] ?? 0,
      userName: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
    );
  }
}
