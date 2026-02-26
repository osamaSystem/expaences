class AppUser {
  AppUser({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.currencyCode,
  });

  final int? id;
  final String name;
  final String email;
  final String password;
  final String currencyCode;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'currency_code': currencyCode,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as int?,
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      currencyCode: (map['currency_code'] as String?) ?? 'USD',
    );
  }
}
