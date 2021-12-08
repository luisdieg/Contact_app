class UserModel {
  String? uid;
  String? email;
  String? name;
  String? lastName;

  UserModel({this.uid, this.email, this.name, this.lastName});

  //data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      lastName: map['lastName'],
    );
  }

  //sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'lastName': lastName,
    };
  }
}