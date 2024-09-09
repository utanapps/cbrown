class AppUser {
  final String userId;
  final String email;
  final String? username;
  final String? firstName;
  final String? lastName;

  AppUser({
    required this.userId,
    required this.email,
    this.username,
    this.firstName,
    this.lastName,

  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      userId: json['id'],
      email: json['email'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'email': email,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
    };
  }
}