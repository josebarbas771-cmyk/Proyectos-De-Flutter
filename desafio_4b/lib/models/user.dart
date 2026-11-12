class Address {
  final String city;
  final String zipcode;

  const Address({required this.city, required this.zipcode});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'] as String,
      zipcode: json['zipcode'] as String,
    );
  }
}

class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final Address address;

  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
    );
  }
}
