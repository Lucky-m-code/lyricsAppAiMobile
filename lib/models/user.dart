class User {
  int id;
  String name;
  String email;
  String password;
  String token;
  bool isAdmin;

  User({this.id, this.email, this.name, this.password, this.token, this.isAdmin});


  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
    );
  }

  factory User.fromJsonComplete(Map<String, dynamic> json){
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      token: json['token'],
      isAdmin: true,
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'email': email,
      'name': name,
      'token': token,
      'isAdmin': isAdmin
    };
  }

}