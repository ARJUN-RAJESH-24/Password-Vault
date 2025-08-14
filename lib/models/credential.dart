class Credential {
  final int? id;
  final String title;
  final String username;
  final String encryptedPassword;

  Credential({
    this.id,
    required this.title,
    required this.username,
    required this.encryptedPassword,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'username': username,
      'encryptedPassword': encryptedPassword,
    };
  }

  factory Credential.fromMap(Map<String, dynamic> map) {
    return Credential(
      id: map['id'],
      title: map['title'],
      username: map['username'],
      encryptedPassword: map['encryptedPassword'],
    );
  }
}