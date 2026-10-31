class User {
  int id;
  String Nama;
  String Email;
  String Password;

  User({
    required this.id,
    required this.Nama,
    required this.Email,
    required this.Password
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'] as int,
        Nama: json['Nama'] as String,
        Email: json['Email'] as String,
        Password: json['Password'] as String,
    );
  }
}