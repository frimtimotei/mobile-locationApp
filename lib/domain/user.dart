class User {
  String firstName;
  String lastName;
  String email;
  String password;

  User({this.firstName, this.lastName, this.email});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        firstName: responseData['firstName'],
        lastName: responseData['lastName'],
        email: responseData['email'],
    );

  }
}
