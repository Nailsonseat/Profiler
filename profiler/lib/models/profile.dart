class Profile {
  String userName;
  String firstName;
  String lastName;
  String email;

  Profile({
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      userName: json['userName'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
    );
  }
}
